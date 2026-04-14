`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg fb_enable;
    reg fb_reset;
    reg [11:0] line_count;
    reg [11:0] pixel_count;
    wire [11:0] x;
    wire [11:0] y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .fb_enable(fb_enable),
        .fb_reset(fb_reset),
        .line_count(line_count),
        .pixel_count(pixel_count),
        .x(x),
        .y(y)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            fb_reset = 1;
            fb_enable = 0;
            pixel_count = 0;
            line_count = 0;
            @(posedge clk);
            #1;
            fb_reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            #1;

            check_outputs(12'd0, 12'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            fb_enable = 1;
            pixel_count = 12'd640;
            line_count = 12'd480;
            @(posedge clk);
            #1;
            #1;

            check_outputs(12'd640, 12'd480);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();

            fb_enable = 1;
            pixel_count = 12'hAAA;
            line_count = 12'h555;
            @(posedge clk);
            #1;

            fb_enable = 0;
            pixel_count = 12'hFFF;
            line_count = 12'hFFF;
            @(posedge clk);
            #1;

            #1;


            check_outputs(12'hAAA, 12'h555);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            fb_enable = 1;
            pixel_count = 12'hFFF;
            line_count = 12'hFFF;
            @(posedge clk);
            #1;
            #1;

            check_outputs(12'hFFF, 12'hFFF);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            fb_enable = 1;
            pixel_count = 12'd10;
            line_count = 12'd20;
            @(posedge clk);
            #1;
            pixel_count = 12'd30;
            line_count = 12'd40;
            @(posedge clk);
            #1;
            #1;

            check_outputs(12'd30, 12'd40);
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
        input [11:0] expected_x;
        input [11:0] expected_y;
        begin
            if (expected_x === (expected_x ^ x ^ expected_x) &&
                expected_y === (expected_y ^ y ^ expected_y)) begin
                $display("PASS");
                $display("  Outputs: x=%h, y=%h",
                         x, y);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: x=%h, y=%h",
                         expected_x, expected_y);
                $display("  Got:      x=%h, y=%h",
                         x, y);
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
        $dumpvars(0,clk, fb_enable, fb_reset, line_count, pixel_count, x, y);
    end

endmodule
