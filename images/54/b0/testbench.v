`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg clk_en;
    reg lfo_en;
    reg [2:0] lfo_freq;
    reg lfo_rst;
    reg rst;
    reg zero;
    wire [6:0] lfo_mod;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .clk_en(clk_en),
        .lfo_en(lfo_en),
        .lfo_freq(lfo_freq),
        .lfo_rst(lfo_rst),
        .rst(rst),
        .zero(zero),
        .lfo_mod(lfo_mod)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            lfo_rst = 1;
            clk_en = 0;
            lfo_en = 0;
            lfo_freq = 3'b000;
            zero = 0;
            @(posedge clk);
            #2;
            rst = 0;
            lfo_rst = 0;
            @(posedge clk);
            #2;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            rst = 1;
            lfo_en = 1;
            clk_en = 1;
            lfo_freq = 3'b000;
            repeat (5) @(posedge clk);
            #2;
            #1;

            check_outputs(7'd0);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            lfo_en = 1;
            clk_en = 1;
            lfo_rst = 1;
            repeat (5) @(posedge clk);
            #2;
            #1;

            check_outputs(7'd0);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            clk_en = 0;
            lfo_en = 1;
            lfo_freq = 3'b000;
            repeat (20) @(posedge clk);
            #2;
            #1;

            check_outputs(7'd0);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            clk_en = 1;
            lfo_en = 0;
            lfo_freq = 3'b000;
            repeat (20) @(posedge clk);
            #2;
            #1;

            check_outputs(7'd0);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            clk_en = 1;
            lfo_en = 1;
            lfo_freq = 3'b000;

            repeat (50) @(posedge clk);
            zero = 1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(7'd0);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            clk_en = 1;
            lfo_en = 1;
            lfo_freq = 3'b111;
            repeat (5) @(posedge clk);
            #2;
            #1;

            check_outputs(7'd0);
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
        input [6:0] expected_lfo_mod;
        begin
            if (expected_lfo_mod === (expected_lfo_mod ^ lfo_mod ^ expected_lfo_mod)) begin
                $display("PASS");
                $display("  Outputs: lfo_mod=%h",
                         lfo_mod);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: lfo_mod=%h",
                         expected_lfo_mod);
                $display("  Got:      lfo_mod=%h",
                         lfo_mod);
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
        $dumpvars(0,clk, clk_en, lfo_en, lfo_freq, lfo_rst, rst, zero, lfo_mod);
    end

endmodule
