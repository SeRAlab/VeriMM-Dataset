`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] op1;
    reg [7:0] op2;
    reg [1:0] op_sel;
    wire [7:0] diff;
    wire [7:0] product;
    wire [7:0] quotient;
    wire [7:0] sum;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .op1(op1),
        .op2(op2),
        .op_sel(op_sel),
        .diff(diff),
        .product(product),
        .quotient(quotient),
        .sum(sum)
    );
    task testcase001;

    begin
        test_num = 1;
        op1 = 8'd10;
        op2 = 8'd5;
        op_sel = 2'd0;
        $display("Test %0d: Addition (10 + 5)", test_num);

        #1;


        check_outputs(8'd0, 8'd0, 8'd0, 8'd15);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        op1 = 8'd20;
        op2 = 8'd8;
        op_sel = 2'd1;
        $display("Test %0d: Subtraction (20 - 8)", test_num);

        #1;


        check_outputs(8'd12, 8'd0, 8'd0, 8'd0);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        op1 = 8'd12;
        op2 = 8'd4;
        op_sel = 2'd2;
        $display("Test %0d: Multiplication (12 * 4)", test_num);

        #1;


        check_outputs(8'd0, 8'd48, 8'd0, 8'd0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        op1 = 8'd100;
        op2 = 8'd5;
        op_sel = 2'd3;
        $display("Test %0d: Division (100 / 5)", test_num);

        #1;


        check_outputs(8'd0, 8'd0, 8'd20, 8'd0);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        op1 = 8'd250;
        op2 = 8'd10;
        op_sel = 2'd0;
        $display("Test %0d: Addition Overflow (250 + 10 = 260 -> 4)", test_num);

        #1;


        check_outputs(8'd0, 8'd0, 8'd0, 8'd4);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        op1 = 8'd5;
        op2 = 8'd10;
        op_sel = 2'd1;
        $display("Test %0d: Subtraction Underflow (5 - 10 = -5 -> 251)", test_num);

        #1;


        check_outputs(8'd251, 8'd0, 8'd0, 8'd0);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        op1 = 8'd20;
        op2 = 8'd20;
        op_sel = 2'd2;
        $display("Test %0d: Multiplication Overflow (20 * 20 = 400 -> 144)", test_num);

        #1;


        check_outputs(8'd0, 8'd144, 8'd0, 8'd0);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        op1 = 8'd20;
        op2 = 8'd3;
        op_sel = 2'd3;
        $display("Test %0d: Division Integer Truncation (20 / 3)", test_num);

        #1;


        check_outputs(8'd0, 8'd0, 8'd6, 8'd0);
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
        input [7:0] expected_diff;
        input [7:0] expected_product;
        input [7:0] expected_quotient;
        input [7:0] expected_sum;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_diff === (expected_diff ^ diff ^ expected_diff) &&
                expected_product === (expected_product ^ product ^ expected_product) &&
                expected_quotient === (expected_quotient ^ quotient ^ expected_quotient) &&
                expected_sum === (expected_sum ^ sum ^ expected_sum)) begin
                $display("PASS");
                $display("  Outputs: diff=%h, product=%h, quotient=%h, sum=%h",
                         diff, product, quotient, sum);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: diff=%h, product=%h, quotient=%h, sum=%h",
                         expected_diff, expected_product, expected_quotient, expected_sum);
                $display("  Got:      diff=%h, product=%h, quotient=%h, sum=%h",
                         diff, product, quotient, sum);
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
