`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] a;
    reg [31:0] b;
    reg [1:0] mode;
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
        .mode(mode),
        .difference(difference),
        .product(product),
        .quotient(quotient),
        .sum(sum)
    );
    task testcase001;

        begin
            test_num = 1;
            a = 32'sd50;
            b = 32'sd25;
            mode = 2'b00;
            $display("Testcase %0d: Addition (50 + 25)", test_num);
            #1;

            check_outputs(32'sd0, 32'sd0, 32'sd0, 32'sd75);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            a = 32'sd-100;
            b = 32'sd-50;
            mode = 2'b00;
            $display("Testcase %0d: Addition (-100 + -50)", test_num);
            #1;

            check_outputs(32'sd0, 32'sd0, 32'sd0, 32'sd-150);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            a = 32'sd100;
            b = 32'sd40;
            mode = 2'b01;
            $display("Testcase %0d: Subtraction (100 - 40)", test_num);
            #1;

            check_outputs(32'sd60, 32'sd0, 32'sd0, 32'sd0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            a = 32'sd10;
            b = 32'sd50;
            mode = 2'b01;
            $display("Testcase %0d: Subtraction (10 - 50)", test_num);
            #1;

            check_outputs(32'sd-40, 32'sd0, 32'sd0, 32'sd0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            a = 32'sd12;
            b = 32'sd10;
            mode = 2'b10;
            $display("Testcase %0d: Multiplication (12 * 10)", test_num);
            #1;

            check_outputs(32'sd0, 32'sd120, 32'sd0, 32'sd0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            a = 32'sd-5;
            b = 32'sd8;
            mode = 2'b10;
            $display("Testcase %0d: Multiplication (-5 * 8)", test_num);
            #1;

            check_outputs(32'sd0, 32'sd-40, 32'sd0, 32'sd0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            a = 32'sd100;
            b = 32'sd5;
            mode = 2'b11;
            $display("Testcase %0d: Division (100 / 5)", test_num);
            #1;

            check_outputs(32'sd0, 32'sd0, 32'sd20, 32'sd0);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            a = 32'sd-45;
            b = 32'sd9;
            mode = 2'b11;
            $display("Testcase %0d: Division (-45 / 9)", test_num);
            #1;

            check_outputs(32'sd0, 32'sd0, 32'sd-5, 32'sd0);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            a = 32'sd2147483647;
            b = 32'sd0;
            mode = 2'b10;
            $display("Testcase %0d: Multiplication by Zero (MaxInt * 0)", test_num);
            #1;

            check_outputs(32'sd0, 32'sd0, 32'sd0, 32'sd0);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            a = 32'sd0;
            b = 32'sd12345;
            mode = 2'b01;
            $display("Testcase %0d: Subtraction from Zero (0 - 12345)", test_num);
            #1;

            check_outputs(32'sd-12345, 32'sd0, 32'sd0, 32'sd0);
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
