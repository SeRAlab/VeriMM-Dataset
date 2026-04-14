`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk_in;
    reg clk_ref;
    reg reset;
    wire dll_locked;
    wire dll_out;
    wire pll_locked;
    wire pll_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk_in(clk_in),
        .clk_ref(clk_ref),
        .reset(reset),
        .dll_locked(dll_locked),
        .dll_out(dll_out),
        .pll_locked(pll_locked),
        .pll_out(pll_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk_in = 0;
        forever #5 clk_in = ~clk_in;
    end

        task reset_dut;

        begin
            reset = 1;
            #100;
            reset = 0;
            #100;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("\nTestcase %0d: Testing 100 MHz synchronization (Standard)", test_num);
            current_half_period = 5.0;
            reset_dut();
            #10000;

            #1;


            check_outputs(1'b1, dll_out, 1'b1, pll_out);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTestcase %0d: Testing 10 MHz synchronization (Minimum Freq)", test_num);
            current_half_period = 50.0;
            reset_dut();
            #20000;
            #1;

            check_outputs(1'b1, dll_out, 1'b1, pll_out);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTestcase %0d: Testing 500 MHz synchronization (Maximum Freq)", test_num);
            current_half_period = 1.0;
            reset_dut();
            #10000;
            #1;

            check_outputs(1'b1, dll_out, 1'b1, pll_out);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTestcase %0d: Testing 250 MHz synchronization", test_num);
            current_half_period = 2.0;
            reset_dut();
            #10000;
            #1;

            check_outputs(1'b1, dll_out, 1'b1, pll_out);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nTestcase %0d: Testing Out-of-Range Low Frequency (5 MHz)", test_num);
            current_half_period = 100.0;
            reset_dut();
            #10000;

            #1;


            check_outputs(1'b0, dll_out, 1'b0, pll_out);
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
        input expected_dll_locked;
        input expected_dll_out;
        input expected_pll_locked;
        input expected_pll_out;
        begin
            if (expected_dll_locked === (expected_dll_locked ^ dll_locked ^ expected_dll_locked) &&
                expected_dll_out === (expected_dll_out ^ dll_out ^ expected_dll_out) &&
                expected_pll_locked === (expected_pll_locked ^ pll_locked ^ expected_pll_locked) &&
                expected_pll_out === (expected_pll_out ^ pll_out ^ expected_pll_out)) begin
                $display("PASS");
                $display("  Outputs: dll_locked=%b, dll_out=%b, pll_locked=%b, pll_out=%b",
                         dll_locked, dll_out, pll_locked, pll_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: dll_locked=%b, dll_out=%b, pll_locked=%b, pll_out=%b",
                         expected_dll_locked, expected_dll_out, expected_pll_locked, expected_pll_out);
                $display("  Got:      dll_locked=%b, dll_out=%b, pll_locked=%b, pll_out=%b",
                         dll_locked, dll_out, pll_locked, pll_out);
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

    // Optional: Waveform dump for debugging
    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0,clk_in, clk_ref, reset, dll_locked, dll_out, pll_locked, pll_out);
    end

endmodule
