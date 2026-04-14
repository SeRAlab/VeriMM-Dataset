`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg cZero;
    reg gOne;
    reg gTwo;
    reg gZero;
    reg pOne;
    reg pTwo;
    reg pZero;
    wire cTwentyFour;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .cZero(cZero),
        .gOne(gOne),
        .gTwo(gTwo),
        .gZero(gZero),
        .pOne(pOne),
        .pTwo(pTwo),
        .pZero(pZero),
        .cTwentyFour(cTwentyFour)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: All signals zero", test_num);
            gZero = 0; pZero = 0; cZero = 0;
            gOne  = 0; pOne  = 0;
            gTwo  = 0; pTwo  = 0;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: gTwo generates carry directly", test_num);
            gZero = 0; pZero = 0; cZero = 0;
            gOne  = 0; pOne  = 0;
            gTwo  = 1; pTwo  = 0;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: gOne generates, pTwo propagates", test_num);
            gZero = 0; pZero = 0; cZero = 0;
            gOne  = 1; pOne  = 0;
            gTwo  = 0; pTwo  = 1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: gOne generates, but pTwo does not propagate", test_num);
            gZero = 0; pZero = 0; cZero = 0;
            gOne  = 1; pOne  = 1;
            gTwo  = 0; pTwo  = 0;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: gZero generates, pOne and pTwo propagate", test_num);
            gZero = 1; pZero = 0; cZero = 0;
            gOne  = 0; pOne  = 1;
            gTwo  = 0; pTwo  = 1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: gZero generates, pOne propagates, but pTwo stops it", test_num);
            gZero = 1; pZero = 1; cZero = 1;
            gOne  = 0; pOne  = 1;
            gTwo  = 0; pTwo  = 0;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: cZero propagates through all stages", test_num);
            gZero = 0; pZero = 1; cZero = 1;
            gOne  = 0; pOne  = 1;
            gTwo  = 0; pTwo  = 1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: cZero is 1 but pZero is 0", test_num);
            gZero = 0; pZero = 0; cZero = 1;
            gOne  = 0; pOne  = 1;
            gTwo  = 0; pTwo  = 1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: All propagates high, but no generate or cZero", test_num);
            gZero = 0; pZero = 1; cZero = 0;
            gOne  = 0; pOne  = 1;
            gTwo  = 0; pTwo  = 1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Multiple generate paths active", test_num);
            gZero = 1; pZero = 1; cZero = 1;
            gOne  = 1; pOne  = 1;
            gTwo  = 1; pTwo  = 1;
            #1;

            check_outputs(1'b1);
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
        input expected_cTwentyFour;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_cTwentyFour === (expected_cTwentyFour ^ cTwentyFour ^ expected_cTwentyFour)) begin
                $display("PASS");
                $display("  Outputs: cTwentyFour=%b",
                         cTwentyFour);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: cTwentyFour=%b",
                         expected_cTwentyFour);
                $display("  Got:      cTwentyFour=%b",
                         cTwentyFour);
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
