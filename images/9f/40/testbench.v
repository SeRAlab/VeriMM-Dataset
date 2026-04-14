`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg Eqv;
    reg Rom_DivStepSQRT;
    reg Rom_Sub;
    reg TrueIEEEAregLSB;
    reg notBregSign;
    reg notFracRNearest;
    wire AdderCarryIn;
    wire FracZero;
    wire notFracZero;
    wire notSub;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .Eqv(Eqv),
        .Rom_DivStepSQRT(Rom_DivStepSQRT),
        .Rom_Sub(Rom_Sub),
        .TrueIEEEAregLSB(TrueIEEEAregLSB),
        .notBregSign(notBregSign),
        .notFracRNearest(notFracRNearest),
        .AdderCarryIn(AdderCarryIn),
        .FracZero(FracZero),
        .notFracZero(notFracZero),
        .notSub(notSub)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case %0d: Baseline - All zeros", test_num);
            Rom_Sub = 0;
            Rom_DivStepSQRT = 0;
            notBregSign = 0;
            Eqv = 0;
            notFracRNearest = 0;
            TrueIEEEAregLSB = 0;

            #1;


            check_outputs(1'b1, 1'b0, 1'b1, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case %0d: Basic Subtraction mode", test_num);
            Rom_Sub = 1;
            Rom_DivStepSQRT = 0;
            notBregSign = 0;
            Eqv = 0;
            notFracRNearest = 0;
            TrueIEEEAregLSB = 0;

            #1;


            check_outputs(1'b0, 1'b0, 1'b1, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case %0d: Subtraction with Sign Equivalence (CarryIn)", test_num);
            Rom_Sub = 1;
            Rom_DivStepSQRT = 0;
            notBregSign = 1;
            Eqv = 0;
            notFracRNearest = 0;
            TrueIEEEAregLSB = 0;

            #1;


            check_outputs(1'b1, 1'b0, 1'b1, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case %0d: Subtraction with Sign Matching (No CarryIn)", test_num);
            Rom_Sub = 1;
            Rom_DivStepSQRT = 0;
            notBregSign = 1;
            Eqv = 1;
            notFracRNearest = 0;
            TrueIEEEAregLSB = 0;

            #1;


            check_outputs(1'b0, 1'b0, 1'b1, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case %0d: Division Step mode with LSB high", test_num);
            Rom_Sub = 0;
            Rom_DivStepSQRT = 1;
            notBregSign = 0;
            Eqv = 0;
            notFracRNearest = 0;
            TrueIEEEAregLSB = 1;

            #1;


            check_outputs(1'b1, 1'b0, 1'b1, 1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test Case %0d: Division Step mode with LSB low", test_num);
            Rom_Sub = 0;
            Rom_DivStepSQRT = 1;
            notBregSign = 0;
            Eqv = 0;
            notFracRNearest = 0;
            TrueIEEEAregLSB = 0;

            #1;


            check_outputs(1'b0, 1'b0, 1'b1, 1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test Case %0d: Fraction Zero Detection", test_num);
            Rom_Sub = 0;
            Rom_DivStepSQRT = 0;
            notBregSign = 0;
            Eqv = 0;
            notFracRNearest = 1;
            TrueIEEEAregLSB = 0;

            #1;


            check_outputs(1'b0, 1'b1, 1'b0, 1'b1);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Test Case %0d: Fraction non-zero via LSB", test_num);
            Rom_Sub = 0;
            Rom_DivStepSQRT = 0;
            notBregSign = 0;
            Eqv = 0;
            notFracRNearest = 1;
            TrueIEEEAregLSB = 1;

            #1;


            check_outputs(1'b0, 1'b0, 1'b1, 1'b1);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            $display("Test Case %0d: All inputs high", test_num);
            Rom_Sub = 1;
            Rom_DivStepSQRT = 1;
            notBregSign = 1;
            Eqv = 1;
            notFracRNearest = 1;
            TrueIEEEAregLSB = 1;

            #1;


            check_outputs(1'b1, 1'b0, 1'b1, 1'b0);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            $display("Test Case %0d: Mixed rounding and subtraction", test_num);
            Rom_Sub = 1;
            Rom_DivStepSQRT = 0;
            notBregSign = 0;
            Eqv = 1;
            notFracRNearest = 1;
            TrueIEEEAregLSB = 0;

            #1;


            check_outputs(1'b1, 1'b1, 1'b0, 1'b0);
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
        input expected_AdderCarryIn;
        input expected_FracZero;
        input expected_notFracZero;
        input expected_notSub;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_AdderCarryIn === (expected_AdderCarryIn ^ AdderCarryIn ^ expected_AdderCarryIn) &&
                expected_FracZero === (expected_FracZero ^ FracZero ^ expected_FracZero) &&
                expected_notFracZero === (expected_notFracZero ^ notFracZero ^ expected_notFracZero) &&
                expected_notSub === (expected_notSub ^ notSub ^ expected_notSub)) begin
                $display("PASS");
                $display("  Outputs: AdderCarryIn=%b, FracZero=%b, notFracZero=%b, notSub=%b",
                         AdderCarryIn, FracZero, notFracZero, notSub);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: AdderCarryIn=%b, FracZero=%b, notFracZero=%b, notSub=%b",
                         expected_AdderCarryIn, expected_FracZero, expected_notFracZero, expected_notSub);
                $display("  Got:      AdderCarryIn=%b, FracZero=%b, notFracZero=%b, notSub=%b",
                         AdderCarryIn, FracZero, notFracZero, notSub);
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
