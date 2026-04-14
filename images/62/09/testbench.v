`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg reset;
    reg [4:0] value;
    wire [4:0] counterOut;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .reset(reset),
        .value(value),
        .counterOut(counterOut)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            @(posedge clk);
            #1;
            reset = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Initial Reset to Value", test_num);
            value = 5'd15;
            reset_dut();
            #1;

            check_outputs(5'd15);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Decrement after 4 cycles", test_num);
            value = 5'd10;
            reset_dut();
            repeat(4) @(posedge clk);
            #1;
            #1;

            check_outputs(5'd6);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Counting down to zero", test_num);
            value = 5'd3;
            reset_dut();
            repeat(3) @(posedge clk);
            #1;
            #1;

            check_outputs(5'd0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Reload value after reaching zero", test_num);
            value = 5'd5;
            reset_dut();
            repeat(6) @(posedge clk);
            #1;
            #1;

            check_outputs(5'd5);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Synchronous reset with new value", test_num);
            value = 5'd20;
            reset_dut();
            repeat(2) @(posedge clk);
            value = 5'd7;
            reset_dut();
            #1;

            check_outputs(5'd7);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Counter with value 0", test_num);
            value = 5'd0;
            reset_dut();
            @(posedge clk);
            #1;
            #1;

            check_outputs(5'd0);
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
        input [4:0] expected_counterOut;
        begin
            if (expected_counterOut === (expected_counterOut ^ counterOut ^ expected_counterOut)) begin
                $display("PASS");
                $display("  Outputs: counterOut=%h",
                         counterOut);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: counterOut=%h",
                         expected_counterOut);
                $display("  Got:      counterOut=%h",
                         counterOut);
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
        $dumpvars(0,clk, reset, value, counterOut);
    end

endmodule
