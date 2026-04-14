`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] a;
    reg [3:0] b;
    wire overflow;
    wire [7:0] product;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .overflow(overflow),
        .product(product)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Positive * Positive (3 * 2)", test_num);
            a = 4'sd3; b = 4'sd2;
            #1;

            check_outputs(1'b0, 8'sd6);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Positive * Negative (3 * -2)", test_num);
            a = 4'sd3; b = -4'sd2;
            #1;

            check_outputs(1'b0, -8'sd6);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Negative * Positive (-4 * 5)", test_num);
            a = -4'sd4; b = 4'sd5;
            #1;

            check_outputs(1'b0, -8'sd20);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Negative * Negative (-3 * -3)", test_num);
            a = -4'sd3; b = -4'sd3;
            #1;

            check_outputs(1'b0, 8'sd9);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Zero Multiplication (0 * -7)", test_num);
            a = 4'sd0; b = -4'sd7;
            #1;

            check_outputs(1'b0, 8'sd0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Max Positive (7 * 7)", test_num);
            a = 4'sd7; b = 4'sd7;
            #1;

            check_outputs(1'b0, 8'sd49);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Min Result (-8 * 7)", test_num);
            a = -4'sd8; b = 4'sd7;
            #1;

            check_outputs(1'b0, -8'sd56);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Extreme Negative Squares (-8 * -8)", test_num);
            a = -4'sd8; b = -4'sd8;
            #1;

            check_outputs(1'b0, 8'sd64);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Identity (1 * -8)", test_num);
            a = 4'sd1; b = -4'sd8;
            #1;

            check_outputs(1'b0, -8'sd8);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Small Product (-1 * -1)", test_num);
            a = -4'sd1; b = -4'sd1;
            #1;

            check_outputs(1'b0, 8'sd1);
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
        input expected_overflow;
        input [7:0] expected_product;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_overflow === (expected_overflow ^ overflow ^ expected_overflow) &&
                expected_product === (expected_product ^ product ^ expected_product)) begin
                $display("PASS");
                $display("  Outputs: overflow=%b, product=%h",
                         overflow, product);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: overflow=%b, product=%h",
                         expected_overflow, expected_product);
                $display("  Got:      overflow=%b, product=%h",
                         overflow, product);
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
