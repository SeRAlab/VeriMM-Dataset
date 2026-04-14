`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] a;
    reg [15:0] b;
    reg [1:0] op;
    wire [15:0] difference;
    wire [15:0] product;
    wire [15:0] quotient;
    wire [15:0] sum;

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
        $display("Test Case %0d: Addition (10 + 20)", test_num);
        a = 16'd10;
        b = 16'd20;
        op = 2'b00;
        #1;

        check_outputs(16'd0, 16'd0, 16'd0, 16'd30);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Addition Overflow (0xFFFF + 1)", test_num);
        a = 16'hFFFF;
        b = 16'h0001;
        op = 2'b00;
        #1;

        check_outputs(16'd0, 16'd0, 16'd0, 16'h0000);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Subtraction (50 - 10)", test_num);
        a = 16'd50;
        b = 16'd10;
        op = 2'b01;
        #1;

        check_outputs(16'd40, 16'd0, 16'd0, 16'd0);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Subtraction Underflow (5 - 10)", test_num);
        a = 16'd5;
        b = 16'd10;
        op = 2'b01;
        #1;

        check_outputs(16'hFFFB, 16'd0, 16'd0, 16'd0);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Multiplication (12 * 12)", test_num);
        a = 16'd12;
        b = 16'd12;
        op = 2'b10;
        #1;

        check_outputs(16'd0, 16'd144, 16'd0, 16'd0);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Multiplication Overflow (256 * 256)", test_num);
        a = 16'h0100;
        b = 16'h0100;
        op = 2'b10;
        #1;

        check_outputs(16'd0, 16'h0000, 16'd0, 16'd0);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Division (100 / 10)", test_num);
        a = 16'd100;
        b = 16'd10;
        op = 2'b11;
        #1;

        check_outputs(16'd0, 16'd0, 16'd10, 16'd0);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Division with remainder (7 / 3)", test_num);
        a = 16'd7;
        b = 16'd3;
        op = 2'b11;
        #1;

        check_outputs(16'd0, 16'd0, 16'd2, 16'd0);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Zero check on non-selected outputs (Add 0+0)", test_num);
        a = 16'd0;
        b = 16'd0;
        op = 2'b00;
        #1;

        check_outputs(16'h0, 16'h0, 16'h0, 16'h0);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Large Value Division (60000 / 2)", test_num);
        a = 16'd60000;
        b = 16'd2;
        op = 2'b11;
        #1;

        check_outputs(16'd0, 16'd0, 16'd30000, 16'd0);
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
        input [15:0] expected_difference;
        input [15:0] expected_product;
        input [15:0] expected_quotient;
        input [15:0] expected_sum;
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
