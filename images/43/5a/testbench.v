`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] A;
    reg [3:0] B;
    reg SUB;
    wire CARRY;
    wire [3:0] SUM;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .SUB(SUB),
        .CARRY(CARRY),
        .SUM(SUM)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Addition - Simple (A=2, B=3, SUB=0)", test_num);
            A = 4'd2;
            B = 4'd3;
            SUB = 1'b0;
            #1;

            check_outputs(1'b0, 4'd5);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Addition - With Carry (A=10, B=10, SUB=0)", test_num);
            A = 4'd10;
            B = 4'd10;
            SUB = 1'b0;
            #1;

            check_outputs(1'b1, 4'd4);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Addition - Zeros (A=0, B=0, SUB=0)", test_num);
            A = 4'd0;
            B = 4'd0;
            SUB = 1'b0;
            #1;

            check_outputs(1'b0, 4'd0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Addition - Max Values (A=15, B=15, SUB=0)", test_num);
            A = 4'd15;
            B = 4'd15;
            SUB = 1'b0;
            #1;

            check_outputs(1'b1, 4'd14);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Subtraction - Simple (A=10, B=4, SUB=1)", test_num);
            A = 4'd10;
            B = 4'd4;
            SUB = 1'b1;
            #1;

            check_outputs(1'b0, 4'd6);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Subtraction - Result Zero (A=7, B=7, SUB=1)", test_num);
            A = 4'd7;
            B = 4'd7;
            SUB = 1'b1;
            #1;

            check_outputs(1'b0, 4'd0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Subtraction - Underflow (A=4, B=10, SUB=1)", test_num);
            A = 4'd4;
            B = 4'd10;
            SUB = 1'b1;
            #1;

            check_outputs(1'b1, 4'd10);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Subtraction - Zero minus One (A=0, B=1, SUB=1)", test_num);
            A = 4'd0;
            B = 4'd1;
            SUB = 1'b1;
            #1;

            check_outputs(1'b1, 4'd15);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Subtraction - Max minus Zero (A=15, B=0, SUB=1)", test_num);
            A = 4'd15;
            B = 4'd0;
            SUB = 1'b1;
            #1;

            check_outputs(1'b0, 4'd15);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Mode Switching (A=5, B=5, SUB 0->1)", test_num);
            A = 4'd5;
            B = 4'd5;
            SUB = 1'b0;
            #1;
            SUB = 1'b1;
            #1;

            check_outputs(1'b0, 4'd0);
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
        input expected_CARRY;
        input [3:0] expected_SUM;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_CARRY === (expected_CARRY ^ CARRY ^ expected_CARRY) &&
                expected_SUM === (expected_SUM ^ SUM ^ expected_SUM)) begin
                $display("PASS");
                $display("  Outputs: CARRY=%b, SUM=%h",
                         CARRY, SUM);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: CARRY=%b, SUM=%h",
                         expected_CARRY, expected_SUM);
                $display("  Got:      CARRY=%b, SUM=%h",
                         CARRY, SUM);
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
