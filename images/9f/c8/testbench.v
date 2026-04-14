`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] operand_a;
    reg [15:0] operand_b;
    reg [1:0] operation;
    wire [15:0] result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .operand_a(operand_a),
        .operand_b(operand_b),
        .operation(operation),
        .result(result)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Addition (10 + 20)", test_num);
        operation = 2'b00;
        operand_a = 16'd10;
        operand_b = 16'd20;
        #1;

        check_outputs(16'd30);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Addition Overflow (0xFFFF + 1)", test_num);
        operation = 2'b00;
        operand_a = 16'hFFFF;
        operand_b = 16'h0001;
        #1;

        check_outputs(16'h0000);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Subtraction (100 - 45)", test_num);
        operation = 2'b01;
        operand_a = 16'd100;
        operand_b = 16'd45;
        #1;

        check_outputs(16'd55);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Subtraction Negative (10 - 20)", test_num);
        operation = 2'b01;
        operand_a = 16'd10;
        operand_b = 16'd20;
        #1;

        check_outputs(16'hFFF6);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Multiplication (12 * 12)", test_num);
        operation = 2'b10;
        operand_a = 16'd12;
        operand_b = 16'd12;
        #1;

        check_outputs(16'd144);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Multiplication Truncation (1000 * 100)", test_num);
        operation = 2'b10;
        operand_a = 16'd1000;
        operand_b = 16'd100;
        #1;

        check_outputs(16'h86A0);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Division (500 / 5)", test_num);
        operation = 2'b11;
        operand_a = 16'd500;
        operand_b = 16'd5;
        #1;

        check_outputs(16'd100);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Division Remainder (7 / 2)", test_num);
        operation = 2'b11;
        operand_a = 16'd7;
        operand_b = 16'd2;
        #1;

        check_outputs(16'd3);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Division Small/Large (5 / 10)", test_num);
        operation = 2'b11;
        operand_a = 16'd5;
        operand_b = 16'd10;
        #1;

        check_outputs(16'd0);
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
        input [15:0] expected_result;
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
