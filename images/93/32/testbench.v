`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] num1;
    reg [3:0] num2;
    reg [1:0] op;
    wire [3:0] result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .num1(num1),
        .num2(num2),
        .op(op),
        .result(result)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test Case 001: Addition (5 + 3)");
        num1 = 4'd5; num2 = 4'd3; op = 2'b00;
        #1;

        check_outputs(4'd8);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case 002: Addition Overflow (12 + 7)");
        num1 = 4'd12; num2 = 4'd7; op = 2'b00;
        #1;

        check_outputs(4'd3);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test Case 003: Addition Zero Identity (15 + 0)");
        num1 = 4'd15; num2 = 4'd0; op = 2'b00;
        #1;

        check_outputs(4'd15);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test Case 004: Subtraction (10 - 4)");
        num1 = 4'd10; num2 = 4'd4; op = 2'b01;
        #1;

        check_outputs(4'd6);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test Case 005: Subtraction Underflow (3 - 5)");
        num1 = 4'd3; num2 = 4'd5; op = 2'b01;
        #1;

        check_outputs(4'd14);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test Case 006: Subtraction to Zero (8 - 8)");
        num1 = 4'd8; num2 = 4'd8; op = 2'b01;
        #1;

        check_outputs(4'd0);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test Case 007: Multiplication (2 * 3)");
        num1 = 4'd2; num2 = 4'd3; op = 2'b10;
        #1;

        check_outputs(4'd6);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test Case 008: Multiplication Overflow/Truncation (4 * 4)");
        num1 = 4'd4; num2 = 4'd4; op = 2'b10;
        #1;

        check_outputs(4'd0);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        $display("Test Case 009: Multiplication by Zero (15 * 0)");
        num1 = 4'd15; num2 = 4'd0; op = 2'b10;
        #1;

        check_outputs(4'd0);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        $display("Test Case 010: Division (12 / 3)");
        num1 = 4'd12; num2 = 4'd3; op = 2'b11;
        #1;

        check_outputs(4'd4);
    end
        endtask

    task testcase011;

    begin
        test_num = test_num + 1;
        $display("Test Case 011: Division Truncation (15 / 4)");
        num1 = 4'd15; num2 = 4'd4; op = 2'b11;
        #1;

        check_outputs(4'd3);
    end
        endtask

    task testcase012;

    begin
        test_num = test_num + 1;
        $display("Test Case 012: Division by Zero Handling (5 / 0)");
        num1 = 4'd5; num2 = 4'd0; op = 2'b11;
        #1;

        check_outputs(4'd0);
    end
        endtask

    task testcase013;

    begin
        test_num = test_num + 1;
        $display("Test Case 013: Division of Zero (0 / 9)");
        num1 = 4'd0; num2 = 4'd9; op = 2'b11;
        #1;

        check_outputs(4'd0);
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
        testcase011();
        testcase012();
        testcase013();
        
        
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
            #1; // Small delay for combinational logic to settle
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

endmodule
