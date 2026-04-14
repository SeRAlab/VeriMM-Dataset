`timescale 1ns/1ps

module SRT_Divider_tb;

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
    SRT_Divider dut (
        .dividend(dividend),
        .divisor(divisor),
        .quotient(quotient),
        .remainder(remainder)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Positive/Positive (20 / 5)", test_num);
            dividend = 8'sd20; divisor = 8'sd5;
            #1;

            check_outputs(8'sd4, 8'sd0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Positive/Positive with remainder (22 / 7)", test_num);
            dividend = 8'sd22; divisor = 8'sd7;
            #1;

            check_outputs(8'sd3, 8'sd1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Negative/Positive (-15 / 4)", test_num);
            dividend = -8'sd15; divisor = 8'sd4;
            #1;

            check_outputs(-8'sd3, -8'sd3);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Positive/Negative (15 / -4)", test_num);
            dividend = 8'sd15; divisor = -8'sd4;
            #1;

            check_outputs(-8'sd3, 8'sd3);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Negative/Negative (-15 / -4)", test_num);
            dividend = -8'sd15; divisor = -8'sd4;
            #1;

            check_outputs(8'sd3, -8'sd3);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Division by Zero (50 / 0)", test_num);
            dividend = 8'sd50; divisor = 8'sd0;
            #1;

            check_outputs(8'sd0, 8'sd50);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Dividend is Zero (0 / 10)", test_num);
            dividend = 8'sd0; divisor = 8'sd10;
            #1;

            check_outputs(8'sd0, 8'sd0);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Divisor > Dividend (7 / 12)", test_num);
            dividend = 8'sd7; divisor = 8'sd12;
            #1;

            check_outputs(8'sd0, 8'sd7);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Large Negative Division (-128 / 2)", test_num);
            dividend = -8'sd128; divisor = 8'sd2;
            #1;

            check_outputs(-8'sd64, 8'sd0);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Divide by 1 (127 / 1)", test_num);
            dividend = 8'sd127; divisor = 8'sd1;
            #1;

            check_outputs(8'sd127, 8'sd0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("SRT_Divider Testbench");
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
