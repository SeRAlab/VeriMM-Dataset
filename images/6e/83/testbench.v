`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg CI;
    reg CIN;
    reg DI;
    reg S;
    wire CO;
    wire O;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .CI(CI),
        .CIN(CIN),
        .DI(DI),
        .S(S),
        .CO(CO),
        .O(O)
    );
    task testcase001;

        begin
            $display("Testcase 001: S=0, O should select CI, CO should select DI (All 0s)");
            S = 0; CI = 0; DI = 0; CIN = 0;
            #1;

            check_outputs(0, 0);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: S=0, O should select CI=1, CO should select DI=0");
            S = 0; CI = 1; DI = 0; CIN = 1;
            #1;

            check_outputs(0, 1);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: S=0, O should select CI=0, CO should select DI=1");
            S = 0; CI = 0; DI = 1; CIN = 0;
            #1;

            check_outputs(1, 0);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: S=0, CIN change should not affect output (S=0, CIN=1)");
            S = 0; CI = 1; DI = 1; CIN = 1;
            #1;

            check_outputs(1, 1);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: S=1, O should select DI, CO should select CIN (All 0s)");
            S = 1; CI = 0; DI = 0; CIN = 0;
            #1;

            check_outputs(0, 0);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: S=1, O should select DI=1, CO should select CIN=0");
            S = 1; CI = 1; DI = 1; CIN = 0;
            #1;

            check_outputs(0, 1);
        end
        endtask

    task testcase007;

        begin
            $display("Testcase 007: S=1, O should select DI=0, CO should select CIN=1");
            S = 1; CI = 0; DI = 0; CIN = 1;
            #1;

            check_outputs(1, 0);
        end
        endtask

    task testcase008;

        begin
            $display("Testcase 008: S=1, CI change should not affect output (S=1, CI=1)");
            S = 1; CI = 1; DI = 1; CIN = 1;
            #1;

            check_outputs(1, 1);
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
        input expected_CO;
        input expected_O;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_CO === (expected_CO ^ CO ^ expected_CO) &&
                expected_O === (expected_O ^ O ^ expected_O)) begin
                $display("PASS");
                $display("  Outputs: CO=%b, O=%b",
                         CO, O);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: CO=%b, O=%b",
                         expected_CO, expected_O);
                $display("  Got:      CO=%b, O=%b",
                         CO, O);
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
