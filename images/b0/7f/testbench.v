`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] a;
    reg [7:0] b;
    wire [7:0] difference;
    wire [7:0] product;
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
        .difference(difference),
        .product(product),
        .quotient(quotient),
        .sum(sum)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            a = 8'd20;
            b = 8'd5;
            $display("Test %0d: a=%d, b=%d (Standard a > b)", test_num, a, b);

            #1;


            check_outputs(8'h0F, 8'h64, 8'h04, 8'h19);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            a = 8'd5;
            b = 8'd20;
            $display("Test %0d: a=%d, b=%d (Standard a < b for absolute difference)", test_num, a, b);

            #1;


            check_outputs(8'h0F, 8'h64, 8'h00, 8'h19);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            a = 8'd200;
            b = 8'd100;
            $display("Test %0d: a=%d, b=%d (Sum and Product overflow)", test_num, a, b);




            #1;





            check_outputs(8'h64, 8'h20, 8'h02, 8'h2C);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            a = 8'd0;
            b = 8'd255;
            $display("Test %0d: a=%d, b=%d (Zero input a)", test_num, a, b);

            #1;


            check_outputs(8'hFF, 8'h00, 8'h00, 8'hFF);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            a = 8'd255;
            b = 8'd255;
            $display("Test %0d: a=%d, b=%d (Identical max values)", test_num, a, b);




            #1;





            check_outputs(8'h00, 8'h01, 8'h01, 8'hFE);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            a = 8'd128;
            b = 8'd2;
            $display("Test %0d: a=%d, b=%d (Power of 2 check)", test_num, a, b);

            #1;


            check_outputs(8'h7E, 8'h00, 8'h40, 8'h82);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            a = 8'd10;
            b = 8'd3;
            $display("Test %0d: a=%d, b=%d (Division with remainder)", test_num, a, b);

            #1;


            check_outputs(8'h07, 8'h1E, 8'h03, 8'h0D);
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
        input [7:0] expected_product;
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
