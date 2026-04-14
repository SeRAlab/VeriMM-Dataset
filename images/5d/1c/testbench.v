`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg control;
    reg [15:0] minuend;
    reg [15:0] subtrahend;
    wire [15:0] result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .control(control),
        .minuend(minuend),
        .subtrahend(subtrahend),
        .result(result)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Simple Addition (10 + 20)", test_num);
            control = 1'b0;
            minuend = 16'd10;
            subtrahend = 16'd20;
            #1;

            check_outputs(16'd30);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Simple Subtraction (50 - 20)", test_num);
            control = 1'b1;
            minuend = 16'd50;
            subtrahend = 16'd20;
            #1;

            check_outputs(16'd30);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Negative Result (10 - 20)", test_num);
            control = 1'b1;
            minuend = 16'd10;
            subtrahend = 16'd20;

            #1;


            check_outputs(16'hFFF6);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Addition Wrap-around (0xFFFF + 1)", test_num);
            control = 1'b0;
            minuend = 16'hFFFF;
            subtrahend = 16'h0001;
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Zero Result (0x1234 - 0x1234)", test_num);
            control = 1'b1;
            minuend = 16'h1234;
            subtrahend = 16'h1234;
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Subtract from Zero (0 - 1)", test_num);
            control = 1'b1;
            minuend = 16'h0000;
            subtrahend = 16'h0001;
            #1;

            check_outputs(16'hFFFF);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Max Values Addition (0xFFFF + 0xFFFF)", test_num);
            control = 1'b0;
            minuend = 16'hFFFF;
            subtrahend = 16'hFFFF;

            #1;


            check_outputs(16'hFFFE);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Max Values Subtraction (0xFFFF - 0x0001)", test_num);
            control = 1'b1;
            minuend = 16'hFFFF;
            subtrahend = 16'h0001;
            #1;

            check_outputs(16'hFFFE);
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
        input [15:0] expected_result;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_result === (expected_result ^ result ^ expected_result)) begin
                $display("PASS");
                $display("  Outputs: result=%h",
                         result);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: result=%h",
                         expected_result);
                $display("  Got:      result=%h",
                         result);
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
