`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [19:0] note_div;
    reg rst_n;
    wire [15:0] au_left;
    wire [15:0] au_right;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .note_div(note_div),
        .rst_n(rst_n),
        .au_left(au_left),
        .au_right(au_right)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        rst_n = 0;
        note_div = 20'd0;
        @(posedge clk);
        @(posedge clk);
        #1 rst_n = 1;
        @(posedge clk);
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test Case %03d: Reset State Verification", test_num);
        reset_dut();
        note_div = 20'd100;

        #1 #1;
 check_outputs(16'h0000, 16'h0000);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case %03d: Small Divisor Half-Cycle Toggle (note_div=10)", test_num);
        reset_dut();
        note_div = 20'd10;

        repeat(10) @(posedge clk);
        #1;

        #1;


        check_outputs(16'h7FFF, 16'h7FFF);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test Case %03d: Small Divisor Full-Cycle Toggle (note_div=10)", test_num);
        reset_dut();
        note_div = 20'd10;

        repeat(20) @(posedge clk);
        #1;

        #1;


        check_outputs(16'h0000, 16'h0000);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test Case %03d: Medium Divisor Check (note_div=50)", test_num);
        reset_dut();
        note_div = 20'd50;

        repeat(50) @(posedge clk);
        #1;
        #1;

        check_outputs(16'h7FFF, 16'h7FFF);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test Case %03d: Large Divisor Check (note_div=500)", test_num);
        reset_dut();
        note_div = 20'd500;

        repeat(500) @(posedge clk);
        #1;
        #1;

        check_outputs(16'h7FFF, 16'h7FFF);
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
        input [15:0] expected_au_left;
        input [15:0] expected_au_right;
        begin
            if (expected_au_left === (expected_au_left ^ au_left ^ expected_au_left) &&
                expected_au_right === (expected_au_right ^ au_right ^ expected_au_right)) begin
                $display("PASS");
                $display("  Outputs: au_left=%h, au_right=%h",
                         au_left, au_right);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: au_left=%h, au_right=%h",
                         expected_au_left, expected_au_right);
                $display("  Got:      au_left=%h, au_right=%h",
                         au_left, au_right);
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
        $dumpvars(0,clk, note_div, rst_n, au_left, au_right);
    end

endmodule
