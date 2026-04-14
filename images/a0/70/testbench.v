`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] a;
    reg [3:0] b;
    reg sub;
    wire overflow;
    wire [3:0] sum;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .sub(sub),
        .overflow(overflow),
        .sum(sum)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Positive Addition (No Overflow): 3 + 2 = 5", test_num);
            a = 4'h3; b = 4'h2; sub = 1'b0;
            #1;

            check_outputs(1'b0, 4'h5);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Positive Addition (With Overflow): 6 + 2 = 8 (-8)", test_num);
            a = 4'h6; b = 4'h2; sub = 1'b0;
            #1;

            check_outputs(1'b1, 4'h8);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Negative Addition (No Overflow): -3 + -2 = -5", test_num);
            a = 4'hd; b = 4'he; sub = 1'b0;
            #1;

            check_outputs(1'b0, 4'hb);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Negative Addition (With Overflow): -6 + -5 = -11 (5)", test_num);
            a = 4'ha; b = 4'hb; sub = 1'b0;
            #1;

            check_outputs(1'b1, 4'h5);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Positive Subtraction: 7 - 3 = 4", test_num);
            a = 4'h7; b = 4'h3; sub = 1'b1;
            #1;

            check_outputs(1'b0, 4'h4);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Negative Subtraction: -5 - 2 = -7", test_num);
            a = 4'hb; b = 4'h2; sub = 1'b1;
            #1;

            check_outputs(1'b0, 4'h9);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Subtraction (Positive Overflow): 5 - (-4) = 9 (-7)", test_num);
            a = 4'h5; b = 4'hc; sub = 1'b1;
            #1;

            check_outputs(1'b1, 4'h9);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Subtraction (Negative Overflow): -5 - 4 = -9 (7)", test_num);
            a = 4'hb; b = 4'h4; sub = 1'b1;
            #1;

            check_outputs(1'b1, 4'h7);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Zero Addition: 0 + 0 = 0", test_num);
            a = 4'h0; b = 4'h0; sub = 1'b0;
            #1;

            check_outputs(1'b0, 4'h0);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Extreme Subtraction (Overflow): -8 - 1 = -9 (7)", test_num);
            a = 4'h8; b = 4'h1; sub = 1'b1;
            #1;

            check_outputs(1'b1, 4'h7);
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
        input expected_overflow;
        input [3:0] expected_sum;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_overflow === (expected_overflow ^ overflow ^ expected_overflow) &&
                expected_sum === (expected_sum ^ sum ^ expected_sum)) begin
                $display("PASS");
                $display("  Outputs: overflow=%b, sum=%h",
                         overflow, sum);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: overflow=%b, sum=%h",
                         expected_overflow, expected_sum);
                $display("  Got:      overflow=%b, sum=%h",
                         overflow, sum);
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
