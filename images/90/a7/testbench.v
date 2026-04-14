`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg count;
    reg rst;
    wire [3:0] counter_value;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .count(count),
        .rst(rst),
        .counter_value(counter_value)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        rst = 1;
        count = 0;
        @(posedge clk);
        #1;
        rst = 0;
        @(posedge clk);
        #1;
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("Test Case 001: Basic Reset");
        reset_dut();

        #1;


        check_outputs(4'h0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test Case 002: Increment to 5");
        reset_dut();
        count = 1;
        repeat(5) @(posedge clk);
        #1;
        count = 0;
        #1;

        check_outputs(4'h5);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test Case 003: Hold Value (Enable behavior)");
        reset_dut();
        count = 1;
        repeat(3) @(posedge clk);
        #1;
        count = 0;
        repeat(3) @(posedge clk);
        #1;
        #1;

        check_outputs(4'h3);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test Case 004: Counter Overflow (15 to 0)");
        reset_dut();
        count = 1;
        repeat(16) @(posedge clk);
        #1;
        count = 0;
        #1;

        check_outputs(4'h0);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test Case 005: Overflow and continue (Count to 18)");
        reset_dut();
        count = 1;
        repeat(18) @(posedge clk);
        #1;
        count = 0;
        #1;

        check_outputs(4'h2);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test Case 006: Reset during operation");
        reset_dut();
        count = 1;
        repeat(7) @(posedge clk);
        #1;
        rst = 1;
        @(posedge clk);
        #1;
        rst = 0;
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
        input [3:0] expected_counter_value;
        begin
            if (expected_counter_value === (expected_counter_value ^ counter_value ^ expected_counter_value)) begin
                $display("PASS");
                $display("  Outputs: counter_value=%h",
                         counter_value);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: counter_value=%h",
                         expected_counter_value);
                $display("  Got:      counter_value=%h",
                         counter_value);
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
        $dumpvars(0,clk, count, rst, counter_value);
    end

endmodule
