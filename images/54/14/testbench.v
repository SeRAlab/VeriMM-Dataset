`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] A;
    reg [7:0] B;
    reg clk;
    reg enable;
    reg reset;
    wire [3:0] count;
    wire [7:0] final_out;
    wire [7:0] quotient;
    wire [7:0] remainder;
    wire valid;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .clk(clk),
        .enable(enable),
        .reset(reset),
        .count(count),
        .final_out(final_out),
        .quotient(quotient),
        .remainder(remainder),
        .valid(valid)
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
        A = 0;
        B = 0;
        @(negedge clk);
        reset = 0;
        @(negedge clk);
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Basic Division (20/4) and 3 Count Cycles", test_num);
        reset_dut();
        A = 8'd20;
        B = 8'd4;
        enable = 1;
        repeat(3) @(negedge clk);
        enable = 0;

        #1;


        check_outputs(4'd3, 8'd8, 8'd5, 8'd0, 1'b1);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Division by Zero (50/0)", test_num);
        reset_dut();
        A = 8'd50;
        B = 8'd0;
        enable = 1;
        repeat(5) @(negedge clk);
        enable = 0;

        #1;


        check_outputs(4'd5, 8'd5, 8'd0, 8'd0, 1'b0);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Counter Rollover (18 cycles)", test_num);
        reset_dut();
        A = 8'd100;
        B = 8'd10;
        enable = 1;
        repeat(18) @(negedge clk);
        enable = 0;

        #1;


        check_outputs(4'd2, 8'd12, 8'd10, 8'd0, 1'b1);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: A less than B (5/12)", test_num);
        reset_dut();
        A = 8'd5;
        B = 8'd12;
        enable = 1;
        repeat(1) @(negedge clk);
        enable = 0;

        #1;


        check_outputs(4'd1, 8'd1, 8'd0, 8'd5, 1'b1);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Large Numbers and 8-bit Sum Overflow", test_num);
        reset_dut();
        A = 8'd250;
        B = 8'd1;
        enable = 1;
        repeat(10) @(negedge clk);
        enable = 0;


        #1;



        check_outputs(4'd10, 8'd4, 8'd250, 8'd0, 1'b1);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Division with Remainder (25/7)", test_num);
        reset_dut();
        A = 8'd25;
        B = 8'd7;
        enable = 1;
        repeat(4) @(negedge clk);
        enable = 0;

        #1;


        check_outputs(4'd4, 8'd7, 8'd3, 8'd4, 1'b1);
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
        input [3:0] expected_count;
        input [7:0] expected_final_out;
        input [7:0] expected_quotient;
        input [7:0] expected_remainder;
        input expected_valid;
        begin
            if (expected_count === (expected_count ^ count ^ expected_count) &&
                expected_final_out === (expected_final_out ^ final_out ^ expected_final_out) &&
                expected_quotient === (expected_quotient ^ quotient ^ expected_quotient) &&
                expected_remainder === (expected_remainder ^ remainder ^ expected_remainder) &&
                expected_valid === (expected_valid ^ valid ^ expected_valid)) begin
                $display("PASS");
                $display("  Outputs: count=%h, final_out=%h, quotient=%h, remainder=%h, valid=%b",
                         count, final_out, quotient, remainder, valid);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: count=%h, final_out=%h, quotient=%h, remainder=%h, valid=%b",
                         expected_count, expected_final_out, expected_quotient, expected_remainder, expected_valid);
                $display("  Got:      count=%h, final_out=%h, quotient=%h, remainder=%h, valid=%b",
                         count, final_out, quotient, remainder, valid);
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
        $dumpvars(0,A, B, clk, enable, reset, count, final_out, quotient, remainder, valid);
    end

endmodule
