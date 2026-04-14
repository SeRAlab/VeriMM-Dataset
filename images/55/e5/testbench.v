`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg ce;
    reg clk;
    reg is_rendering;
    reg reset;
    wire at_last_cycle_group;
    wire [8:0] cycle;
    wire end_of_line;
    wire entering_vblank;
    wire exiting_vblank;
    wire is_in_vblank;
    wire is_pre_render;
    wire [8:0] scanline;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ce(ce),
        .clk(clk),
        .is_rendering(is_rendering),
        .reset(reset),
        .at_last_cycle_group(at_last_cycle_group),
        .cycle(cycle),
        .end_of_line(end_of_line),
        .entering_vblank(entering_vblank),
        .exiting_vblank(exiting_vblank),
        .is_in_vblank(is_in_vblank),
        .is_pre_render(is_pre_render),
        .scanline(scanline)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            ce = 0;
            is_rendering = 0;
            @(posedge clk);
            #1;
            reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();

            #1;


            check_outputs(0, 9'd0, 0, 0, 0, 0, 0, 9'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            ce = 1;
            repeat (10) @(posedge clk);
            #1;

            #1;


            check_outputs(0, 9'd10, 0, 0, 0, 0, 0, 9'd0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            ce = 1;

            repeat (340) @(posedge clk);
            #1;

            #1;


            check_outputs(1, 9'd340, 1, 0, 0, 0, 0, 9'd0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            ce = 1;
            repeat (341) @(posedge clk);
            #1;

            #1;


            check_outputs(0, 9'd0, 0, 0, 0, 0, 0, 9'd1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            ce = 1;
            repeat (5) @(posedge clk);
            ce = 0;
            repeat (10) @(posedge clk);
            #1;

            #1;


            check_outputs(0, 9'd5, 0, 0, 0, 0, 0, 9'd0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();
            ce = 1;

            repeat (241 * 341 + 1) @(posedge clk);
            #1;

            #1;


            check_outputs(0, 9'd1, 0, 1, 0, 1, 0, 9'd241);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            reset_dut();
            ce = 1;

            repeat (261 * 341 + 1) @(posedge clk);
            #1;

            #1;


            check_outputs(0, 9'd1, 0, 0, 1, 0, 1, 9'd261);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            reset_dut();
            ce = 1;

            repeat (262 * 341) @(posedge clk);
            #1;

            #1;


            check_outputs(0, 9'd0, 0, 0, 0, 0, 0, 9'd0);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            reset_dut();
            ce = 1;

            repeat (325) @(posedge clk);
            #1;
            #1;

            check_outputs(1, 9'd325, 0, 0, 0, 0, 0, 9'd0);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            reset_dut();
            ce = 1;
            is_rendering = 1;

            repeat (261 * 341 + 338) @(posedge clk);
            #1;

            #1;


            check_outputs(1, 9'd338, 0, 0, 0, 0, 1, 9'd261);
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
        testcase008();
        testcase009();
        testcase010();
        
        
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
        input expected_at_last_cycle_group;
        input [8:0] expected_cycle;
        input expected_end_of_line;
        input expected_entering_vblank;
        input expected_exiting_vblank;
        input expected_is_in_vblank;
        input expected_is_pre_render;
        input [8:0] expected_scanline;
        begin
            if (expected_at_last_cycle_group === (expected_at_last_cycle_group ^ at_last_cycle_group ^ expected_at_last_cycle_group) &&
                expected_cycle === (expected_cycle ^ cycle ^ expected_cycle) &&
                expected_end_of_line === (expected_end_of_line ^ end_of_line ^ expected_end_of_line) &&
                expected_entering_vblank === (expected_entering_vblank ^ entering_vblank ^ expected_entering_vblank) &&
                expected_exiting_vblank === (expected_exiting_vblank ^ exiting_vblank ^ expected_exiting_vblank) &&
                expected_is_in_vblank === (expected_is_in_vblank ^ is_in_vblank ^ expected_is_in_vblank) &&
                expected_is_pre_render === (expected_is_pre_render ^ is_pre_render ^ expected_is_pre_render) &&
                expected_scanline === (expected_scanline ^ scanline ^ expected_scanline)) begin
                $display("PASS");
                $display("  Outputs: at_last_cycle_group=%b, cycle=%h, end_of_line=%b, entering_vblank=%b, exiting_vblank=%b, is_in_vblank=%b, is_pre_render=%b, scanline=%h",
                         at_last_cycle_group, cycle, end_of_line, entering_vblank, exiting_vblank, is_in_vblank, is_pre_render, scanline);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: at_last_cycle_group=%b, cycle=%h, end_of_line=%b, entering_vblank=%b, exiting_vblank=%b, is_in_vblank=%b, is_pre_render=%b, scanline=%h",
                         expected_at_last_cycle_group, expected_cycle, expected_end_of_line, expected_entering_vblank, expected_exiting_vblank, expected_is_in_vblank, expected_is_pre_render, expected_scanline);
                $display("  Got:      at_last_cycle_group=%b, cycle=%h, end_of_line=%b, entering_vblank=%b, exiting_vblank=%b, is_in_vblank=%b, is_pre_render=%b, scanline=%h",
                         at_last_cycle_group, cycle, end_of_line, entering_vblank, exiting_vblank, is_in_vblank, is_pre_render, scanline);
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
        $dumpvars(0,ce, clk, is_rendering, reset, at_last_cycle_group, cycle, end_of_line, entering_vblank, exiting_vblank, is_in_vblank, is_pre_render, scanline);
    end

endmodule
