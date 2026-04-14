`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg Clk;
    reg [3:0] CountTo;
    reg Enable;
    reg Reset;
    wire [3:0] Count;
    wire Overflow;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .Clk(Clk),
        .CountTo(CountTo),
        .Enable(Enable),
        .Reset(Reset),
        .Count(Count),
        .Overflow(Overflow)
    );

    // Clock generation (10ns period)
    initial begin
        Clk = 0;
        forever #5 Clk = ~Clk;
    end

        task reset_dut;

    begin
        @(negedge Clk);
        Reset = 1;
        Enable = 0;
        CountTo = 0;
        @(negedge Clk);
        Reset = 0;
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test Case 001: Basic counting to CountTo-1");
        reset_dut();
        CountTo = 4'd5;
        Enable = 1;
        repeat(5) @(negedge Clk);
        #1;

        check_outputs(4'd5, 1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case 002: Overflow wraparound");
        reset_dut();
        CountTo = 4'd3;
        Enable = 1;
        repeat(4) @(negedge Clk);
        #1;

        check_outputs(4'd0, 1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test Case 003: Enable signal test");
        reset_dut();
        CountTo = 4'd10;
        Enable = 1;
        repeat(4) @(negedge Clk);
        Enable = 0;
        repeat(3) @(negedge Clk);
        #1;

        check_outputs(4'd4, 1'b0);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test Case 004: Reset mid-operation");
        reset_dut();
        CountTo = 4'd15;
        Enable = 1;
        repeat(8) @(negedge Clk);
        Reset = 1;
        @(negedge Clk);
        Reset = 0;
        #1;

        check_outputs(4'd0, 1'b0);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test Case 005: Max count (15) overflow");
        reset_dut();
        CountTo = 4'hF;
        Enable = 1;
        repeat(16) @(negedge Clk);
        #1;

        check_outputs(4'd0, 1'b1);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test Case 006: CountTo = 0 (Immediate Overflow)");
        reset_dut();
        CountTo = 4'd0;
        Enable = 1;
        @(negedge Clk);
        #1;

        check_outputs(4'd0, 1'b1);
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
        input [3:0] expected_Count;
        input expected_Overflow;
        begin
            if (expected_Count === (expected_Count ^ Count ^ expected_Count) &&
                expected_Overflow === (expected_Overflow ^ Overflow ^ expected_Overflow)) begin
                $display("PASS");
                $display("  Outputs: Count=%h, Overflow=%b",
                         Count, Overflow);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Count=%h, Overflow=%b",
                         expected_Count, expected_Overflow);
                $display("  Got:      Count=%h, Overflow=%b",
                         Count, Overflow);
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
        $dumpvars(0,Clk, CountTo, Enable, Reset, Count, Overflow);
    end

endmodule
