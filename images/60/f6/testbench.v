`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] A;
    reg [3:0] B;
    reg enable;
    reg load_A;
    reg load_B;
    reg reset;
    wire EQ;
    wire GT;
    wire LT;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .enable(enable),
        .load_A(load_A),
        .load_B(load_B),
        .reset(reset),
        .EQ(EQ),
        .GT(GT),
        .LT(LT)
    );
    task testcase001;

        begin
            $display("Running Testcase 001: Reset Check");
            test_num = 1;
            reset = 1;
            enable = 0; load_A = 0; load_B = 0; A = 4'hF; B = 4'hF;
            #10;
            reset = 0;
            #1;

            check_outputs(1'b0, 1'b0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            $display("Running Testcase 002: A == B (5 == 5)");
            test_num = 2;
            reset = 1; #10; reset = 0; #10;
            A = 4'd5; load_A = 1; #10; load_A = 0;
            B = 4'd5; load_B = 1; #10; load_B = 0;
            enable = 1;
            #10;
            #1;

            check_outputs(1'b1, 1'b0, 1'b0);
        end
        endtask

    task testcase003;

        begin
            $display("Running Testcase 003: A > B (12 > 4)");
            test_num = 3;
            reset = 1; #10; reset = 0; #10;
            A = 4'd12; load_A = 1; #10; load_A = 0;
            B = 4'd4;  load_B = 1; #10; load_B = 0;
            enable = 1;
            #10;
            #1;

            check_outputs(1'b0, 1'b1, 1'b0);
        end
        endtask

    task testcase004;

        begin
            $display("Running Testcase 004: A < B (3 < 9)");
            test_num = 4;
            reset = 1; #10; reset = 0; #10;
            A = 4'd3; load_A = 1; #10; load_A = 0;
            B = 4'd9; load_B = 1; #10; load_B = 0;
            enable = 1;
            #10;
            #1;

            check_outputs(1'b0, 1'b0, 1'b1);
        end
        endtask

    task testcase005;

        begin
            $display("Running Testcase 005: Max Values (15 == 15)");
            test_num = 5;
            reset = 1; #10; reset = 0; #10;
            A = 4'hF; load_A = 1; #10; load_A = 0;
            B = 4'hF; load_B = 1; #10; load_B = 0;
            enable = 1;
            #10;
            #1;

            check_outputs(1'b1, 1'b0, 1'b0);
        end
        endtask

    task testcase006;

        begin
            $display("Running Testcase 006: Max A vs Min B (15 > 0)");
            test_num = 6;
            reset = 1; #10; reset = 0; #10;
            A = 4'hF; load_A = 1; #10; load_A = 0;
            B = 4'h0; load_B = 1; #10; load_B = 0;
            enable = 1;
            #10;
            #1;

            check_outputs(1'b0, 1'b1, 1'b0);
        end
        endtask

    task testcase007;

        begin
            $display("Running Testcase 007: Min A vs Max B (0 < 15)");
            test_num = 7;
            reset = 1; #10; reset = 0; #10;
            A = 4'h0; load_A = 1; #10; load_A = 0;
            B = 4'hF; load_B = 1; #10; load_B = 0;
            enable = 1;
            #10;
            #1;

            check_outputs(1'b0, 1'b0, 1'b1);
        end
        endtask

    task testcase008;

        begin
            $display("Running Testcase 008: Enable Logic Check");
            test_num = 8;
            reset = 1; #10; reset = 0; #10;
            A = 4'd7; load_A = 1; #10; load_A = 0;
            B = 4'd7; load_B = 1; #10; load_B = 0;
            enable = 0;
            #10;
            #1;

            check_outputs(1'b0, 1'b0, 1'b0);
        end
        endtask

    task testcase009;

        begin
            $display("Running Testcase 009: Register Storage Verification");
            test_num = 9;
            reset = 1; #10; reset = 0; #10;

            A = 4'd10; load_A = 1; #10; load_A = 0;
            B = 4'd10; load_B = 1; #10; load_B = 0;

            A = 4'd2; B = 4'd15;
            enable = 1;
            #10;

            #1;


            check_outputs(1'b1, 1'b0, 1'b0);
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
        input expected_EQ;
        input expected_GT;
        input expected_LT;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_EQ === (expected_EQ ^ EQ ^ expected_EQ) &&
                expected_GT === (expected_GT ^ GT ^ expected_GT) &&
                expected_LT === (expected_LT ^ LT ^ expected_LT)) begin
                $display("PASS");
                $display("  Outputs: EQ=%b, GT=%b, LT=%b",
                         EQ, GT, LT);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: EQ=%b, GT=%b, LT=%b",
                         expected_EQ, expected_GT, expected_LT);
                $display("  Got:      EQ=%b, GT=%b, LT=%b",
                         EQ, GT, LT);
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
