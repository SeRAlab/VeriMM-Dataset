`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg A;
    reg B;
    reg C;
    reg D;
    wire X;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .C(C),
        .D(D),
        .X(X)
    );
    task testcase001;

        begin
            $display("Test Case 001: All zeros");
            A = 0; B = 0; C = 0; D = 0;
            #1;

            check_outputs(0);
        end
        endtask

    task testcase002;

        begin
            $display("Test Case 002: Single input high (A)");
            A = 1; B = 0; C = 0; D = 0;
            #1;

            check_outputs(1);
        end
        endtask

    task testcase003;

        begin
            $display("Test Case 003: Single input high (B)");
            A = 0; B = 1; C = 0; D = 0;
            #1;

            check_outputs(1);
        end
        endtask

    task testcase004;

        begin
            $display("Test Case 004: Single input high (C)");
            A = 0; B = 0; C = 1; D = 0;
            #1;

            check_outputs(1);
        end
        endtask

    task testcase005;

        begin
            $display("Test Case 005: Single input high (D)");
            A = 0; B = 0; C = 0; D = 1;
            #1;

            check_outputs(1);
        end
        endtask

    task testcase006;

        begin
            $display("Test Case 006: Two inputs high (A, B)");
            A = 1; B = 1; C = 0; D = 0;
            #1;

            check_outputs(0);
        end
        endtask

    task testcase007;

        begin
            $display("Test Case 007: Two inputs high (A, C)");
            A = 1; B = 0; C = 1; D = 0;
            #1;

            check_outputs(0);
        end
        endtask

    task testcase008;

        begin
            $display("Test Case 008: Two inputs high (A, D)");
            A = 1; B = 0; C = 0; D = 1;
            #1;

            check_outputs(0);
        end
        endtask

    task testcase009;

        begin
            $display("Test Case 009: Two inputs high (B, C)");
            A = 0; B = 1; C = 1; D = 0;
            #1;

            check_outputs(0);
        end
        endtask

    task testcase010;

        begin
            $display("Test Case 010: Two inputs high (B, D)");
            A = 0; B = 1; C = 0; D = 1;
            #1;

            check_outputs(0);
        end
        endtask

    task testcase011;

        begin
            $display("Test Case 011: Two inputs high (C, D)");
            A = 0; B = 0; C = 1; D = 1;
            #1;

            check_outputs(0);
        end
        endtask

    task testcase012;

        begin
            $display("Test Case 012: Three inputs high (A, B, C)");
            A = 1; B = 1; C = 1; D = 0;
            #1;

            check_outputs(1);
        end
        endtask

    task testcase013;

        begin
            $display("Test Case 013: Three inputs high (A, B, D)");
            A = 1; B = 1; C = 0; D = 1;
            #1;

            check_outputs(1);
        end
        endtask

    task testcase014;

        begin
            $display("Test Case 014: Three inputs high (A, C, D)");
            A = 1; B = 0; C = 1; D = 1;
            #1;

            check_outputs(1);
        end
        endtask

    task testcase015;

        begin
            $display("Test Case 015: Three inputs high (B, C, D)");
            A = 0; B = 1; C = 1; D = 1;
            #1;

            check_outputs(1);
        end
        endtask

    task testcase016;

        begin
            $display("Test Case 016: All inputs high");
            A = 1; B = 1; C = 1; D = 1;
            #1;

            check_outputs(0);
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
