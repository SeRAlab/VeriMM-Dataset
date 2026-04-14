`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] dividend;
    reg [15:0] divisor;
    wire divide_by_zero;
    wire [15:0] quotient;
    wire [15:0] remainder;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .dividend(dividend),
        .divisor(divisor),
        .divide_by_zero(divide_by_zero),
        .quotient(quotient),
        .remainder(remainder)
    );
    task testcase001;

        begin
            test_num = 1;
            dividend = 16'sd20;
            divisor  = 16'sd3;
            #1;

            check_outputs(1'b0, 16'sd6, 16'sd2);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            dividend = 16'sd20;
            divisor  = -16'sd3;
            #1;

            check_outputs(1'b0, -16'sd6, 16'sd2);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            dividend = -16'sd20;
            divisor  = 16'sd3;
            #1;

            check_outputs(1'b0, -16'sd6, -16'sd2);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            dividend = -16'sd20;
            divisor  = -16'sd3;
            #1;

            check_outputs(1'b0, 16'sd6, -16'sd2);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            dividend = 16'sd500;
            divisor  = 16'sd0;
            #1;

            check_outputs(1'b1, 16'sd0, 16'sd0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            dividend = 16'sd0;
            divisor  = 16'sd15;
            #1;

            check_outputs(1'b0, 16'sd0, 16'sd0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            dividend = 16'sd1234;
            divisor  = 16'sd1234;
            #1;

            check_outputs(1'b0, 16'sd1, 16'sd0);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            dividend = 16'sd50;
            divisor  = -16'sd50;
            #1;

            check_outputs(1'b0, -16'sd1, 16'sd0);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            dividend = 16'sh7FFF;
            divisor  = 16'sd2;
            #1;

            check_outputs(1'b0, 16'sd16383, 16'sd1);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            dividend = 16'sh8000;
            divisor  = 16'sd1;
            #1;

            check_outputs(1'b0, -16'sd32768, 16'sd0);
        end
        endtask

    task testcase011;

        begin
            test_num = 11;
            dividend = -16'sd1000;
            divisor  = -16'sd7;
            #1;

            check_outputs(1'b0, 16'sd142, -16'sd6);
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
        testcase011();
        
        
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
        input expected_divide_by_zero;
        input [15:0] expected_quotient;
        input [15:0] expected_remainder;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_divide_by_zero === (expected_divide_by_zero ^ divide_by_zero ^ expected_divide_by_zero) &&
                expected_quotient === (expected_quotient ^ quotient ^ expected_quotient) &&
                expected_remainder === (expected_remainder ^ remainder ^ expected_remainder)) begin
                $display("PASS");
                $display("  Outputs: divide_by_zero=%b, quotient=%h, remainder=%h",
                         divide_by_zero, quotient, remainder);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: divide_by_zero=%b, quotient=%h, remainder=%h",
                         expected_divide_by_zero, expected_quotient, expected_remainder);
                $display("  Got:      divide_by_zero=%b, quotient=%h, remainder=%h",
                         divide_by_zero, quotient, remainder);
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
