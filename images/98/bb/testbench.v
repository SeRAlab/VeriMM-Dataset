`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [4:0] data_in;
    reg enable;
    reg reset;
    wire [4:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .data_in(data_in),
        .enable(enable),
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
            @(negedge clk);
            reset = 1;
            enable = 0;
            data_in = 0;
            @(negedge clk);
            reset = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Running Testcase%03d: Basic Accumulation", test_num);
            reset_dut();
            @(negedge clk);
            enable = 1;
            data_in = 5;
            repeat (3) @(negedge clk);
            enable = 0;
            #1;

            check_outputs(5'd15);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Running Testcase%03d: Enable Control", test_num);
            reset_dut();
            @(negedge clk);
            enable = 1;
            data_in = 10;
            @(negedge clk);
            enable = 0;
            data_in = 10;
            @(negedge clk);
            enable = 1;
            @(negedge clk);
            enable = 0;
            #1;

            check_outputs(5'd20);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Running Testcase%03d: Overflow Wrap-around", test_num);
            reset_dut();
            @(negedge clk);
            enable = 1;
            data_in = 20;
            @(negedge clk);
            @(negedge clk);
            enable = 0;
            #1;

            check_outputs(5'd8);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Running Testcase%03d: Max Value Boundary", test_num);
            reset_dut();
            @(negedge clk);
            enable = 1;
            data_in = 31;
            @(negedge clk);
            data_in = 1;
            @(negedge clk);
            enable = 0;
            #1;

            check_outputs(5'd0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Running Testcase%03d: Variable Inputs", test_num);
            reset_dut();
            @(negedge clk);
            enable = 1;
            data_in = 1; @(negedge clk);
            data_in = 2; @(negedge clk);
            data_in = 3; @(negedge clk);
            data_in = 4; @(negedge clk);
            enable = 0;
            #1;

            check_outputs(5'd10);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("top_module Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        
        
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
        input [4:0] expected_data_out;
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
        $dumpvars(0,clk, data_in, enable, reset, data_out);
    end

endmodule
