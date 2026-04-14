`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg rst;
    wire clk_breath;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .rst(rst),
        .clk_breath(clk_breath)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            @(posedge clk);
            #1 rst = 0;
            $display("DUT Reset at time %0t", $time);
        end
        endtask
    task testcase001;

        begin
            $display("\nRunning Testcase 001: Initial State Check");
            test_num = 1;
            reset_dut();

            @(posedge clk);
            #1 #1;
 check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            $display("\nRunning Testcase 002: Half-cycle High Transition");
            test_num = 2;
            reset_dut();

            repeat(MAX_BREATH / 2) @(posedge clk);
            #1 #1;
 check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            $display("\nRunning Testcase 003: Full-cycle Low Transition");
            test_num = 3;
            reset_dut();

            repeat(MAX_BREATH) @(posedge clk);
            #1 #1;
 check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            $display("\nRunning Testcase 004: Wrap-around Second Cycle High");
            test_num = 4;
            reset_dut();

            repeat(MAX_BREATH + (MAX_BREATH / 2)) @(posedge clk);
            #1 #1;
 check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            $display("\nRunning Testcase 005: Asynchronous Reset During Operation");
            test_num = 5;
            reset_dut();

            repeat(MAX_BREATH / 2) @(posedge clk);
            #1;
            if (clk_breath !== 1'b1) $display("Warning: Logic expected high before reset triggered");


            rst = 1;
            #15;
            rst = 0;
            @(posedge clk);
            #1 #1;
 check_outputs(1'b0);
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
        input expected_clk_breath;
        begin
            if (expected_clk_breath === (expected_clk_breath ^ clk_breath ^ expected_clk_breath)) begin
                $display("PASS");
                $display("  Outputs: clk_breath=%b",
                         clk_breath);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: clk_breath=%b",
                         expected_clk_breath);
                $display("  Got:      clk_breath=%b",
                         clk_breath);
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
        $dumpvars(0,clk, rst, clk_breath);
    end

endmodule
