`timescale 1ns/1ps

module shift_register_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] D;
    reg clk;
    reg load;
    reg rst_n;
    wire [7:0] Q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    shift_register dut (
        .D(D),
        .clk(clk),
        .load(load),
        .rst_n(rst_n),
        .Q(Q)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst_n = 0;
            load = 0;
            D = 0;
            #15;
            rst_n = 1;
            #5;
        end
        endtask
    task testcase001;

        begin
            $display("\nTestcase 001: Verifying Reset State");
            reset_dut();

            #1;


            check_outputs(8'h00);
        end
        endtask

    task testcase002;

        begin
            $display("\nTestcase 002: Parallel Load 0xAA");
            reset_dut();
            @(negedge clk);
            load = 1;
            D = 8'hAA;
            @(negedge clk);
            load = 0;

            #1;


            check_outputs(8'hAA);
        end
        endtask

    task testcase003;

        begin
            $display("\nTestcase 003: Shift Right 0x80 three times");
            reset_dut();
            @(negedge clk);
            load = 1;
            D = 8'h80;
            @(negedge clk);
            load = 0;
            repeat (3) @(negedge clk);
            #1;

            check_outputs(8'h10);
        end
        endtask

    task testcase004;

        begin
            $display("\nTestcase 004: Shift Right 0x0F four times (Result 0x00)");
            reset_dut();
            @(negedge clk);
            load = 1;
            D = 8'h0F;
            @(negedge clk);
            load = 0;
            repeat (4) @(negedge clk);
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase005;

        begin
            $display("\nTestcase 005: Interleaved Load and Shift");
            reset_dut();
            @(negedge clk);
            load = 1;
            D = 8'hFF;
            @(negedge clk);
            load = 0;
            repeat (2) @(negedge clk);
            load = 1;
            D = 8'h55;
            @(negedge clk);
            load = 0;
            #1;

            check_outputs(8'h55);
        end
        endtask

    task testcase006;

        begin
            $display("\nTestcase 006: Shift Right 0x01 once");
            reset_dut();
            @(negedge clk);
            load = 1;
            D = 8'h01;
            @(negedge clk);
            load = 0;
            @(negedge clk);
            #1;

            check_outputs(8'h00);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("shift_register Testbench");
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
        input [7:0] expected_Q;
        begin
            if (expected_Q === (expected_Q ^ Q ^ expected_Q)) begin
                $display("PASS");
                $display("  Outputs: Q=%h",
                         Q);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Q=%h",
                         expected_Q);
                $display("  Got:      Q=%h",
                         Q);
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
        $dumpvars(0,D, clk, load, rst_n, Q);
    end

endmodule
