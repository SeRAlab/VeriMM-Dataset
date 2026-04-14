`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] dividend;
    reg [7:0] divisor;
    wire [7:0] quotient;
    wire [7:0] remainder;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .dividend(dividend),
        .divisor(divisor),
        .quotient(quotient),
        .remainder(remainder)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Positive Dividend / Positive Divisor (10 / 2)", test_num);
            dividend = 8'sd10;
            divisor  = 8'sd2;
            #1;

            check_outputs(8'sd5, 8'sd0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Positive Dividend / Positive Divisor with Remainder (25 / 7)", test_num);
            dividend = 8'sd25;
            divisor  = 8'sd7;
            #1;

            check_outputs(8'sd3, 8'sd4);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Negative Dividend / Positive Divisor (-25 / 7)", test_num);
            dividend = 8'sd-25;
            divisor  = 8'sd7;
            #1;

            check_outputs(8'sd-3, 8'sd-4);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Positive Dividend / Negative Divisor (25 / -7)", test_num);
            dividend = 8'sd25;
            divisor  = 8'sd-7;
            #1;

            check_outputs(8'sd-3, 8'sd4);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Negative Dividend / Negative Divisor (-25 / -7)", test_num);
            dividend = 8'sd-25;
            divisor  = 8'sd-7;
            #1;

            check_outputs(8'sd3, 8'sd-4);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Zero Dividend (0 / 5)", test_num);
            dividend = 8'sd0;
            divisor  = 8'sd5;
            #1;

            check_outputs(8'sd0, 8'sd0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Large Numbers (120 / 10)", test_num);
            dividend = 8'sd120;
            divisor  = 8'sd10;
            #1;

            check_outputs(8'sd12, 8'sd0);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Divide by One (100 / 1)", test_num);
            dividend = 8'sd100;
            divisor  = 8'sd1;
            #1;

            check_outputs(8'sd100, 8'sd0);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Divide by Negative One (50 / -1)", test_num);
            dividend = 8'sd50;
            divisor  = 8'sd-1;
            #1;

            check_outputs(8'sd-50, 8'sd0);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Boundary Case Negative (-128 / 2)", test_num);
            dividend = 8'sh80;
            divisor  = 8'sd2;
            #1;

            check_outputs(8'sd-64, 8'sd0);
        end
        endtask

    task testcase011;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Boundary Case Result (-127 / -1)", test_num);
            dividend = 8'sd-127;
            divisor  = 8'sd-1;
            #1;

            check_outputs(8'sd127, 8'sd0);
        end
        endtask

    task testcase012;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Dividend Smaller Than Divisor (3 / 10)", test_num);
            dividend = 8'sd3;
            divisor  = 8'sd10;
            #1;

            check_outputs(8'sd0, 8'sd3);
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
        testcase012();
        
        
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
        input [7:0] expected_quotient;
        input [7:0] expected_remainder;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_quotient === (expected_quotient ^ quotient ^ expected_quotient) &&
                expected_remainder === (expected_remainder ^ remainder ^ expected_remainder)) begin
                $display("PASS");
                $display("  Outputs: quotient=%h, remainder=%h",
                         quotient, remainder);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: quotient=%h, remainder=%h",
                         expected_quotient, expected_remainder);
                $display("  Got:      quotient=%h, remainder=%h",
                         quotient, remainder);
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
