`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg preset;
    reg [11:0] preset_val;
    reg reset_n;
    wire [11:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .preset(preset),
        .preset_val(preset_val),
        .reset_n(reset_n),
        .q(q)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        reset_n = 0;
        preset = 0;
        preset_val = 12'h000;
        #15;
        reset_n = 1;
        #2;
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("Running Testcase 001: Reset Check");
        reset_dut();
        #1;

        check_outputs(12'h000);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Running Testcase 002: Counting Logic");
        reset_dut();
        repeat(10) @(posedge clk);
        #1;
        #1;

        check_outputs(12'd10);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Running Testcase 003: Preset Value Loading");
        reset_dut();
        @(posedge clk);
        preset = 1;
        preset_val = 12'hABC;
        @(posedge clk);
        #1;
        preset = 0;
        #1;

        check_outputs(12'hABC);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Running Testcase 004: Count from Preset Value");
        reset_dut();
        @(posedge clk);
        preset = 1;
        preset_val = 12'h100;
        @(posedge clk);
        preset = 0;
        repeat(5) @(posedge clk);
        #1;
        #1;

        check_outputs(12'h100 + 12'd5);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Running Testcase 005: Counter Rollover");
        reset_dut();
        @(posedge clk);
        preset = 1;
        preset_val = 12'hFFF;
        @(posedge clk);
        preset = 0;
        @(posedge clk);
        #1;
        #1;

        check_outputs(12'h000);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Running Testcase 006: Async Reset Mid-count");
        reset_dut();
        repeat(5) @(posedge clk);
        #3;
        reset_n = 0;
        #1;
        #1;

        check_outputs(12'h000);
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
        input [11:0] expected_q;
        begin
            if (expected_q === (expected_q ^ q ^ expected_q)) begin
                $display("PASS");
                $display("  Outputs: q=%h",
                         q);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: q=%h",
                         expected_q);
                $display("  Got:      q=%h",
                         q);
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
        $dumpvars(0,clk, preset, preset_val, reset_n, q);
    end

endmodule
