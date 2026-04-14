`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg A;
    reg B;
    reg C_in;
    reg clk;
    wire C_out;
    wire Sum;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .C_in(C_in),
        .clk(clk),
        .C_out(C_out),
        .Sum(Sum)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        A = 0;
        B = 0;
        C_in = 0;

        repeat(2) @(posedge clk);
        #1;
    end
        endtask
    task testcase001;

    begin
        $display("Test Case 001: A=0, B=0, C_in=0");
        reset_dut();
        A = 0; B = 0; C_in = 0;
        repeat(2) @(posedge clk);
        #1;
        #1;

        check_outputs(0, 0);
    end
        endtask

    task testcase002;

    begin
        $display("Test Case 002: A=0, B=0, C_in=1");
        reset_dut();
        A = 0; B = 0; C_in = 1;
        repeat(2) @(posedge clk);
        #1;
        #1;

        check_outputs(0, 1);
    end
        endtask

    task testcase003;

    begin
        $display("Test Case 003: A=0, B=1, C_in=0");
        reset_dut();
        A = 0; B = 1; C_in = 0;
        repeat(2) @(posedge clk);
        #1;
        #1;

        check_outputs(0, 1);
    end
        endtask

    task testcase004;

    begin
        $display("Test Case 004: A=0, B=1, C_in=1");
        reset_dut();
        A = 0; B = 1; C_in = 1;
        repeat(2) @(posedge clk);
        #1;
        #1;

        check_outputs(1, 0);
    end
        endtask

    task testcase005;

    begin
        $display("Test Case 005: A=1, B=0, C_in=0");
        reset_dut();
        A = 1; B = 0; C_in = 0;
        repeat(2) @(posedge clk);
        #1;
        #1;

        check_outputs(0, 1);
    end
        endtask

    task testcase006;

    begin
        $display("Test Case 006: A=1, B=0, C_in=1");
        reset_dut();
        A = 1; B = 0; C_in = 1;
        repeat(2) @(posedge clk);
        #1;
        #1;

        check_outputs(1, 0);
    end
        endtask

    task testcase007;

    begin
        $display("Test Case 007: A=1, B=1, C_in=0");
        reset_dut();
        A = 1; B = 1; C_in = 0;
        repeat(2) @(posedge clk);
        #1;
        #1;

        check_outputs(1, 0);
    end
        endtask

    task testcase008;

    begin
        $display("Test Case 008: A=1, B=1, C_in=1");
        reset_dut();
        A = 1; B = 1; C_in = 1;
        repeat(2) @(posedge clk);
        #1;
        #1;

        check_outputs(1, 1);
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
        testcase007();
        testcase008();
        
        
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
        input expected_C_out;
        input expected_Sum;
        begin
            if (expected_C_out === (expected_C_out ^ C_out ^ expected_C_out) &&
                expected_Sum === (expected_Sum ^ Sum ^ expected_Sum)) begin
                $display("PASS");
                $display("  Outputs: C_out=%b, Sum=%b",
                         C_out, Sum);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: C_out=%b, Sum=%b",
                         expected_C_out, expected_Sum);
                $display("  Got:      C_out=%b, Sum=%b",
                         C_out, Sum);
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
        $dumpvars(0,A, B, C_in, clk, C_out, Sum);
    end

endmodule
