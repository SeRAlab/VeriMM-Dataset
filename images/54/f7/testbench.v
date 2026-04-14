`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] A;
    reg [7:0] B;
    wire [7:0] diff;
    wire [15:0] product;
    wire [7:0] quotient;
    wire [7:0] sum;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .diff(diff),
        .product(product),
        .quotient(quotient),
        .sum(sum)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Positive Inputs (A=10, B=2)", test_num);
            A = 8'sd10;
            B = 8'sd2;

            #1;


            check_outputs(8'sd8, 16'sd20, 8'sd5, 8'sd12);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Mixed Inputs (A=-10, B=2)", test_num);
            A = -8'sd10;
            B = 8'sd2;

            #1;


            check_outputs(-8'sd12, -16'sd20, -8'sd5, -8'sd8);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Negative Inputs (A=-15, B=-3)", test_num);
            A = -8'sd15;
            B = -8'sd3;

            #1;


            check_outputs(-8'sd12, 16'sd45, 8'sd5, -8'sd18);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Division by Zero (A=50, B=0)", test_num);
            A = 8'sd50;
            B = 8'sd0;

            #1;


            check_outputs(8'sd50, 16'sd0, 8'sd0, 8'sd50);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Boundary Max Positive (A=127, B=1)", test_num);
            A = 8'sb01111111;
            B = 8'sb00000001;




            #1;





            check_outputs(8'sd126, 16'sd127, 8'sd127, -8'sd128);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Boundary Max Negative (A=-128, B=1)", test_num);
            A = 8'sb10000000;
            B = 8'sb00000001;




            #1;





            check_outputs(8'sd127, -16'sd128, -8'sd128, -8'sd127);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Large Product (A=-100, B=-100)", test_num);
            A = -8'sd100;
            B = -8'sd100;




            #1;





            check_outputs(8'sd0, 16'sd10000, 8'sd1, 8'sd56);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Zero Inputs (A=0, B=0)", test_num);
            A = 8'sd0;
            B = 8'sd0;

            #1;


            check_outputs(8'sd0, 16'sd0, 8'sd0, 8'sd0);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Negative Quotient (A=20, B=-3)", test_num);
            A = 8'sd20;
            B = -8'sd3;




            #1;





            check_outputs(8'sd23, -16'sd60, -8'sd6, 8'sd17);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Overflow Quotient (A=-128, B=-1)", test_num);
            A = -8'sd128;
            B = -8'sd1;




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
        input [7:0] expected_diff;
        input [15:0] expected_product;
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
