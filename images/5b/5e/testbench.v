`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg a;
    reg b;
    wire and_out;
    wire not_out;
    wire or_out;
    wire xnor_out;
    wire xor_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .and_out(and_out),
        .not_out(not_out),
        .or_out(or_out),
        .xnor_out(xnor_out),
        .xor_out(xor_out)
    );
    task testcase001;

        begin
            test_num = 1;
            a = 0;
            b = 0;

            $display("Running testcase001: a=0, b=0");
            #1;

            check_outputs(1'b0, 1'b1, 1'b0, 1'b1, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            a = 0;
            b = 1;

            $display("Running testcase002: a=0, b=1");
            #1;

            check_outputs(1'b0, 1'b1, 1'b1, 1'b0, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            a = 1;
            b = 0;

            $display("Running testcase003: a=1, b=0");
            #1;

            check_outputs(1'b0, 1'b0, 1'b1, 1'b0, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            a = 1;
            b = 1;

            $display("Running testcase004: a=1, b=1");
            #1;

            check_outputs(1'b1, 1'b0, 1'b1, 1'b1, 1'b0);
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
        input expected_and_out;
        input expected_not_out;
        input expected_or_out;
        input expected_xnor_out;
        input expected_xor_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_and_out === (expected_and_out ^ and_out ^ expected_and_out) &&
                expected_not_out === (expected_not_out ^ not_out ^ expected_not_out) &&
                expected_or_out === (expected_or_out ^ or_out ^ expected_or_out) &&
                expected_xnor_out === (expected_xnor_out ^ xnor_out ^ expected_xnor_out) &&
                expected_xor_out === (expected_xor_out ^ xor_out ^ expected_xor_out)) begin
                $display("PASS");
                $display("  Outputs: and_out=%b, not_out=%b, or_out=%b, xnor_out=%b, xor_out=%b",
                         and_out, not_out, or_out, xnor_out, xor_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: and_out=%b, not_out=%b, or_out=%b, xnor_out=%b, xor_out=%b",
                         expected_and_out, expected_not_out, expected_or_out, expected_xnor_out, expected_xor_out);
                $display("  Got:      and_out=%b, not_out=%b, or_out=%b, xnor_out=%b, xor_out=%b",
                         and_out, not_out, or_out, xnor_out, xor_out);
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
