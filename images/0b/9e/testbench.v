`timescale 1ns/1ps

module gpio_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] data_in;
    reg enable;
    reg mode;
    reg reset;
    wire [3:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    gpio_controller dut (
        .clk(clk),
        .data_in(data_in),
        .enable(enable),
        .mode(mode),
        .reset(reset),
        .data_out(data_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            enable = 0;
            mode = 0;
            data_in = 4'b0000;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            mode = 1;
            enable = 1;
            data_in = 4'hA;
            @(posedge clk);
            #2;
            $display("Testcase 001: Output Mode Write 4'hA");
            #1;

            check_outputs(4'hA);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            mode = 1;
            enable = 1;
            data_in = 4'h5;
            @(posedge clk);
            #2;


            data_in = 4'hF;


            $display("Testcase 002: Output Mode Hold Check");
            #1;

            check_outputs(4'h5);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            mode = 0;
            enable = 1;
            data_in = 4'hC;
            @(posedge clk);
            #2;
            $display("Testcase 003: Input Mode Read 4'hC");
            #1;

            check_outputs(4'hC);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            mode = 1;
            enable = 1;
            data_in = 4'h7;
            @(posedge clk);
            #2;
            enable = 0;
            @(posedge clk);
            #2;
            $display("Testcase 004: Enable Deactivated (Expect 0/Invalid)");
            #1;

            check_outputs(4'h0);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;

            mode = 1;
            enable = 1;
            data_in = 4'hB;
            @(posedge clk);
            #2;

            mode = 0;
            data_in = 4'h2;
            @(posedge clk);
            #2;
            $display("Testcase 005: Mode Switch Output->Input");
            #1;

            check_outputs(4'h2);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = 6;
            mode = 1;
            enable = 1;
            data_in = 4'hE;
            @(posedge clk);
            #2;
            reset = 1;
            @(posedge clk);
            #2;
            $display("Testcase 006: Reset during Operation");
            #1;

            check_outputs(4'h0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("gpio_controller Testbench");
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
        input [3:0] expected_data_out;
        begin
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h",
                         data_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h",
                         expected_data_out);
                $display("  Got:      data_out=%h",
                         data_out);
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
        $dumpvars(0,clk, data_in, enable, mode, reset, data_out);
    end

endmodule
