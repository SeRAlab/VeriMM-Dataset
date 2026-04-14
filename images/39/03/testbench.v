`timescale 1ns/1ps

module noise_suppression_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg enable;
    reg [7:0] in_signal;
    wire [7:0] out_signal;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    noise_suppression dut (
        .clk(clk),
        .enable(enable),
        .in_signal(in_signal),
        .out_signal(out_signal)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            enable = 0;
            in_signal = 8'h00;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            $display("Testcase 001: Bypass Mode (enable=0)");
            enable = 0;
            in_signal = 8'hA5;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'hA5);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            $display("Testcase 002: Suppression Mode - Even Sum Average");
            enable = 1;
            in_signal = 8'h20;
            @(posedge clk);
            in_signal = 8'h10;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'h18);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            $display("Testcase 003: Suppression Mode - Odd Sum (Truncation)");
            enable = 1;
            in_signal = 8'h04;
            @(posedge clk);
            in_signal = 8'h05;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'h04);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            $display("Testcase 004: Suppression Mode - Maximum Values");
            enable = 1;
            in_signal = 8'hFF;
            @(posedge clk);
            in_signal = 8'hFF;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'hFF);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            $display("Testcase 005: Transition to Bypass Mode");

            enable = 1;
            in_signal = 8'h80;
            @(posedge clk);

            enable = 0;
            in_signal = 8'h22;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'h22);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = 6;
            $display("Testcase 006: Suppression Mode - Average with Zero");
            enable = 1;
            in_signal = 8'hFF;
            @(posedge clk);
            in_signal = 8'h00;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'h7F);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("noise_suppression Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        
        
// Print summary
        $display("\n========================================");
        $display("Test Summary");
        $display("========================================");
        $display("Tests Passed: %0d", pass_count);
        $display("Tests Failed: %0d", fail_count);
        $display("Total Tests:  %0d", pass_count + fail_count);
        $display("========================================");

        if (fail_count == 0)
            $display("ALL TESTS PASSED!");
        else
            $display("SOME TESTS FAILED!");

        $display("\nSimulation completed at time %0t", $time);
        $finish;
    end

    // Task to check outputs
    task check_outputs;
        input [7:0] expected_out_signal;
        begin
            if (expected_out_signal === (expected_out_signal ^ out_signal ^ expected_out_signal)) begin
                $display("PASS");
                $display("  Outputs: out_signal=%h",
                         out_signal);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out_signal=%h",
                         expected_out_signal);
                $display("  Got:      out_signal=%h",
                         out_signal);
                fail_count = fail_count + 1;
            end
        end
    endtask

    // Timeout watchdog
    initial begin
        #1000000; // 1ms timeout
        $display("\nERROR: Simulation timeout!");
        $finish;
    end

    // Optional: Waveform dump for debugging
    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0,clk, enable, in_signal, out_signal);
    end

endmodule
