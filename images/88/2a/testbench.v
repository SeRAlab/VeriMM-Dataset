`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] A;
    reg [3:0] B;
    reg ctrl;
    wire [3:0] difference;
    wire [3:0] sum;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .ctrl(ctrl),
        .difference(difference),
        .sum(sum)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Sum Mode (ctrl=0) - Simple Addition", test_num);
            A = 4'd5;
            B = 4'd3;
            ctrl = 1'b0;

            #1;


            check_outputs(4'bx, 4'd8);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Sum Mode (ctrl=0) - Max Values (Overflow check)", test_num);
            A = 4'd15;
            B = 4'd1;
            ctrl = 1'b0;

            #1;


            check_outputs(4'bx, 4'd0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Sum Mode (ctrl=0) - Zero Addition", test_num);
            A = 4'd0;
            B = 4'd0;
            ctrl = 1'b0;
            #1;

            check_outputs(4'bx, 4'd0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Difference Mode (ctrl=1) - Simple Subtraction", test_num);
            A = 4'd10;
            B = 4'd4;
            ctrl = 1'b1;

            #1;


            check_outputs(4'd6, 4'bx);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Difference Mode (ctrl=1) - Underflow Subtraction", test_num);
            A = 4'd2;
            B = 4'd5;
            ctrl = 1'b1;

            #1;


            check_outputs(4'd13, 4'bx);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Difference Mode (ctrl=1) - Result Zero", test_num);
            A = 4'd7;
            B = 4'd7;
            ctrl = 1'b1;
            #1;

            check_outputs(4'd0, 4'bx);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Mode Switching - Switch from Diff to Sum", test_num);

            A = 4'd8;
            B = 4'd2;
            ctrl = 1'b1;
            #5;

            ctrl = 1'b0;
            #1;

            check_outputs(4'bx, 4'd10);
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
        input [3:0] expected_difference;
        input [3:0] expected_sum;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_difference === (expected_difference ^ difference ^ expected_difference) &&
                expected_sum === (expected_sum ^ sum ^ expected_sum)) begin
                $display("PASS");
                $display("  Outputs: difference=%h, sum=%h",
                         difference, sum);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: difference=%h, sum=%h",
                         expected_difference, expected_sum);
                $display("  Got:      difference=%h, sum=%h",
                         difference, sum);
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
