`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] operand1;
    reg [3:0] operand2;
    reg [1:0] operation;
    reg rst;
    wire [3:0] result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .operand1(operand1),
        .operand2(operand2),
        .operation(operation),
        .rst(rst),
        .result(result)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        rst = 1;
        operand1 = 0;
        operand2 = 0;
        operation = 0;
        @(posedge clk);
        #1 rst = 0;
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        reset_dut();
        operand1 = 4'd5;
        operand2 = 4'd3;
        operation = 2'b00;
        @(posedge clk);
        #1;
        $display("Test Case %0d: Addition (5 + 3)", test_num);
        #1;

        check_outputs(4'd8);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        reset_dut();
        operand1 = 4'd10;
        operand2 = 4'd4;
        operation = 2'b01;
        @(posedge clk);
        #1;
        $display("Test Case %0d: Subtraction (10 - 4)", test_num);
        #1;

        check_outputs(4'd6);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        reset_dut();
        operand1 = 4'd3;
        operand2 = 4'd4;
        operation = 2'b10;
        @(posedge clk);
        #1;
        $display("Test Case %0d: Multiplication (3 * 4)", test_num);
        #1;

        check_outputs(4'd12);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        reset_dut();
        operand1 = 4'd15;
        operand2 = 4'd3;
        operation = 2'b11;
        @(posedge clk);
        #1;
        $display("Test Case %0d: Division (15 / 3)", test_num);
        #1;

        check_outputs(4'd5);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        reset_dut();
        operand1 = 4'd12;
        operand2 = 4'd7;
        operation = 2'b00;
        @(posedge clk);
        #1;
        $display("Test Case %0d: Addition Overflow (12 + 7)", test_num);
        #1;

        check_outputs(4'd3);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        reset_dut();
        operand1 = 4'd2;
        operand2 = 4'd5;
        operation = 2'b01;
        @(posedge clk);
        #1;
        $display("Test Case %0d: Subtraction Underflow (2 - 5)", test_num);
        #1;

        check_outputs(4'd13);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        reset_dut();
        operand1 = 4'd5;
        operand2 = 4'd5;
        operation = 2'b10;
        @(posedge clk);
        #1;
        $display("Test Case %0d: Multiplication Truncation (5 * 5)", test_num);
        #1;

        check_outputs(4'd9);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        reset_dut();
        operand1 = 4'd7;
        operand2 = 4'd2;
        operation = 2'b11;
        @(posedge clk);
        #1;
        $display("Test Case %0d: Division Floor (7 / 2)", test_num);
        #1;

        check_outputs(4'd3);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;

        reset_dut();
        operand1 = 4'd8;
        operand2 = 4'd8;
        operation = 2'b00;
        @(posedge clk);
        #1;

        rst = 1;
        @(posedge clk);
        #1;
        $display("Test Case %0d: Reset Verification", test_num);
        #1;

        check_outputs(4'd0);
        rst = 0;
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
        input [3:0] expected_result;
        begin
            if (expected_result === (expected_result ^ result ^ expected_result)) begin
                $display("PASS");
                $display("  Outputs: result=%h",
                         result);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: result=%h",
                         expected_result);
                $display("  Got:      result=%h",
                         result);
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
        $dumpvars(0,clk, operand1, operand2, operation, rst, result);
    end

endmodule
