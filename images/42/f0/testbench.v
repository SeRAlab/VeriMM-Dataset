`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg rst;
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
        .rst(rst),
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
            rst = 1;
            #20;
            rst = 0;
            @(posedge clk);
        end
        endtask
    task wait_ticks;

        input integer n;
        integer i;
        begin
            repeat(n) begin
                @(posedge clk);
                while (p_tick !== 1'b1) @(posedge clk);
            end
        end
        endtask

    task testcase001;

        begin
            test_num = 1;
            reset_dut();


            #1;



            check_outputs(1'b1, 1'b0, 10'd0, 10'd0, 1'b1, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            wait_ticks(1);

            #1;


            check_outputs(1'b1, 1'b1, 10'd0, 10'd0, 1'b1, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            wait_ticks(640);
            #1;

            check_outputs(1'b1, 1'b1, 10'd639, 10'd0, 1'b1, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            wait_ticks(641);
            #1;

            check_outputs(1'b1, 1'b1, 10'd640, 10'd0, 1'b0, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            wait_ticks(657);
            #1;

            check_outputs(1'b0, 1'b1, 10'd656, 10'd0, 1'b0, 1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();
            wait_ticks(753);
            #1;

            check_outputs(1'b1, 1'b1, 10'd752, 10'd0, 1'b0, 1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            reset_dut();
            wait_ticks(801);
            #1;

            check_outputs(1'b1, 1'b1, 10'd0, 10'd1, 1'b1, 1'b1);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            reset_dut();

            wait_ticks(800 * 490 + 1);

            #1;


            check_outputs(1'b1, 1'b1, 10'd0, 10'd490, 1'b0, 1'b0);
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
        $dumpvars(0,clk, rst, hsync, p_tick, pixel_x, pixel_y, video_on, vsync);
    end

endmodule
