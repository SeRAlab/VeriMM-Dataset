`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg reset_n;
    reg shift;
    wire [9:0] lfsr;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .reset_n(reset_n),
        .shift(shift),
        .lfsr(lfsr)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            shift = 0;
            reset_n = 1;
            @(negedge clk);
            reset_n = 0;
            @(negedge clk);
            reset_n = 1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case %03d: Synchronous Reset", test_num);
            reset_dut();
            #1;

            check_outputs(10'h001);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case %03d: Shift Disable", test_num);
            reset_dut();
            shift = 0;
            repeat(5) @(posedge clk);
            #1;

            check_outputs(10'h001);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case %03d: Single Shift", test_num);
            reset_dut();
            shift = 1;
            @(posedge clk);
            shift = 0;
            #1;

            check_outputs(10'h204);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case %03d: Multiple Shifts (5 Cycles)", test_num);
            reset_dut();
            shift = 1;
            repeat(5) @(posedge clk);
            shift = 0;
            #1;

            check_outputs(10'h122);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case %03d: Reset Priority", test_num);
            reset_dut();
            shift = 1;
            repeat(10) @(posedge clk);

            reset_n = 0;
            @(posedge clk);
            reset_n = 1;
            shift = 0;
            #1;

            check_outputs(10'h001);
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
        input [9:0] expected_lfsr;
        begin
            if (expected_lfsr === (expected_lfsr ^ lfsr ^ expected_lfsr)) begin
                $display("PASS");
                $display("  Outputs: lfsr=%h",
                         lfsr);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: lfsr=%h",
                         expected_lfsr);
                $display("  Got:      lfsr=%h",
                         lfsr);
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
        $dumpvars(0,clk, reset_n, shift, lfsr);
    end

endmodule
