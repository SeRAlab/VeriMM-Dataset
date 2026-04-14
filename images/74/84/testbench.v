`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [49:0] in;
    wire majority_out;
    wire out_and;
    wire out_or;
    wire out_xor;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .in(in),
        .majority_out(majority_out),
        .out_and(out_and),
        .out_or(out_or),
        .out_xor(out_xor)
    );
    task testcase001;

        begin
            $display("Test Case 001: All Zeros");
            in = 50'h0;

            #1;


            check_outputs(1'b0, 1'b0, 1'b0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            $display("Test Case 002: All Ones");
            in = {50{1'b1}};

            #1;


            check_outputs(1'b1, 1'b1, 1'b1, 1'b0);
        end
        endtask

    task testcase003;

        begin
            $display("Test Case 003: Single Bit Set");
            in = 50'h1;

            #1;


            check_outputs(1'b0, 1'b0, 1'b1, 1'b1);
        end
        endtask

    task testcase004;

        begin
            $display("Test Case 004: Exactly 24 Bits (Just below majority)");
            in = 50'h0000000FFFFFF;

            #1;


            check_outputs(1'b0, 1'b0, 1'b1, 1'b0);
        end
        endtask

    task testcase005;

        begin
            $display("Test Case 005: Exactly 25 Bits (Majority threshold)");
            in = 50'h0000001FFFFFF;

            #1;


            check_outputs(1'b1, 1'b0, 1'b1, 1'b1);
        end
        endtask

    task testcase006;

        begin
            $display("Test Case 006: Exactly 26 Bits (Just above majority)");
            in = 50'h0000003FFFFFF;

            #1;


            check_outputs(1'b1, 1'b0, 1'b1, 1'b0);
        end
        endtask

    task testcase007;

        begin
            $display("Test Case 007: Alternating bits (25 bits set)");
            in = 50'h1555555555555;


            #1;



            check_outputs(1'b1, 1'b0, 1'b1, 1'b1);
        end
        endtask

    task testcase008;

        begin
            $display("Test Case 008: 49 Bits Set");
            in = {50{1'b1}} ^ 50'h1;

            #1;


            check_outputs(1'b1, 1'b0, 1'b1, 1'b1);
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
        input expected_majority_out;
        input expected_out_and;
        input expected_out_or;
        input expected_out_xor;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_majority_out === (expected_majority_out ^ majority_out ^ expected_majority_out) &&
                expected_out_and === (expected_out_and ^ out_and ^ expected_out_and) &&
                expected_out_or === (expected_out_or ^ out_or ^ expected_out_or) &&
                expected_out_xor === (expected_out_xor ^ out_xor ^ expected_out_xor)) begin
                $display("PASS");
                $display("  Outputs: majority_out=%b, out_and=%b, out_or=%b, out_xor=%b",
                         majority_out, out_and, out_or, out_xor);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: majority_out=%b, out_and=%b, out_or=%b, out_xor=%b",
                         expected_majority_out, expected_out_and, expected_out_or, expected_out_xor);
                $display("  Got:      majority_out=%b, out_and=%b, out_or=%b, out_xor=%b",
                         majority_out, out_and, out_or, out_xor);
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
