`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] A_in;
    reg [15:0] B_in;
    wire [15:0] abs_diff_out;
    wire [15:0] and_out;
    wire [15:0] diff_out;
    wire [15:0] or_out;
    wire [15:0] sum_out;
    wire [15:0] xor_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A_in(A_in),
        .B_in(B_in),
        .abs_diff_out(abs_diff_out),
        .and_out(and_out),
        .diff_out(diff_out),
        .or_out(or_out),
        .sum_out(sum_out),
        .xor_out(xor_out)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            A_in = 16'h0005; B_in = 16'h0003;

            #1;


            check_outputs(16'h0002, 16'h0001, 16'h0002, 16'h0007, 16'h0008, 16'h0006);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            A_in = 16'h000A; B_in = 16'h0014;

            #1;


            check_outputs(16'h000A, 16'h0000, 16'hFFF6, 16'h001E, 16'h001E, 16'h001E);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            A_in = 16'hFFFF; B_in = 16'h0001;

            #1;


            check_outputs(16'hFFFE, 16'h0001, 16'hFFFE, 16'hFFFF, 16'h0000, 16'hFFFE);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            A_in = 16'hAAAA; B_in = 16'hAAAA;

            #1;


            check_outputs(16'h0000, 16'hAAAA, 16'h0000, 16'hAAAA, 16'h5554, 16'h0000);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            A_in = 16'h5555; B_in = 16'hAAAA;

            #1;


            check_outputs(16'h5555, 16'h0000, 16'hAAA5, 16'hFFFF, 16'hFFFF, 16'hFFFF);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            A_in = 16'h0000; B_in = 16'h0000;
            #1;

            check_outputs(16'h0000, 16'h0000, 16'h0000, 16'h0000, 16'h0000, 16'h0000);
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
        input [15:0] expected_abs_diff_out;
        input [15:0] expected_and_out;
        input [15:0] expected_diff_out;
        input [15:0] expected_or_out;
        input [15:0] expected_sum_out;
        input [15:0] expected_xor_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_abs_diff_out === (expected_abs_diff_out ^ abs_diff_out ^ expected_abs_diff_out) &&
                expected_and_out === (expected_and_out ^ and_out ^ expected_and_out) &&
                expected_diff_out === (expected_diff_out ^ diff_out ^ expected_diff_out) &&
                expected_or_out === (expected_or_out ^ or_out ^ expected_or_out) &&
                expected_sum_out === (expected_sum_out ^ sum_out ^ expected_sum_out) &&
                expected_xor_out === (expected_xor_out ^ xor_out ^ expected_xor_out)) begin
                $display("PASS");
                $display("  Outputs: abs_diff_out=%h, and_out=%h, diff_out=%h, or_out=%h, sum_out=%h, xor_out=%h",
                         abs_diff_out, and_out, diff_out, or_out, sum_out, xor_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: abs_diff_out=%h, and_out=%h, diff_out=%h, or_out=%h, sum_out=%h, xor_out=%h",
                         expected_abs_diff_out, expected_and_out, expected_diff_out, expected_or_out, expected_sum_out, expected_xor_out);
                $display("  Got:      abs_diff_out=%h, and_out=%h, diff_out=%h, or_out=%h, sum_out=%h, xor_out=%h",
                         abs_diff_out, and_out, diff_out, or_out, sum_out, xor_out);
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
