`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] A;
    reg [3:0] B;
    reg [3:0] C;
    reg [3:0] D;
    reg S;
    wire [3:0] Q;

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
        .S(S),
        .Q(Q)
    );
    task testcase001;

        begin
            A = 4'h0; B = 4'h0; C = 4'h0; D = 4'h0; S = 1'b0;
            $display("\nTestcase 001: Addition All Zeros (0+0+0+0)");
            #1;

            check_outputs(4'h0);
        end
        endtask

    task testcase002;

        begin
            A = 4'h1; B = 4'h2; C = 4'h3; D = 4'h4; S = 1'b0;
            $display("\nTestcase 002: Addition Small Numbers (1+2+3+4=10)");
            #1;

            check_outputs(4'hA);
        end
        endtask

    task testcase003;

        begin
            A = 4'h8; B = 4'h8; C = 4'h1; D = 4'h1; S = 1'b0;
            $display("\nTestcase 003: Addition Overflow (8+8+1+1=18 -> 2)");
            #1;

            check_outputs(4'h2);
        end
        endtask

    task testcase004;

        begin
            A = 4'hF; B = 4'hF; C = 4'hF; D = 4'hF; S = 1'b0;
            $display("\nTestcase 004: Addition Max Values (15+15+15+15=60 -> 12)");
            #1;

            check_outputs(4'hC);
        end
        endtask

    task testcase005;

        begin
            A = 4'h0; B = 4'h0; C = 4'h0; D = 4'h0; S = 1'b1;
            $display("\nTestcase 005: Subtraction All Zeros (0-0-0-0)");
            #1;

            check_outputs(4'h0);
        end
        endtask

    task testcase006;

        begin
            A = 4'hF; B = 4'h2; C = 4'h2; D = 4'h1; S = 1'b1;
            $display("\nTestcase 006: Subtraction Positive Result (15-2-2-1=10)");
            #1;

            check_outputs(4'hA);
        end
        endtask

    task testcase007;

        begin
            A = 4'h2; B = 4'h3; C = 4'h1; D = 4'h1; S = 1'b1;
            $display("\nTestcase 007: Subtraction Underflow (2-3-1-1=-3 -> 13)");
            #1;

            check_outputs(4'hD);
        end
        endtask

    task testcase008;

        begin
            A = 4'h9; B = 4'h3; C = 4'h3; D = 4'h3; S = 1'b1;
            $display("\nTestcase 008: Subtraction Result Zero (9-3-3-3=0)");
            #1;

            check_outputs(4'h0);
        end
        endtask

    task testcase009;

        begin
            A = 4'hF; B = 4'hF; C = 4'hF; D = 4'hF; S = 1'b1;
            $display("\nTestcase 009: Subtraction Max Values (15-15-15-15=-30 -> 2)");
            #1;

            check_outputs(4'h2);
        end
        endtask

    task testcase010;

        begin
            A = 4'h5; B = 4'h1; C = 4'h1; D = 4'h1; S = 1'b0;
            $display("\nTestcase 010a: Mixed Addition (5+1+1+1=8)");
            #1;

            check_outputs(4'h8);
            S = 1'b1;
            $display("Testcase 010b: Mixed Subtraction (5-1-1-1=2)");
            #1;

            check_outputs(4'h2);
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
        input [3:0] expected_Q;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Q === (expected_Q ^ Q ^ expected_Q)) begin
                $display("PASS");
                $display("  Outputs: Q=%h",
                         Q);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Q=%h",
                         expected_Q);
                $display("  Got:      Q=%h",
                         Q);
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
