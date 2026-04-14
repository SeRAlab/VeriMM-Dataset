`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg clk;
    reg [13:0] dac_dataA;
    reg [13:0] dac_dataB;
    wire dac_clkA_out;
    wire dac_clkB_out;
    wire [13:0] dac_dataA_out;
    wire [13:0] dac_dataB_out;
    wire dac_gset_out;
    wire dac_mode_out;
    wire dac_sleep_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .dac_dataA(dac_dataA),
        .dac_dataB(dac_dataB),
        .dac_clkA_out(dac_clkA_out),
        .dac_clkB_out(dac_clkB_out),
        .dac_dataA_out(dac_dataA_out),
        .dac_dataB_out(dac_dataB_out),
        .dac_gset_out(dac_gset_out),
        .dac_mode_out(dac_mode_out),
        .dac_sleep_out(dac_sleep_out)
    );
    task testcase001;

        begin
            $display("Test Case 001: Minimum values and Clock Low");
            test_num = 1;
            clk = 1'b0;
            dac_dataA = 14'h0000;
            dac_dataB = 14'h0000;
            #10;

            #1;


            check_outputs(1'b1, 1'b1, 14'h0000, 14'h0000, 1'b1, 1'b1, 1'b0);
        end
        endtask

    task testcase002;

        begin
            $display("Test Case 002: Maximum values and Clock High");
            test_num = 2;
            clk = 1'b1;
            dac_dataA = 14'h3FFF;
            dac_dataB = 14'h3FFF;
            #10;

            #1;


            check_outputs(1'b0, 1'b0, 14'h3FFF, 14'h3FFF, 1'b1, 1'b1, 1'b0);
        end
        endtask

    task testcase003;

        begin
            $display("Test Case 003: Alternating bit patterns (Pattern 1)");
            test_num = 3;
            clk = 1'b0;
            dac_dataA = 14'h1555;
            dac_dataB = 14'h2AAA;
            #10;

            #1;


            check_outputs(1'b1, 1'b1, 14'h1555, 14'h2AAA, 1'b1, 1'b1, 1'b0);
        end
        endtask

    task testcase004;

        begin
            $display("Test Case 004: Alternating bit patterns (Pattern 2)");
            test_num = 4;
            clk = 1'b1;
            dac_dataA = 14'h2AAA;
            dac_dataB = 14'h1555;
            #10;

            #1;


            check_outputs(1'b0, 1'b0, 14'h2AAA, 14'h1555, 1'b1, 1'b1, 1'b0);
        end
        endtask

    task testcase005;

        begin
            $display("Test Case 005: Random data check");
            test_num = 5;
            clk = 1'b0;
            dac_dataA = 14'h0F0F;
            dac_dataB = 14'h3030;
            #10;

            #1;


            check_outputs(1'b1, 1'b1, 14'h0F0F, 14'h3030, 1'b1, 1'b1, 1'b0);
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
        input expected_dac_clkA_out;
        input expected_dac_clkB_out;
        input [13:0] expected_dac_dataA_out;
        input [13:0] expected_dac_dataB_out;
        input expected_dac_gset_out;
        input expected_dac_mode_out;
        input expected_dac_sleep_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_dac_clkA_out === (expected_dac_clkA_out ^ dac_clkA_out ^ expected_dac_clkA_out) &&
                expected_dac_clkB_out === (expected_dac_clkB_out ^ dac_clkB_out ^ expected_dac_clkB_out) &&
                expected_dac_dataA_out === (expected_dac_dataA_out ^ dac_dataA_out ^ expected_dac_dataA_out) &&
                expected_dac_dataB_out === (expected_dac_dataB_out ^ dac_dataB_out ^ expected_dac_dataB_out) &&
                expected_dac_gset_out === (expected_dac_gset_out ^ dac_gset_out ^ expected_dac_gset_out) &&
                expected_dac_mode_out === (expected_dac_mode_out ^ dac_mode_out ^ expected_dac_mode_out) &&
                expected_dac_sleep_out === (expected_dac_sleep_out ^ dac_sleep_out ^ expected_dac_sleep_out)) begin
                $display("PASS");
                $display("  Outputs: dac_clkA_out=%b, dac_clkB_out=%b, dac_dataA_out=%h, dac_dataB_out=%h, dac_gset_out=%b, dac_mode_out=%b, dac_sleep_out=%b",
                         dac_clkA_out, dac_clkB_out, dac_dataA_out, dac_dataB_out, dac_gset_out, dac_mode_out, dac_sleep_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: dac_clkA_out=%b, dac_clkB_out=%b, dac_dataA_out=%h, dac_dataB_out=%h, dac_gset_out=%b, dac_mode_out=%b, dac_sleep_out=%b",
                         expected_dac_clkA_out, expected_dac_clkB_out, expected_dac_dataA_out, expected_dac_dataB_out, expected_dac_gset_out, expected_dac_mode_out, expected_dac_sleep_out);
                $display("  Got:      dac_clkA_out=%b, dac_clkB_out=%b, dac_dataA_out=%h, dac_dataB_out=%h, dac_gset_out=%b, dac_mode_out=%b, dac_sleep_out=%b",
                         dac_clkA_out, dac_clkB_out, dac_dataA_out, dac_dataB_out, dac_gset_out, dac_mode_out, dac_sleep_out);
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
