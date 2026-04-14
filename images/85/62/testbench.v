`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg f;
    reg [3:0] y;
    wire Y1;
    wire Y2;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .f(f),
        .y(y),
        .Y1(Y1),
        .Y2(Y2)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: State W (0001), f=1. Transition to X (Y1=1, Y2=0)", test_num);
            y = 4'b0001; f = 1;
            #1;

            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: State W (0001), f=0. Transition to Z (Y1=0, Y2=0)", test_num);
            y = 4'b0001; f = 0;
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: State X (0010), f=1. Transition to Y (Y1=0, Y2=1)", test_num);
            y = 4'b0010; f = 1;
            #1;

            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: State X (0010), f=0. Transition to W (Y1=0, Y2=0)", test_num);
            y = 4'b0010; f = 0;
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: State Y (0100), f=1. Transition to Z (Y1=0, Y2=0)", test_num);
            y = 4'b0100; f = 1;
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: State Y (0100), f=0. Transition to W (Y1=0, Y2=0)", test_num);
            y = 4'b0100; f = 0;
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %0d: State Z (1000), f=1. Transition to X (Y1=1, Y2=0)", test_num);
            y = 4'b1000; f = 1;
            #1;

            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Testcase %0d: State Z (1000), f=0. Transition to W (Y1=0, Y2=0)", test_num);
            y = 4'b1000; f = 0;
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            $display("Testcase %0d: Illegal state (0000), f=1. Expect all 0", test_num);
            y = 4'b0000; f = 1;
            #1;

            check_outputs(1'b0, 1'b0);
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
        input expected_Y1;
        input expected_Y2;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Y1 === (expected_Y1 ^ Y1 ^ expected_Y1) &&
                expected_Y2 === (expected_Y2 ^ Y2 ^ expected_Y2)) begin
                $display("PASS");
                $display("  Outputs: Y1=%b, Y2=%b",
                         Y1, Y2);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Y1=%b, Y2=%b",
                         expected_Y1, expected_Y2);
                $display("  Got:      Y1=%b, Y2=%b",
                         Y1, Y2);
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
