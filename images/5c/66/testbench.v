`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] A;
    reg [7:0] B;
    reg [1:0] op;
    wire error;
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
        .op(op),
        .error(error),
        .overflow(overflow),
        .result(result),
        .underflow(underflow)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Addition (15 + 25)", test_num);
            A = 8'd15;
            B = 8'd25;
            op = 2'b00;
            #1;

            check_outputs(1'b0, 1'b0, 8'd40, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Addition (-10 + -20)", test_num);
            A = -8'd10;
            B = -8'd20;
            op = 2'b00;
            #1;

            check_outputs(1'b0, 1'b0, -8'd30, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Subtraction (50 - 20)", test_num);
            A = 8'd50;
            B = 8'd20;
            op = 2'b01;
            #1;

            check_outputs(1'b0, 1'b0, 8'd30, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Subtraction (10 - 30)", test_num);
            A = 8'd10;
            B = 8'd30;
            op = 2'b01;
            #1;

            check_outputs(1'b0, 1'b0, -8'd20, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Multiplication (10 * 12)", test_num);
            A = 8'd10;
            B = 8'd12;
            op = 2'b10;
            #1;

            check_outputs(1'b0, 1'b0, 8'd120, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Multiplication Overflow (16 * 10)", test_num);
            A = 8'd16;
            B = 8'd10;
            op = 2'b10;
            #1;

            check_outputs(1'b0, 1'b1, 8'hA0, 1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Multiplication Underflow (-20 * 8)", test_num);
            A = -8'd20;
            B = 8'd8;
            op = 2'b10;
            #1;

            check_outputs(1'b0, 1'b0, 8'h60, 1'b1);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Division (100 / 5)", test_num);
            A = 8'd100;
            B = 8'd5;
            op = 2'b11;
            #1;

            check_outputs(1'b0, 1'b0, 8'd20, 1'b0);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Division (-60 / 3)", test_num);
            A = -8'd60;
            B = 8'd3;
            op = 2'b11;
            #1;

            check_outputs(1'b0, 1'b0, -8'd20, 1'b0);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Division by Zero (50 / 0)", test_num);
            A = 8'd50;
            B = 8'd0;
            op = 2'b11;

            #1;


            check_outputs(1'b1, 1'b0, result, 1'b0);
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
        input expected_error;
        input expected_overflow;
        input [7:0] expected_result;
        input expected_underflow;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_error === (expected_error ^ error ^ expected_error) &&
                expected_overflow === (expected_overflow ^ overflow ^ expected_overflow) &&
                expected_result === (expected_result ^ result ^ expected_result) &&
                expected_underflow === (expected_underflow ^ underflow ^ expected_underflow)) begin
                $display("PASS");
                $display("  Outputs: error=%b, overflow=%b, result=%h, underflow=%b",
                         error, overflow, result, underflow);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: error=%b, overflow=%b, result=%h, underflow=%b",
                         expected_error, expected_overflow, expected_result, expected_underflow);
                $display("  Got:      error=%b, overflow=%b, result=%h, underflow=%b",
                         error, overflow, result, underflow);
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
