`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] a;
    reg [7:0] b;
    reg [1:0] op;
    wire [7:0] difference;
    wire [15:0] product;
    wire [7:0] quotient;
    wire [7:0] sum;

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
            $display("Testcase 001: Basic Addition (op=00)");
            test_num = test_num + 1;
            a = 8'd10;
            b = 8'd5;
            op = 2'b00;

            #1;


            check_outputs(8'd5, 16'd50, 8'd2, 8'd15);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Basic Subtraction (op=01)");
            test_num = test_num + 1;
            a = 8'd20;
            b = 8'd30;
            op = 2'b01;

            #1;


            check_outputs(-8'd10, 16'd600, 8'd0, 8'd50);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Basic Multiplication (op=10)");
            test_num = test_num + 1;
            a = 8'd12;
            b = 8'd4;
            op = 2'b10;

            #1;


            check_outputs(8'd8, 16'd48, 8'd3, 8'd16);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Basic Division (op=11)");
            test_num = test_num + 1;
            a = 8'd100;
            b = 8'd10;
            op = 2'b11;

            #1;


            check_outputs(8'd90, 16'd1000, 8'd10, 8'd110);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Signed Negative Numbers");
            test_num = test_num + 1;
            a = -8'd15;
            b = 8'd5;
            op = 2'b00;

            #1;


            check_outputs(-8'd20, -16'd75, -8'd3, -8'd10);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: Multiplication with Negative Result");
            test_num = test_num + 1;
            a = 8'd10;
            b = -8'd8;
            op = 2'b10;

            #1;


            check_outputs(8'd18, -16'd80, -8'd1, 8'd2);
        end
        endtask

    task testcase007;

        begin
            $display("Testcase 007: Large Numbers Overflow/Max Range");
            test_num = test_num + 1;
            a = 8'sd100;
            b = 8'sd50;
            op = 2'b00;





            #1;






            check_outputs(8'd50, 16'd5000, 8'd2, -8'sd106);
        end
        endtask

    task testcase008;

        begin
            $display("Testcase 008: Operations with Zero");
            test_num = test_num + 1;
            a = 8'd0;
            b = -8'd12;
            op = 2'b00;

            #1;


            check_outputs(8'd12, 16'd0, 8'd0, -8'd12);
        end
        endtask

    task testcase009;

        begin
            $display("Testcase 009: Max Negative Value");
            test_num = test_num + 1;
            a = -8'd128;
            b = -8'd1;
            op = 2'b10;

            #1;


            check_outputs(-8'sd127, 16'sd128, -8'sd128, 8'sd127);
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
        input [7:0] expected_difference;
        input [15:0] expected_product;
        input [7:0] expected_quotient;
        input [7:0] expected_sum;
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
