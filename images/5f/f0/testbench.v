`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] A;
    reg [3:0] B;
    reg Sub;
    wire [3:0] Diff;
    wire [3:0] Sum;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .Sub(Sub),
        .Diff(Diff),
        .Sum(Sum)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Simple Addition (Sub=0)", test_num);
            A = 4'd5; B = 4'd2; Sub = 1'b0;

            #1;


            check_outputs(4'h3, 4'h7);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Simple Subtraction (Sub=1)", test_num);
            A = 4'd7; B = 4'd3; Sub = 1'b1;

            #1;


            check_outputs(4'h4, 4'h4);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Subtraction Resulting in Negative (Sub=1)", test_num);
            A = 4'd2; B = 4'd5; Sub = 1'b1;

            #1;


            check_outputs(4'hD, 4'hD);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Addition with Negative Inputs (Sub=0)", test_num);
            A = 4'hF;
            B = 4'hE;
            Sub = 1'b0;

            #1;


            check_outputs(4'h1, 4'hD);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Operation with Zero", test_num);
            A = 4'd0; B = 4'd0; Sub = 1'b0;

            #1;


            check_outputs(4'h0, 4'h0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Addition Resulting in Positive Overflow (Sub=0)", test_num);
            A = 4'd7; B = 4'd1; Sub = 1'b0;

            #1;


            check_outputs(4'h6, 4'h8);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Subtraction Resulting in Negative Overflow (Sub=1)", test_num);
            A = 4'h8;
            B = 4'h1;
            Sub = 1'b1;

            #1;


            check_outputs(4'h7, 4'h7);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Diff always reflects A-B during Addition", test_num);
            A = 4'd3; B = 4'd6; Sub = 1'b0;

            #1;


            check_outputs(4'hD, 4'h9);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Boundary - Max Negative Addition", test_num);
            A = 4'h8;
            B = 4'h8;
            Sub = 1'b0;

            #1;


            check_outputs(4'h0, 4'h0);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Boundary - Subtraction to Zero", test_num);
            A = 4'h8; B = 4'h8; Sub = 1'b1;

            #1;


            check_outputs(4'h0, 4'h0);
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
        input [3:0] expected_Diff;
        input [3:0] expected_Sum;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Diff === (expected_Diff ^ Diff ^ expected_Diff) &&
                expected_Sum === (expected_Sum ^ Sum ^ expected_Sum)) begin
                $display("PASS");
                $display("  Outputs: Diff=%h, Sum=%h",
                         Diff, Sum);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Diff=%h, Sum=%h",
                         expected_Diff, expected_Sum);
                $display("  Got:      Diff=%h, Sum=%h",
                         Diff, Sum);
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
