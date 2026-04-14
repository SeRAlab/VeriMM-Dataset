`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg a;
    reg b;
    wire and_op;
    wire nand_op;
    wire nor_op;
    wire not_op;
    wire or_op;
    wire xnor_op;
    wire xor_op;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .and_op(and_op),
        .nand_op(nand_op),
        .nor_op(nor_op),
        .not_op(not_op),
        .or_op(or_op),
        .xnor_op(xnor_op),
        .xor_op(xor_op)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case 001: a=0, b=0");
            a = 1'b0;
            b = 1'b0;


            #1;



            check_outputs(1'b0, 1'b1, 1'b1, 1'b1, 1'b0, 1'b1, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case 002: a=0, b=1");
            a = 1'b0;
            b = 1'b1;

            #1;


            check_outputs(1'b0, 1'b1, 1'b0, 1'b1, 1'b1, 1'b0, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case 003: a=1, b=0");
            a = 1'b1;
            b = 1'b0;

            #1;


            check_outputs(1'b0, 1'b1, 1'b0, 1'b0, 1'b1, 1'b0, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case 004: a=1, b=1");
            a = 1'b1;
            b = 1'b1;

            #1;


            check_outputs(1'b1, 1'b0, 1'b0, 1'b0, 1'b1, 1'b1, 1'b0);
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
        input expected_and_op;
        input expected_nand_op;
        input expected_nor_op;
        input expected_not_op;
        input expected_or_op;
        input expected_xnor_op;
        input expected_xor_op;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_and_op === (expected_and_op ^ and_op ^ expected_and_op) &&
                expected_nand_op === (expected_nand_op ^ nand_op ^ expected_nand_op) &&
                expected_nor_op === (expected_nor_op ^ nor_op ^ expected_nor_op) &&
                expected_not_op === (expected_not_op ^ not_op ^ expected_not_op) &&
                expected_or_op === (expected_or_op ^ or_op ^ expected_or_op) &&
                expected_xnor_op === (expected_xnor_op ^ xnor_op ^ expected_xnor_op) &&
                expected_xor_op === (expected_xor_op ^ xor_op ^ expected_xor_op)) begin
                $display("PASS");
                $display("  Outputs: and_op=%b, nand_op=%b, nor_op=%b, not_op=%b, or_op=%b, xnor_op=%b, xor_op=%b",
                         and_op, nand_op, nor_op, not_op, or_op, xnor_op, xor_op);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: and_op=%b, nand_op=%b, nor_op=%b, not_op=%b, or_op=%b, xnor_op=%b, xor_op=%b",
                         expected_and_op, expected_nand_op, expected_nor_op, expected_not_op, expected_or_op, expected_xnor_op, expected_xor_op);
                $display("  Got:      and_op=%b, nand_op=%b, nor_op=%b, not_op=%b, or_op=%b, xnor_op=%b, xor_op=%b",
                         and_op, nand_op, nor_op, not_op, or_op, xnor_op, xor_op);
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
