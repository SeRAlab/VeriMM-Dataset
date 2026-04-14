`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg clr;
    wire hsync;
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
        .clr(clr),
        .hsync(hsync),
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
            clr = 1;
            #20;
            clr = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %03d: Initial state after reset (0, 0)", test_num);
            reset_dut();

            #1;


            check_outputs(1'b1, 10'd0, 10'd0, 1'b1, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %03d: Middle of active video region", test_num);
            reset_dut();
            repeat(320) @(posedge clk);
            #1;

            #1;


            check_outputs(1'b1, 10'd320, 10'd0, 1'b1, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %03d: Horizontal Front Porch (x=650)", test_num);
            reset_dut();
            repeat(650) @(posedge clk);
            #1;

            #1;


            check_outputs(1'b1, 10'd650, 10'd0, 1'b0, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %03d: Horizontal Sync Pulse (x=700)", test_num);
            reset_dut();
            repeat(700) @(posedge clk);
            #1;

            #1;


            check_outputs(1'b0, 10'd700, 10'd0, 1'b0, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %03d: Horizontal Back Porch (x=780)", test_num);
            reset_dut();
            repeat(780) @(posedge clk);
            #1;

            #1;


            check_outputs(1'b1, 10'd780, 10'd0, 1'b0, 1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %03d: Line wrap-around (Start of Line 1)", test_num);
            reset_dut();
            repeat(800) @(posedge clk);
            #1;

            #1;


            check_outputs(1'b1, 10'd0, 10'd1, 1'b1, 1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %03d: Middle of active video Line 1", test_num);
            reset_dut();
            repeat(900) @(posedge clk);
            #1;

            #1;


            check_outputs(1'b1, 10'd100, 10'd1, 1'b1, 1'b1);
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
        input [9:0] expected_pixel_x;
        input [9:0] expected_pixel_y;
        input expected_video_on;
        input expected_vsync;
        begin
            if (expected_hsync === (expected_hsync ^ hsync ^ expected_hsync) &&
                expected_pixel_x === (expected_pixel_x ^ pixel_x ^ expected_pixel_x) &&
                expected_pixel_y === (expected_pixel_y ^ pixel_y ^ expected_pixel_y) &&
                expected_video_on === (expected_video_on ^ video_on ^ expected_video_on) &&
                expected_vsync === (expected_vsync ^ vsync ^ expected_vsync)) begin
                $display("PASS");
                $display("  Outputs: hsync=%b, pixel_x=%h, pixel_y=%h, video_on=%b, vsync=%b",
                         hsync, pixel_x, pixel_y, video_on, vsync);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: hsync=%b, pixel_x=%h, pixel_y=%h, video_on=%b, vsync=%b",
                         expected_hsync, expected_pixel_x, expected_pixel_y, expected_video_on, expected_vsync);
                $display("  Got:      hsync=%b, pixel_x=%h, pixel_y=%h, video_on=%b, vsync=%b",
                         hsync, pixel_x, pixel_y, video_on, vsync);
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
        $dumpvars(0,clk, clr, hsync, pixel_x, pixel_y, video_on, vsync);
    end

endmodule
