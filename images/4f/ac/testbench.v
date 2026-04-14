`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg i_op;
    reg [63:0] i_wf_in;
    reg [31:0] i_wk;
    wire [63:0] o_wf_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .i_op(i_op),
        .i_wf_in(i_wf_in),
        .i_wk(i_wk),
        .o_wf_out(o_wf_out)
    );
    task testcase001;

        begin
            $display("Test Case 001: All Zeros - Addition Mode");

            i_op = 0; i_wf_in = 64'h0; i_wk = 32'h0;
            #10;
            #1;

            check_outputs(calculate_expected(i_op, i_wf_in, i_wk));
        end
        endtask

    task testcase002;

        begin
            $display("Test Case 002: Simple Addition (No Carry)");

            i_op = 0; i_wf_in = 64'hA5A5_0000_1010_2020; i_wk = 32'h0000_1111;
            #10;
            #1;

            check_outputs(calculate_expected(i_op, i_wf_in, i_wk));
        end
        endtask

    task testcase003;

        begin
            $display("Test Case 003: Simple Subtraction (No Borrow)");

            i_op = 1; i_wf_in = 64'hA5A5_0000_8888_FFFF; i_wk = 32'h0000_1111;
            #10;
            #1;

            check_outputs(calculate_expected(i_op, i_wf_in, i_wk));
        end
        endtask

    task testcase004;

        begin
            $display("Test Case 004: 32-bit Segment Overflow (Addition)");

            i_op = 0; i_wf_in = 64'h0000_0000_0000_FFFF_FFFF; i_wk = 32'h0000_0001;
            #10;
            #1;

            check_outputs(calculate_expected(i_op, i_wf_in, i_wk));
        end
        endtask

    task testcase005;

        begin
            $display("Test Case 005: 8-bit Segment Underflow (Subtraction)");

            i_op = 1; i_wf_in = 64'h0000_0000_0000_0000_0000; i_wk = 32'h0000_0100;
            #10;

            #1;


            check_outputs(calculate_expected(i_op, i_wf_in, i_wk));
        end
        endtask

    task testcase006;

        begin
            $display("Test Case 006: XOR and Bit Retention Check");

            i_op = 0;
            i_wf_in = 64'hFF00_AAAA_0000_0000;
            i_wk = 32'h5555_0000;
            #10;

            #1;


            check_outputs(calculate_expected(i_op, i_wf_in, i_wk));
        end
        endtask

    task testcase007;

        begin
            $display("Test Case 007: Maximum Values - Subtraction Mode");

            i_op = 1; i_wf_in = 64'hFFFF_FFFF_FFFF_FFFF; i_wk = 32'hFFFF_FFFF;
            #10;
            #1;

            check_outputs(calculate_expected(i_op, i_wf_in, i_wk));
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
        input [63:0] expected_o_wf_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_o_wf_out === (expected_o_wf_out ^ o_wf_out ^ expected_o_wf_out)) begin
                $display("PASS");
                $display("  Outputs: o_wf_out=%h",
                         o_wf_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: o_wf_out=%h",
                         expected_o_wf_out);
                $display("  Got:      o_wf_out=%h",
                         o_wf_out);
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
