`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] op1;
    reg [7:0] op2;
    wire carry;
    wire error;
    wire overflow;
    wire [7:0] result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .op1(op1),
        .op2(op2),
        .carry(carry),
        .error(error),
        .overflow(overflow),
        .result(result)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Simple Addition (10 + 20)", test_num);
            op1 = 8'd10; op2 = 8'd20;
            #1;

            check_outputs(1'b0, 1'b0, 1'b0, 8'd30);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Addition with Carry (250 + 10)", test_num);
            op1 = 8'd250; op2 = 8'd10;

            #1;


            check_outputs(1'b1, 1'b0, 1'b0, 8'd4);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Addition Signed Overflow (127 + 1)", test_num);
            op1 = 8'h7F; op2 = 8'h01;

            #1;


            check_outputs(1'b0, 1'b0, 1'b1, 8'h80);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Simple Subtraction (50 - 20)", test_num);
            op1 = 8'd50; op2 = 8'd20;
            #1;

            check_outputs(1'b0, 1'b0, 1'b0, 8'd30);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Subtraction Wrap Around (10 - 20)", test_num);
            op1 = 8'd10; op2 = 8'd20;

            #1;


            check_outputs(1'b1, 1'b0, 1'b0, 8'hF6);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Simple Multiplication (12 * 4)", test_num);
            op1 = 8'd12; op2 = 8'd4;
            #1;

            check_outputs(1'b0, 1'b0, 1'b0, 8'd48);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Multiplication Overflow (100 * 3)", test_num);
            op1 = 8'd100; op2 = 8'd3;

            #1;


            check_outputs(1'b0, 1'b0, 1'b1, 8'd44);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Simple Division (100 / 5)", test_num);
            op1 = 8'd100; op2 = 8'd5;
            #1;

            check_outputs(1'b0, 1'b0, 1'b0, 8'd20);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Integer Division (7 / 2)", test_num);
            op1 = 8'd7; op2 = 8'd2;
            #1;

            check_outputs(1'b0, 1'b0, 1'b0, 8'd3);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Division by Zero Error", test_num);
            op1 = 8'd50; op2 = 8'd0;

            #1;


            check_outputs(1'b0, 1'b1, 1'b0, 8'd0);
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
        input expected_carry;
        input expected_error;
        input expected_overflow;
        input [7:0] expected_result;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_carry === (expected_carry ^ carry ^ expected_carry) &&
                expected_error === (expected_error ^ error ^ expected_error) &&
                expected_overflow === (expected_overflow ^ overflow ^ expected_overflow) &&
                expected_result === (expected_result ^ result ^ expected_result)) begin
                $display("PASS");
                $display("  Outputs: carry=%b, error=%b, overflow=%b, result=%h",
                         carry, error, overflow, result);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: carry=%b, error=%b, overflow=%b, result=%h",
                         expected_carry, expected_error, expected_overflow, expected_result);
                $display("  Got:      carry=%b, error=%b, overflow=%b, result=%h",
                         carry, error, overflow, result);
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
