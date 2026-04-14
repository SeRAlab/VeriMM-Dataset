`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg A;
    reg B;
    reg BI;
    reg CI;
    wire CO;
    wire X;
    wire Y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .BI(BI),
        .CI(CI),
        .CO(CO),
        .X(X),
        .Y(Y)
    );
    task testcase001;

        begin
            $display("Test Case 001: A=0, B=0, BI=0, CI=0");
            A = 0; B = 0; BI = 0; CI = 0;
            #1;

            check_outputs(0, 0, 0);
        end
        endtask

    task testcase002;

        begin
            $display("Test Case 002: A=0, B=0, BI=0, CI=1");
            A = 0; B = 0; BI = 0; CI = 1;
            #1;

            check_outputs(0, 0, 1);
        end
        endtask

    task testcase003;

        begin
            $display("Test Case 003: A=0, B=1, BI=0, CI=0");
            A = 0; B = 1; BI = 0; CI = 0;
            #1;

            check_outputs(0, 1, 1);
        end
        endtask

    task testcase004;

        begin
            $display("Test Case 004: A=0, B=1, BI=0, CI=1");
            A = 0; B = 1; BI = 0; CI = 1;
            #1;

            check_outputs(1, 1, 0);
        end
        endtask

    task testcase005;

        begin
            $display("Test Case 005: A=1, B=0, BI=0, CI=0");
            A = 1; B = 0; BI = 0; CI = 0;
            #1;

            check_outputs(0, 1, 1);
        end
        endtask

    task testcase006;

        begin
            $display("Test Case 006: A=1, B=0, BI=0, CI=1");
            A = 1; B = 0; BI = 0; CI = 1;
            #1;

            check_outputs(1, 1, 0);
        end
        endtask

    task testcase007;

        begin
            $display("Test Case 007: A=1, B=1, BI=0, CI=0");
            A = 1; B = 1; BI = 0; CI = 0;
            #1;

            check_outputs(1, 0, 0);
        end
        endtask

    task testcase008;

        begin
            $display("Test Case 008: A=1, B=1, BI=0, CI=1");
            A = 1; B = 1; BI = 0; CI = 1;
            #1;

            check_outputs(1, 0, 1);
        end
        endtask

    task testcase009;

        begin
            $display("Test Case 009: A=0, B=0, BI=1, CI=0");
            A = 0; B = 0; BI = 1; CI = 0;
            #1;

            check_outputs(0, 1, 1);
        end
        endtask

    task testcase010;

        begin
            $display("Test Case 010: A=0, B=0, BI=1, CI=1");
            A = 0; B = 0; BI = 1; CI = 1;
            #1;

            check_outputs(1, 1, 0);
        end
        endtask

    task testcase011;

        begin
            $display("Test Case 011: A=0, B=1, BI=1, CI=0");
            A = 0; B = 1; BI = 1; CI = 0;
            #1;

            check_outputs(0, 0, 0);
        end
        endtask

    task testcase012;

        begin
            $display("Test Case 012: A=0, B=1, BI=1, CI=1");
            A = 0; B = 1; BI = 1; CI = 1;
            #1;

            check_outputs(0, 0, 1);
        end
        endtask

    task testcase013;

        begin
            $display("Test Case 013: A=1, B=0, BI=1, CI=0");
            A = 1; B = 0; BI = 1; CI = 0;
            #1;

            check_outputs(1, 0, 0);
        end
        endtask

    task testcase014;

        begin
            $display("Test Case 014: A=1, B=0, BI=1, CI=1");
            A = 1; B = 0; BI = 1; CI = 1;
            #1;

            check_outputs(1, 0, 1);
        end
        endtask

    task testcase015;

        begin
            $display("Test Case 015: A=1, B=1, BI=1, CI=0");
            A = 1; B = 1; BI = 1; CI = 0;
            #1;

            check_outputs(0, 1, 1);
        end
        endtask

    task testcase016;

        begin
            $display("Test Case 016: A=1, B=1, BI=1, CI=1");
            A = 1; B = 1; BI = 1; CI = 1;
            #1;

            check_outputs(1, 1, 0);
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
        testcase013();
        testcase014();
        testcase015();
        testcase016();
        
        
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
        input expected_CO;
        input expected_X;
        input expected_Y;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_CO === (expected_CO ^ CO ^ expected_CO) &&
                expected_X === (expected_X ^ X ^ expected_X) &&
                expected_Y === (expected_Y ^ Y ^ expected_Y)) begin
                $display("PASS");
                $display("  Outputs: CO=%b, X=%b, Y=%b",
                         CO, X, Y);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: CO=%b, X=%b, Y=%b",
                         expected_CO, expected_X, expected_Y);
                $display("  Got:      CO=%b, X=%b, Y=%b",
                         CO, X, Y);
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
