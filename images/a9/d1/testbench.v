`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg mode_select;
    reg reset;
    reg signal;
    wire [31:0] duration;
    wire falling_edge;
    wire rising_edge;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .mode_select(mode_select),
        .reset(reset),
        .signal(signal),
        .duration(duration),
        .falling_edge(falling_edge),
        .rising_edge(rising_edge)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            signal = 0;
            mode_select = 0;
            repeat(2) @(posedge clk);
            #1 reset = 0;
            repeat(1) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("\nTestcase %03d: 10-cycle Pulse Duration", test_num);
            reset_dut();
            mode_select = 1;
            @(posedge clk);
            #1 signal = 1;
            repeat(10) @(posedge clk);
            #1 signal = 0;
            @(posedge clk);
            #1;

            check_outputs(32'd10, 1'b1, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTestcase %03d: 1-cycle Pulse Duration", test_num);
            reset_dut();
            mode_select = 1;
            @(posedge clk);
            #1 signal = 1;
            @(posedge clk);
            #1 signal = 0;
            @(posedge clk);
            #1;

            check_outputs(32'd1, 1'b1, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTestcase %03d: Mode Select Disabled", test_num);
            reset_dut();
            mode_select = 0;
            @(posedge clk);
            #1 signal = 1;
            repeat(5) @(posedge clk);
            #1 signal = 0;
            @(posedge clk);

            #1;


            check_outputs(32'd0, 1'b0, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTestcase %03d: 100-cycle Pulse Duration", test_num);
            reset_dut();
            mode_select = 1;
            @(posedge clk);
            #1 signal = 1;
            repeat(100) @(posedge clk);
            #1 signal = 0;
            @(posedge clk);
            #1;

            check_outputs(32'd100, 1'b1, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nTestcase %03d: Reset during high pulse", test_num);
            reset_dut();
            mode_select = 1;
            @(posedge clk);
            #1 signal = 1;
            repeat(5) @(posedge clk);
            reset = 1;
            @(posedge clk);
            reset = 0;
            repeat(5) @(posedge clk);
            #1 signal = 0;
            @(posedge clk);

            #1;


            check_outputs(32'd0, 1'b0, 1'b0);
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
        input [31:0] expected_duration;
        input expected_falling_edge;
        input expected_rising_edge;
        begin
            if (expected_duration === (expected_duration ^ duration ^ expected_duration) &&
                expected_falling_edge === (expected_falling_edge ^ falling_edge ^ expected_falling_edge) &&
                expected_rising_edge === (expected_rising_edge ^ rising_edge ^ expected_rising_edge)) begin
                $display("PASS");
                $display("  Outputs: duration=%h, falling_edge=%b, rising_edge=%b",
                         duration, falling_edge, rising_edge);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: duration=%h, falling_edge=%b, rising_edge=%b",
                         expected_duration, expected_falling_edge, expected_rising_edge);
                $display("  Got:      duration=%h, falling_edge=%b, rising_edge=%b",
                         duration, falling_edge, rising_edge);
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
        $dumpvars(0,clk, mode_select, reset, signal, duration, falling_edge, rising_edge);
    end

endmodule
