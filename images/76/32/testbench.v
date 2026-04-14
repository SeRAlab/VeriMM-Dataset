`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] A;
    reg [3:0] B;
    reg M;
    wire COUT;
    wire [3:0] R;
    wire V;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .M(M),
        .COUT(COUT),
        .R(R),
        .V(V)
    );
    task testcase001;

        begin
            $display("Testcase 001: Addition - Positive result (1 + 2 = 3), no Carry, no Overflow");
            A = 4'b0001;
            B = 4'b0010;
            M = 1'b0;
            #1;

            check_outputs(1'b0, 4'b0011, 1'b0);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Addition - Unsigned wrap-around (-1 + 1 = 0), Carry, no Overflow");
            A = 4'b1111;
            B = 4'b0001;
            M = 1'b0;
            #1;

            check_outputs(1'b1, 4'b0000, 1'b0);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Addition - Signed Overflow Positive (7 + 1 = 8/-8), no Carry, Overflow");
            A = 4'b0111;
            B = 4'b0001;
            M = 1'b0;
            #1;

            check_outputs(1'b0, 4'b1000, 1'b1);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Addition - Signed Overflow Negative (-8 + -8 = -16/0), Carry, Overflow");
            A = 4'b1000;
            B = 4'b1000;
            M = 1'b0;
            #1;

            check_outputs(1'b1, 4'b0000, 1'b1);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Subtraction - Positive result (5 - 3 = 2), no Overflow");
            A = 4'b0101;
            B = 4'b0011;
            M = 1'b1;

            #1;


            check_outputs(1'b1, 4'b0010, 1'b0);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: Subtraction - Negative result (3 - 5 = -2), no Overflow");
            A = 4'b0011;
            B = 4'b0101;
            M = 1'b1;

            #1;


            check_outputs(1'b0, 4'b1110, 1'b0);
        end
        endtask

    task testcase007;

        begin
            $display("Testcase 007: Subtraction - Positive Overflow (7 - (-2) = 9/-7)");
            A = 4'b0111;
            B = 4'b1110;
            M = 1'b1;

            #1;


            check_outputs(1'b0, 4'b1001, 1'b1);
        end
        endtask

    task testcase008;

        begin
            $display("Testcase 008: Subtraction - Negative Overflow (-8 - 1 = -9/7)");
            A = 4'b1000;
            B = 4'b0001;
            M = 1'b1;

            #1;


            check_outputs(1'b1, 4'b0111, 1'b1);
        end
        endtask

    task testcase009;

        begin
            $display("Testcase 009: Subtraction - Zero result (7 - 7 = 0)");
            A = 4'b0111;
            B = 4'b0111;
            M = 1'b1;

            #1;


            check_outputs(1'b1, 4'b0000, 1'b0);
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
        input expected_COUT;
        input [3:0] expected_R;
        input expected_V;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_COUT === (expected_COUT ^ COUT ^ expected_COUT) &&
                expected_R === (expected_R ^ R ^ expected_R) &&
                expected_V === (expected_V ^ V ^ expected_V)) begin
                $display("PASS");
                $display("  Outputs: COUT=%b, R=%h, V=%b",
                         COUT, R, V);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: COUT=%b, R=%h, V=%b",
                         expected_COUT, expected_R, expected_V);
                $display("  Got:      COUT=%b, R=%h, V=%b",
                         COUT, R, V);
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
