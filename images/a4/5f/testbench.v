`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [12:0] first;
    reg [12:0] second;
    wire isFirstGreater;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .first(first),
        .second(second),
        .isFirstGreater(isFirstGreater)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Positive vs Positive (Greater)", test_num);
            first = 13'sd100;
            second = 13'sd50;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Positive vs Positive (Lesser)", test_num);
            first = 13'sd30;
            second = 13'sd80;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Positive vs Positive (Equal)", test_num);
            first = 13'sd200;
            second = 13'sd200;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Positive vs Negative", test_num);
            first = 13'sd10;
            second = -13'sd10;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Negative vs Positive", test_num);
            first = -13'sd50;
            second = 13'sd5;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Negative vs Negative (Greater)", test_num);
            first = -13'sd5;
            second = -13'sd20;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Negative vs Negative (Lesser)", test_num);
            first = -13'sd100;
            second = -13'sd50;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Max Positive vs Min Negative", test_num);
            first = 13'h0FFF;
            second = 13'h1000;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Min Negative vs Max Positive", test_num);
            first = 13'h1000;
            second = 13'h0FFF;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Zero vs Negative", test_num);
            first = 13'sd0;
            second = -13'sd1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase011;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Zero vs Positive", test_num);
            first = 13'sd0;
            second = 13'sd1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase012;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Boundary Negative Comparison", test_num);
            first = 13'h1FFF;
            second = 13'h1FFE;
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
        input expected_isFirstGreater;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_isFirstGreater === (expected_isFirstGreater ^ isFirstGreater ^ expected_isFirstGreater)) begin
                $display("PASS");
                $display("  Outputs: isFirstGreater=%b",
                         isFirstGreater);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: isFirstGreater=%b",
                         expected_isFirstGreater);
                $display("  Got:      isFirstGreater=%b",
                         isFirstGreater);
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
