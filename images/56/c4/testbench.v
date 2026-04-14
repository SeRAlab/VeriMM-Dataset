`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg blnk_in;
    reg clk;
    reg hsync_in;
    reg [23:0] rgb_in;
    reg rst;
    reg vsync_in;
    wire blnk_out;
    wire hsync_out;
    wire [23:0] rgb_out;
    wire vsync_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .blnk_in(blnk_in),
        .clk(clk),
        .hsync_in(hsync_in),
        .rgb_in(rgb_in),
        .rst(rst),
        .vsync_in(vsync_in),
        .blnk_out(blnk_out),
        .hsync_out(hsync_out),
        .rgb_out(rgb_out),
        .vsync_out(vsync_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            hsync_in = 0;
            vsync_in = 0;
            blnk_in = 0;
            rgb_in = 24'h0;
            @(posedge clk);
            #1;
            rst = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            hsync_in = 1;
            vsync_in = 0;
            blnk_in = 0;
            rgb_in = 24'hABCDEF;
            @(posedge clk);
            #2;
            #1;

            check_outputs(0, 1, 24'hABCDEF, 0);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            hsync_in = 0;
            vsync_in = 1;
            blnk_in = 1;
            rgb_in = 24'h123456;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1, 0, 24'h123456, 1);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            hsync_in = 1;
            vsync_in = 1;
            blnk_in = 1;
            rgb_in = 24'hFFFFFF;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1, 1, 24'hFFFFFF, 1);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            hsync_in = 0;
            vsync_in = 0;
            blnk_in = 0;
            rgb_in = 24'h000000;
            @(posedge clk);
            #2;
            #1;

            check_outputs(0, 0, 24'h000000, 0);
        end
        endtask

    task testcase005;

        begin

            hsync_in = 1;
            vsync_in = 1;
            blnk_in = 1;
            rgb_in = 24'hFFFFFF;
            rst = 1;
            @(posedge clk);
            #2;

            #1;


            check_outputs(0, 0, 24'h0, 0);
            rst = 0;
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
        input expected_blnk_out;
        input expected_hsync_out;
        input [23:0] expected_rgb_out;
        input expected_vsync_out;
        begin
            if (expected_blnk_out === (expected_blnk_out ^ blnk_out ^ expected_blnk_out) &&
                expected_hsync_out === (expected_hsync_out ^ hsync_out ^ expected_hsync_out) &&
                expected_rgb_out === (expected_rgb_out ^ rgb_out ^ expected_rgb_out) &&
                expected_vsync_out === (expected_vsync_out ^ vsync_out ^ expected_vsync_out)) begin
                $display("PASS");
                $display("  Outputs: blnk_out=%b, hsync_out=%b, rgb_out=%h, vsync_out=%b",
                         blnk_out, hsync_out, rgb_out, vsync_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: blnk_out=%b, hsync_out=%b, rgb_out=%h, vsync_out=%b",
                         expected_blnk_out, expected_hsync_out, expected_rgb_out, expected_vsync_out);
                $display("  Got:      blnk_out=%b, hsync_out=%b, rgb_out=%h, vsync_out=%b",
                         blnk_out, hsync_out, rgb_out, vsync_out);
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
        $dumpvars(0,blnk_in, clk, hsync_in, rgb_in, rst, vsync_in, blnk_out, hsync_out, rgb_out, vsync_out);
    end

endmodule
