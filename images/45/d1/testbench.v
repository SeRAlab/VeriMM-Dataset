`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg reset;
    wire hsync;
    wire p_tick;
    wire [9:0] pixel_x;
    wire [9:0] pixel_y;
    wire video_on;
    wire vsync;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .reset(reset),
        .hsync(hsync),
        .p_tick(p_tick),
        .pixel_x(pixel_x),
        .pixel_y(pixel_y),
        .video_on(video_on),
        .vsync(vsync)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            repeat(5) @(posedge clk);
            reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task wait_p_ticks;

        input integer n;
        integer i;
        begin
            repeat(n) begin
                @(posedge clk);
                while (p_tick !== 1'b1) @(posedge clk);
            end
            #1;
        end
        endtask

    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            $display("Testcase %0d: Checking state immediately after reset", test_num);

            #1;


            check_outputs(1'b1, p_tick, 10'd0, 10'd0, 1'b1, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            $display("Testcase %0d: Checking increment after 100 pixel ticks", test_num);
            wait_p_ticks(100);
            #1;

            check_outputs(1'b1, p_tick, 10'd100, 10'd0, 1'b1, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            $display("Testcase %0d: Checking boundary at x=640 (video_on should drop)", test_num);
            wait_p_ticks(640);
            #1;

            check_outputs(1'b1, p_tick, 10'd640, 10'd0, 1'b0, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            $display("Testcase %0d: Checking H-Sync pulse (x=700 is inside sync pulse 656-751)", test_num);
            wait_p_ticks(700);
            #1;

            check_outputs(1'b0, p_tick, 10'd700, 10'd0, 1'b0, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            $display("Testcase %0d: Checking line increment after one full horizontal scan (800 ticks)", test_num);
            wait_p_ticks(800);
            #1;

            check_outputs(1'b1, p_tick, 10'd0, 10'd1, 1'b1, 1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();
            $display("Testcase %0d: Checking state at Line 10, x=200", test_num);
            wait_p_ticks(800 * 10 + 200);
            #1;

            check_outputs(1'b1, p_tick, 10'd200, 10'd10, 1'b1, 1'b1);
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
        input expected_hsync;
        input expected_p_tick;
        input [9:0] expected_pixel_x;
        input [9:0] expected_pixel_y;
        input expected_video_on;
        input expected_vsync;
        begin
            if (expected_hsync === (expected_hsync ^ hsync ^ expected_hsync) &&
                expected_p_tick === (expected_p_tick ^ p_tick ^ expected_p_tick) &&
                expected_pixel_x === (expected_pixel_x ^ pixel_x ^ expected_pixel_x) &&
                expected_pixel_y === (expected_pixel_y ^ pixel_y ^ expected_pixel_y) &&
                expected_video_on === (expected_video_on ^ video_on ^ expected_video_on) &&
                expected_vsync === (expected_vsync ^ vsync ^ expected_vsync)) begin
                $display("PASS");
                $display("  Outputs: hsync=%b, p_tick=%b, pixel_x=%h, pixel_y=%h, video_on=%b, vsync=%b",
                         hsync, p_tick, pixel_x, pixel_y, video_on, vsync);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: hsync=%b, p_tick=%b, pixel_x=%h, pixel_y=%h, video_on=%b, vsync=%b",
                         expected_hsync, expected_p_tick, expected_pixel_x, expected_pixel_y, expected_video_on, expected_vsync);
                $display("  Got:      hsync=%b, p_tick=%b, pixel_x=%h, pixel_y=%h, video_on=%b, vsync=%b",
                         hsync, p_tick, pixel_x, pixel_y, video_on, vsync);
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
        $dumpvars(0,clk, reset, hsync, p_tick, pixel_x, pixel_y, video_on, vsync);
    end

endmodule
