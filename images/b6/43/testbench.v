`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] A;
    reg [7:0] B;
    reg clk;
    reg [1:0] op;
    wire overflow;
    wire [7:0] result;
    wire underflow;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .clk(clk),
        .op(op),
        .overflow(overflow),
        .result(result),
        .underflow(underflow)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        A = 8'd0;
        B = 8'd0;
        op = 2'd0;
        @(posedge clk);
        #1;
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Addition (No Overflow)", test_num);
        reset_dut();
        A = 8'd10;
        B = 8'd20;
        op = 2'b00;
        @(posedge clk);
        #1;
        #1;

        check_outputs(1'b0, 8'd30, 1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Addition (With Overflow)", test_num);
        reset_dut();
        A = 8'd200;
        B = 8'd100;
        op = 2'b00;
        @(posedge clk);
        #1;
        #1;

        check_outputs(1'b1, 8'd44, 1'b0);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Subtraction (No Overflow)", test_num);
        reset_dut();
        A = 8'd50;
        B = 8'd20;
        op = 2'b01;
        @(posedge clk);
        #1;
        #1;

        check_outputs(1'b0, 8'd30, 1'b0);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Subtraction (With Overflow/Borrow)", test_num);
        reset_dut();
        A = 8'd20;
        B = 8'd50;
        op = 2'b01;
        @(posedge clk);
        #1;
        #1;

        check_outputs(1'b1, 8'd226, 1'b0);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Multiplication (No Overflow)", test_num);
        reset_dut();
        A = 8'd12;
        B = 8'd10;
        op = 2'b10;
        @(posedge clk);
        #1;
        #1;

        check_outputs(1'b0, 8'd120, 1'b0);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Multiplication (With Overflow)", test_num);
        reset_dut();
        A = 8'd20;
        B = 8'd20;
        op = 2'b10;
        @(posedge clk);
        #1;
        #1;

        check_outputs(1'b1, 8'd144, 1'b0);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Division (Normal)", test_num);
        reset_dut();
        A = 8'd100;
        B = 8'd4;
        op = 2'b11;
        @(posedge clk);
        #1;
        #1;

        check_outputs(1'b0, 8'd25, 1'b0);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Division (With Remainder)", test_num);
        reset_dut();
        A = 8'd10;
        B = 8'd3;
        op = 2'b11;
        @(posedge clk);
        #1;
        #1;

        check_outputs(1'b0, 8'd3, 1'b0);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Division by Zero (Underflow Check)", test_num);
        reset_dut();
        A = 8'd10;
        B = 8'd0;
        op = 2'b11;
        @(posedge clk);
        #1;
        #1;

        check_outputs(1'b0, result, 1'b1);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Edge Case Addition (MAX + 1)", test_num);
        reset_dut();
        A = 8'hFF;
        B = 8'h01;
        op = 2'b00;
        @(posedge clk);
        #1;
        #1;

        check_outputs(1'b1, 8'h00, 1'b0);
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
        testcase009();
        testcase010();
        
        
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
        input expected_overflow;
        input [7:0] expected_result;
        input expected_underflow;
        begin
            if (expected_overflow === (expected_overflow ^ overflow ^ expected_overflow) &&
                expected_result === (expected_result ^ result ^ expected_result) &&
                expected_underflow === (expected_underflow ^ underflow ^ expected_underflow)) begin
                $display("PASS");
                $display("  Outputs: overflow=%b, result=%h, underflow=%b",
                         overflow, result, underflow);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: overflow=%b, result=%h, underflow=%b",
                         expected_overflow, expected_result, expected_underflow);
                $display("  Got:      overflow=%b, result=%h, underflow=%b",
                         overflow, result, underflow);
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
        $dumpvars(0,A, B, clk, op, overflow, result, underflow);
    end

endmodule
