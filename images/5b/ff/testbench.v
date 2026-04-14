`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg rst;
    reg [31:0] timeout;
    wire wdt;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .rst(rst),
        .timeout(timeout),
        .wdt(wdt)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        rst = 1;
        timeout = 0;
        @(posedge clk);
        #1;
        rst = 0;
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("Test Case 001: Check if wdt asserts after 10 cycles with timeout=10");
        reset_dut();
        timeout = 10;

        repeat(10) @(posedge clk);
        #1;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test Case 002: Check if wdt remains 0 if reset occurs mid-count");
        reset_dut();
        timeout = 20;
        repeat(10) @(posedge clk);
        reset_dut();
        #1;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test Case 003: Check if wdt asserts after 5 cycles with timeout=5");
        reset_dut();
        timeout = 5;
        repeat(5) @(posedge clk);
        #1;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test Case 004: Check if wdt is 0 at cycle 14 when timeout=15");
        reset_dut();
        timeout = 15;
        repeat(14) @(posedge clk);
        #1;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test Case 005: Check for a larger timeout of 100");
        reset_dut();
        timeout = 100;
        repeat(100) @(posedge clk);
        #1;
        #1;

        check_outputs(1'b1);
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
        input expected_wdt;
        begin
            if (expected_wdt === (expected_wdt ^ wdt ^ expected_wdt)) begin
                $display("PASS");
                $display("  Outputs: wdt=%b",
                         wdt);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: wdt=%b",
                         expected_wdt);
                $display("  Got:      wdt=%b",
                         wdt);
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
        $dumpvars(0,clk, rst, timeout, wdt);
    end

endmodule
