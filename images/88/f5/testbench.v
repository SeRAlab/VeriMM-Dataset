`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] operand_a;
    reg [7:0] operand_b;
    reg [2:0] operation;
    wire overflow;
    wire [7:0] result;
    wire underflow;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .operand_a(operand_a),
        .operand_b(operand_b),
        .operation(operation),
        .overflow(overflow),
        .result(result),
        .underflow(underflow)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Addition (Normal) - 10 + 20", test_num);
            operation = 3'b000;
            operand_a = 8'd10;
            operand_b = 8'd20;
            #1;

            check_outputs(1'b0, 8'd30, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Addition (Overflow) - 200 + 100", test_num);
            operation = 3'b000;
            operand_a = 8'd200;
            operand_b = 8'd100;

            #1;


            check_outputs(1'b1, 8'd44, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Subtraction (Normal) - 100 - 40", test_num);
            operation = 3'b001;
            operand_a = 8'd100;
            operand_b = 8'd40;
            #1;

            check_outputs(1'b0, 8'd60, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Subtraction (Underflow) - 40 - 100", test_num);
            operation = 3'b001;
            operand_a = 8'd40;
            operand_b = 8'd100;

            #1;


            check_outputs(1'b0, 8'd196, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Multiplication (Normal) - 12 * 10", test_num);
            operation = 3'b010;
            operand_a = 8'd12;
            operand_b = 8'd10;
            #1;

            check_outputs(1'b0, 8'd120, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Multiplication (Overflow) - 40 * 10", test_num);
            operation = 3'b010;
            operand_a = 8'd40;
            operand_b = 8'd10;

            #1;


            check_outputs(1'b1, 8'd144, 1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Division (Normal) - 100 / 5", test_num);
            operation = 3'b011;
            operand_a = 8'd100;
            operand_b = 8'd5;
            #1;

            check_outputs(1'b0, 8'd20, 1'b0);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Division (Floor) - 7 / 2", test_num);
            operation = 3'b011;
            operand_a = 8'd7;
            operand_b = 8'd2;
            #1;

            check_outputs(1'b0, 8'd3, 1'b0);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Addition (Boundary) - 255 + 1", test_num);
            operation = 3'b000;
            operand_a = 8'hFF;
            operand_b = 8'h01;
            #1;

            check_outputs(1'b1, 8'd0, 1'b0);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Subtraction (Zero) - 50 - 50", test_num);
            operation = 3'b001;
            operand_a = 8'd50;
            operand_b = 8'd50;
            #1;

            check_outputs(1'b0, 8'd0, 1'b0);
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
            #1; // Small delay for combinational logic to settle
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

endmodule
