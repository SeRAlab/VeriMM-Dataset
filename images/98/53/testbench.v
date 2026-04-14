`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [10:0] div;
    reg rst;
    wire clk_1kHz;
    wire clkd;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .div(div),
        .rst(rst),
        .clk_1kHz(clk_1kHz),
        .clkd(clkd)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            div = 0;
            #20;
            @(posedge clk);
            #2 rst = 0;
            $display("\n[Reset] DUT reset complete at %0t", $time);
        end
        endtask
    task testcase001;

        begin
            $display("\nRunning testcase001: div=10, wait 10 cycles...");
            reset_dut();
            div = 10;
            repeat (10) @(posedge clk);
            #2;
            #1;

            check_outputs(0, 1);
        end
        endtask

    task testcase002;

        begin
            $display("\nRunning testcase002: div=10, wait 20 cycles...");
            reset_dut();
            div = 10;
            repeat (20) @(posedge clk);
            #2;
            #1;

            check_outputs(0, 0);
        end
        endtask

    task testcase003;

        begin
            $display("\nRunning testcase003: div=2047, wait 2047 cycles...");
            reset_dut();
            div = 11'h7FF;
            repeat (2047) @(posedge clk);
            #2;
            #1;

            check_outputs(0, 1);
        end
        endtask

    task testcase004;

        begin
            $display("\nRunning testcase004: div=1, wait 1 cycle...");
            reset_dut();
            div = 1;
            repeat (1) @(posedge clk);
            #2;
            #1;

            check_outputs(0, 1);
        end
        endtask

    task testcase005;

        begin
            $display("\nRunning testcase005: Checking clk_1kHz toggle (50,000 cycles)...");
            reset_dut();
            div = 100;
            repeat (50000) @(posedge clk);
            #2;



            #1;




            check_outputs(1, 0);
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
        input expected_clk_1kHz;
        input expected_clkd;
        begin
            if (expected_clk_1kHz === (expected_clk_1kHz ^ clk_1kHz ^ expected_clk_1kHz) &&
                expected_clkd === (expected_clkd ^ clkd ^ expected_clkd)) begin
                $display("PASS");
                $display("  Outputs: clk_1kHz=%b, clkd=%b",
                         clk_1kHz, clkd);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: clk_1kHz=%b, clkd=%b",
                         expected_clk_1kHz, expected_clkd);
                $display("  Got:      clk_1kHz=%b, clkd=%b",
                         clk_1kHz, clkd);
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
        $dumpvars(0,clk, div, rst, clk_1kHz, clkd);
    end

endmodule
