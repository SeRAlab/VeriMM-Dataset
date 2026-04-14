`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg reset_n_in;
    wire reset_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .reset_n_in(reset_n_in),
        .reset_out(reset_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        reset_n_in = 1'b1;
        repeat(2) @(posedge clk);
        reset_n_in = 1'b0;
        repeat(2) @(posedge clk);
        reset_n_in = 1'b1;
        @(posedge clk);
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        reset_dut();

        repeat(500) @(posedge clk);
        $display("Test Case 001: Checking if reset_out returns to 0 after completion...");
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        reset_n_in = 1'b1;
        repeat(2) @(posedge clk);
        reset_n_in = 1'b0;
        @(posedge clk);
        $display("Test Case 002: Checking if reset_out is 1 immediately upon reset_n_in assertion...");
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        reset_n_in = 1'b1;
        @(posedge clk);
        reset_n_in = 1'b0;
        repeat(2) @(posedge clk);
        reset_n_in = 1'b1;
        repeat(5) @(posedge clk);
        $display("Test Case 003: Checking if reset_out remains 1 (delayed) after reset_n_in is released...");
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        reset_dut();
        repeat(10) @(posedge clk);
        reset_dut();
        repeat(1000) @(posedge clk);
        $display("Test Case 004: Checking if system reaches 0 after multiple reset pulses...");
        #1;

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
        input expected_reset_out;
        begin
            if (expected_reset_out === (expected_reset_out ^ reset_out ^ expected_reset_out)) begin
                $display("PASS");
                $display("  Outputs: reset_out=%b",
                         reset_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: reset_out=%b",
                         expected_reset_out);
                $display("  Got:      reset_out=%b",
                         reset_out);
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
        $dumpvars(0,clk, reset_n_in, reset_out);
    end

endmodule
