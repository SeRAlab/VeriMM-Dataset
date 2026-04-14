`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] A;
    reg [3:0] B;
    reg [1:0] op;
    wire [3:0] diff;
    wire [3:0] prod;
    wire [3:0] quot;
    wire [3:0] sum;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .op(op),
        .diff(diff),
        .prod(prod),
        .quot(quot),
        .sum(sum)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("\nTestcase %0d: Addition (Basic) - 5 + 3", test_num);
            A = 4'd5;
            B = 4'd3;
            op = 2'b00;

            #1;


            check_outputs(4'd0, 4'd0, 4'd0, 4'd8);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTestcase %0d: Subtraction (Basic) - 10 - 4", test_num);
            A = 4'd10;
            B = 4'd4;
            op = 2'b01;

            #1;


            check_outputs(4'd6, 4'd0, 4'd0, 4'd0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTestcase %0d: Multiplication (Basic) - 3 * 4", test_num);
            A = 4'd3;
            B = 4'd4;
            op = 2'b10;

            #1;


            check_outputs(4'd0, 4'd12, 4'd0, 4'd0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTestcase %0d: Division (Basic) - 12 / 3", test_num);
            A = 4'd12;
            B = 4'd3;
            op = 2'b11;

            #1;


            check_outputs(4'd0, 4'd0, 4'd4, 4'd0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nTestcase %0d: Division by Zero - 7 / 0", test_num);
            A = 4'd7;
            B = 4'd0;
            op = 2'b11;

            #1;


            check_outputs(4'd0, 4'd0, 4'd0, 4'd0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("\nTestcase %0d: Addition (Overflow) - 12 + 7", test_num);
            A = 4'd12;
            B = 4'd7;
            op = 2'b00;

            #1;


            check_outputs(4'd0, 4'd0, 4'd0, 4'd3);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("\nTestcase %0d: Subtraction (Underflow/Wrap) - 4 - 6", test_num);
            A = 4'd4;
            B = 4'd6;
            op = 2'b01;

            #1;


            check_outputs(4'd14, 4'd0, 4'd0, 4'd0);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("\nTestcase %0d: Multiplication (Overflow) - 8 * 2", test_num);
            A = 4'd8;
            B = 4'd2;
            op = 2'b10;

            #1;


            check_outputs(4'd0, 4'd0, 4'd0, 4'd0);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            $display("\nTestcase %0d: Division (Truncation) - 10 / 3", test_num);
            A = 4'd10;
            B = 4'd3;
            op = 2'b11;

            #1;


            check_outputs(4'd0, 4'd0, 4'd3, 4'd0);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            $display("\nTestcase %0d: Boundary Values - 15 + 1", test_num);
            A = 4'd15;
            B = 4'd1;
            op = 2'b00;

            #1;


            check_outputs(4'd0, 4'd0, 4'd0, 4'd0);
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
        input [3:0] expected_diff;
        input [3:0] expected_prod;
        input [3:0] expected_quot;
        input [3:0] expected_sum;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_diff === (expected_diff ^ diff ^ expected_diff) &&
                expected_prod === (expected_prod ^ prod ^ expected_prod) &&
                expected_quot === (expected_quot ^ quot ^ expected_quot) &&
                expected_sum === (expected_sum ^ sum ^ expected_sum)) begin
                $display("PASS");
                $display("  Outputs: diff=%h, prod=%h, quot=%h, sum=%h",
                         diff, prod, quot, sum);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: diff=%h, prod=%h, quot=%h, sum=%h",
                         expected_diff, expected_prod, expected_quot, expected_sum);
                $display("  Got:      diff=%h, prod=%h, quot=%h, sum=%h",
                         diff, prod, quot, sum);
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
