`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] a;
    reg [31:0] b;
    reg [1:0] op;
    wire [31:0] difference;
    wire [31:0] product;
    wire [31:0] quotient;
    wire [31:0] sum;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .op(op),
        .difference(difference),
        .product(product),
        .quotient(quotient),
        .sum(sum)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test Case 001: Addition of positive numbers (100 + 200)");
        a = 32'sd100; b = 32'sd200; op = 2'b00;
        #1;

        check_outputs(0, 0, 0, 300);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case 002: Addition with negative numbers (-50 + 20)");
        a = -32'sd50; b = 32'sd20; op = 2'b00;
        #1;

        check_outputs(0, 0, 0, -30);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test Case 003: Subtraction (100 - 40)");
        a = 32'sd100; b = 32'sd40; op = 2'b01;
        #1;

        check_outputs(60, 0, 0, 0);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test Case 004: Subtraction resulting in negative (20 - 50)");
        a = 32'sd20; b = 32'sd50; op = 2'b01;
        #1;

        check_outputs(-30, 0, 0, 0);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test Case 005: Multiplication (12 * 10)");
        a = 32'sd12; b = 32'sd10; op = 2'b10;
        #1;

        check_outputs(0, 120, 0, 0);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test Case 006: Multiplication with negative (-5 * 8)");
        a = -32'sd5; b = 32'sd8; op = 2'b10;
        #1;

        check_outputs(0, -40, 0, 0);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test Case 007: Division (100 / 10)");
        a = 32'sd100; b = 32'sd10; op = 2'b11;
        #1;

        check_outputs(0, 0, 10, 0);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test Case 008: Division with negative (-100 / 5)");
        a = -32'sd100; b = 32'sd5; op = 2'b11;
        #1;

        check_outputs(0, 0, -20, 0);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        $display("Test Case 009: Integer division truncating (7 / 2)");
        a = 32'sd7; b = 32'sd2; op = 2'b11;
        #1;

        check_outputs(0, 0, 3, 0);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        $display("Test Case 010: Invalid operation (Division by zero)");
        a = 32'sd50; b = 32'sd0; op = 2'b11;
        #1;

        check_outputs(0, 0, 0, 0);
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
        input [31:0] expected_difference;
        input [31:0] expected_product;
        input [31:0] expected_quotient;
        input [31:0] expected_sum;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_difference === (expected_difference ^ difference ^ expected_difference) &&
                expected_product === (expected_product ^ product ^ expected_product) &&
                expected_quotient === (expected_quotient ^ quotient ^ expected_quotient) &&
                expected_sum === (expected_sum ^ sum ^ expected_sum)) begin
                $display("PASS");
                $display("  Outputs: difference=%h, product=%h, quotient=%h, sum=%h",
                         difference, product, quotient, sum);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: difference=%h, product=%h, quotient=%h, sum=%h",
                         expected_difference, expected_product, expected_quotient, expected_sum);
                $display("  Got:      difference=%h, product=%h, quotient=%h, sum=%h",
                         difference, product, quotient, sum);
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
