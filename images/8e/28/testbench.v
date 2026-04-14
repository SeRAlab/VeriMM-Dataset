`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] A;
    reg [7:0] B;
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
        .A(A),
        .B(B),
        .difference(difference),
        .product(product),
        .quotient(quotient),
        .sum(sum)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: A=20, B=10", test_num);
            A = 8'd20;
            B = 8'd10;

            #1;


            check_outputs(8'h0A, 16'h00C8, 8'h02, 8'h1E);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: A=-20, B=10", test_num);
            A = -8'd20;
            B = 8'd10;

            #1;


            check_outputs(8'hE2, 16'h00C8, 8'hFE, 8'hF6);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: A=20, B=-10", test_num);
            A = 8'd20;
            B = -8'd10;

            #1;


            check_outputs(8'h1E, 16'h00C8, 8'hFE, 8'h0A);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: A=-20, B=-10", test_num);
            A = -8'd20;
            B = -8'd10;

            #1;


            check_outputs(8'hF6, 16'h00C8, 8'h02, 8'hE2);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: A=0, B=15", test_num);
            A = 8'd0;
            B = 8'd15;

            #1;


            check_outputs(8'hF1, 16'h0000, 8'h00, 8'h0F);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: A=50, B=1", test_num);
            A = 8'd50;
            B = 8'd1;

            #1;


            check_outputs(8'h31, 16'h0032, 8'h32, 8'h33);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: A=127, B=2 (Positive Boundary)", test_num);
            A = 8'h7F;
            B = 8'd2;

            #1;


            check_outputs(8'h7D, 16'h00FE, 8'h3F, 8'h81);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: A=-128, B=2 (Negative Boundary)", test_num);
            A = 8'h80;
            B = 8'd2;

            #1;


            check_outputs(8'h7E, 16'h0100, 8'hC0, 8'h82);
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
