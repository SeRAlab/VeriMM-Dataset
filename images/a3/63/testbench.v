`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clear;
    reg clk;
    reg enable_unit;
    reg reset_n;
    wire [2:0] color;
    wire enable;
    wire reset_datapath;
    wire writeEn;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clear(clear),
        .clk(clk),
        .enable_unit(enable_unit),
        .reset_n(reset_n),
        .color(color),
        .enable(enable),
        .reset_datapath(reset_datapath),
        .writeEn(writeEn)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset_n = 1'b0;
            enable_unit = 1'b0;
            clear = 1'b0;
            @(posedge clk);
            #2 reset_n = 1'b1;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            $display("Running Testcase 001: Initial State (DISABLE)...");
            reset_dut();




            #1;





            check_outputs(3'b111, 0, 0, 0);
        end
        endtask

    task testcase002;

        begin
            $display("Running Testcase 002: Transition to DRAW...");
            reset_dut();
            enable_unit = 1'b1;
            @(posedge clk);
            #2;

            #1;


            check_outputs(3'b111, 1, 1, 1);
        end
        endtask

    task testcase003;

        begin
            $display("Running Testcase 003: DRAW state with clear=1...");
            reset_dut();
            enable_unit = 1'b1;
            clear = 1'b1;
            @(posedge clk);
            #2;

            #1;


            check_outputs(3'b000, 1, 1, 1);
        end
        endtask

    task testcase004;

        begin
            $display("Running Testcase 004: DRAW state then Reset...");
            reset_dut();
            enable_unit = 1'b1;
            @(posedge clk);
            #2;

            if (enable !== 1'b1) $display("Error: Failed to enter DRAW");


            reset_n = 1'b0;
            @(posedge clk);
            #2;

            #1;


            check_outputs(3'b111, 0, 0, 0);
        end
        endtask

    task testcase005;

        begin
            $display("Running Testcase 005: Idle in DISABLE...");
            reset_dut();
            enable_unit = 1'b0;
            @(posedge clk);
            @(posedge clk);
            #2;

            #1;


            check_outputs(3'b111, 0, 0, 0);
        end
        endtask

    task testcase006;

        begin
            $display("Running Testcase 006: Stay in DRAW state...");
            reset_dut();
            enable_unit = 1'b1;
            @(posedge clk);
            #2;

            @(posedge clk);
            #2;

            #1;


            check_outputs(3'b111, 1, 1, 1);
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
        input [2:0] expected_color;
        input expected_enable;
        input expected_reset_datapath;
        input expected_writeEn;
        begin
            if (expected_color === (expected_color ^ color ^ expected_color) &&
                expected_enable === (expected_enable ^ enable ^ expected_enable) &&
                expected_reset_datapath === (expected_reset_datapath ^ reset_datapath ^ expected_reset_datapath) &&
                expected_writeEn === (expected_writeEn ^ writeEn ^ expected_writeEn)) begin
                $display("PASS");
                $display("  Outputs: color=%h, enable=%b, reset_datapath=%b, writeEn=%b",
                         color, enable, reset_datapath, writeEn);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: color=%h, enable=%b, reset_datapath=%b, writeEn=%b",
                         expected_color, expected_enable, expected_reset_datapath, expected_writeEn);
                $display("  Got:      color=%h, enable=%b, reset_datapath=%b, writeEn=%b",
                         color, enable, reset_datapath, writeEn);
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
        $dumpvars(0,clear, clk, enable_unit, reset_n, color, enable, reset_datapath, writeEn);
    end

endmodule
