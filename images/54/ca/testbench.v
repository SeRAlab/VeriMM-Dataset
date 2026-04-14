`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg A1;
    reg A2;
    reg A3;
    reg B1;
    wire X;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A1(A1),
        .A2(A2),
        .A3(A3),
        .B1(B1),
        .X(X)
    );
    task testcase001;

        begin
            $display("Testcase 001: All inputs zero");
            A1 = 0; A2 = 0; A3 = 0; B1 = 0;
            #1;

            check_outputs(0);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Path 1 Active (A1 & A2), Path 2 Inactive");
            A1 = 1; A2 = 1; A3 = 0; B1 = 0;
            #1;

            check_outputs(1);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Path 2 Active (A2 & A3 & B1), Path 1 Inactive");
            A1 = 0; A2 = 1; A3 = 1; B1 = 1;
            #1;

            check_outputs(1);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Both paths active");
            A1 = 1; A2 = 1; A3 = 1; B1 = 1;
            #1;

            check_outputs(1);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: A2 is low (Critical for both paths)");
            A1 = 1; A2 = 0; A3 = 1; B1 = 1;
            #1;

            check_outputs(0);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: Path 1 Incomplete (A1 only)");
            A1 = 1; A2 = 0; A3 = 0; B1 = 0;
            #1;

            check_outputs(0);
        end
        endtask

    task testcase007;

        begin
            $display("Testcase 007: Path 2 Incomplete (A2 & A3 only)");
            A1 = 0; A2 = 1; A3 = 1; B1 = 0;
            #1;

            check_outputs(0);
        end
        endtask

    task testcase008;

        begin
            $display("Testcase 008: Path 2 Incomplete (A2 & B1 only)");
            A1 = 0; A2 = 1; A3 = 0; B1 = 1;
            #1;

            check_outputs(0);
        end
        endtask

    task testcase009;

        begin
            $display("Testcase 009: Partial inputs, expecting zero");
            A1 = 0; A2 = 0; A3 = 1; B1 = 1;
            #1;

            check_outputs(0);
        end
        endtask

    task testcase010;

        begin
            $display("Testcase 010: Path 1 active, but A3/B1 high as well");
            A1 = 1; A2 = 1; A3 = 0; B1 = 1;
            #1;

            check_outputs(1);
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
        input expected_X;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_X === (expected_X ^ X ^ expected_X)) begin
                $display("PASS");
                $display("  Outputs: X=%b",
                         X);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: X=%b",
                         expected_X);
                $display("  Got:      X=%b",
                         X);
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
