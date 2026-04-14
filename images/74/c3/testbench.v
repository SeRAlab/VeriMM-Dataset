`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clear;
    reg clk;
    reg preset;
    reg [9:0] preset_value;
    wire [9:0] count;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clear(clear),
        .clk(clk),
        .preset(preset),
        .preset_value(preset_value),
        .count(count)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            clear = 1;
            preset = 0;
            preset_value = 0;
            @(posedge clk);
            #1;
            clear = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("Running testcase001: Clear check...");
            reset_dut();

            #1;


            check_outputs(10'd0);
        end
        endtask

    task testcase002;

        begin
            $display("Running testcase002: Preset check...");
            reset_dut();
            preset = 1;
            preset_value = 10'h1AA;
            @(posedge clk);
            #1;
            preset = 0;
            #1;

            check_outputs(10'h1AA);
        end
        endtask

    task testcase003;

        begin
            $display("Running testcase003: Down count decrement check...");
            reset_dut();

            preset = 1;
            preset_value = 10'd10;
            @(posedge clk);
            #1;
            preset = 0;

            repeat(4) @(posedge clk);
            #1;
            #1;

            check_outputs(10'd6);
        end
        endtask

    task testcase004;

        begin
            $display("Running testcase004: Underflow (0 to 1023) check...");
            reset_dut();


            @(posedge clk);
            #1;
            #1;

            check_outputs(10'h3FF);
        end
        endtask

    task testcase005;

        begin
            $display("Running testcase005: Priority (Clear > Preset) check...");
            reset_dut();
            clear = 1;
            preset = 1;
            preset_value = 10'h3FF;
            @(posedge clk);
            #1;
            clear = 0;
            preset = 0;
            #1;

            check_outputs(10'd0);
        end
        endtask

    task testcase006;

        begin
            $display("Running testcase006: Multiple steps and wrap check...");
            reset_dut();
            preset = 1;
            preset_value = 10'd2;
            @(posedge clk);
            #1;
            preset = 0;

            repeat(5) @(posedge clk);
            #1;
            #1;

            check_outputs(10'd1021);
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
        input [9:0] expected_count;
        begin
            if (expected_count === (expected_count ^ count ^ expected_count)) begin
                $display("PASS");
                $display("  Outputs: count=%h",
                         count);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: count=%h",
                         expected_count);
                $display("  Got:      count=%h",
                         count);
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
        $dumpvars(0,clear, clk, preset, preset_value, count);
    end

endmodule
