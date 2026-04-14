`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg pixel_clock;
    reg reset;
    wire hsync;
    wire [9:0] line_count;
    wire [9:0] pixel_count;
    wire vsync;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .pixel_clock(pixel_clock),
        .reset(reset),
        .hsync(hsync),
        .line_count(line_count),
        .pixel_count(pixel_count),
        .vsync(vsync)
    );

    // Clock generation (10ns period)
    initial begin
        pixel_clock = 0;
        forever #5 pixel_clock = ~pixel_clock;
    end

        task reset_dut;

        begin
            reset = 1;
            repeat(2) @(posedge pixel_clock);
            #1;
            reset = 0;
            @(posedge pixel_clock);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Reset State", test_num);
            reset_dut();

            #1;


            check_outputs(1'b1, 10'd0, 10'd0, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Visible Area Boundary", test_num);
            reset_dut();
            repeat(640) @(posedge pixel_clock);
            #1;
            #1;

            check_outputs(1'b1, 10'd0, 10'd640, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Horizontal Sync Start", test_num);
            reset_dut();
            repeat(656) @(posedge pixel_clock);
            #1;
            #1;

            check_outputs(1'b0, 10'd0, 10'd656, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Horizontal Sync End", test_num);
            reset_dut();
            repeat(752) @(posedge pixel_clock);
            #1;
            #1;

            check_outputs(1'b1, 10'd0, 10'd752, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Line Wrap-around", test_num);
            reset_dut();
            repeat(800) @(posedge pixel_clock);
            #1;
            #1;

            check_outputs(1'b1, 10'd1, 10'd0, 1'b1);
        end
        endtask

    task testcase006;

        integer i;
        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Vertical Sync Start", test_num);
            reset_dut();

            repeat(490 * 800) @(posedge pixel_clock);
            #1;
            #1;

            check_outputs(1'b1, 10'd490, 10'd0, 1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Vertical Sync End", test_num);
            reset_dut();
            repeat(492 * 800) @(posedge pixel_clock);
            #1;
            #1;

            check_outputs(1'b1, 10'd492, 10'd0, 1'b1);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Full Frame Wrap-around", test_num);
            reset_dut();
            repeat(525 * 800) @(posedge pixel_clock);
            #1;
            #1;

            check_outputs(1'b1, 10'd0, 10'd0, 1'b1);
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
        input [9:0] expected_line_count;
        input [9:0] expected_pixel_count;
        input expected_vsync;
        begin
            if (expected_hsync === (expected_hsync ^ hsync ^ expected_hsync) &&
                expected_line_count === (expected_line_count ^ line_count ^ expected_line_count) &&
                expected_pixel_count === (expected_pixel_count ^ pixel_count ^ expected_pixel_count) &&
                expected_vsync === (expected_vsync ^ vsync ^ expected_vsync)) begin
                $display("PASS");
                $display("  Outputs: hsync=%b, line_count=%h, pixel_count=%h, vsync=%b",
                         hsync, line_count, pixel_count, vsync);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: hsync=%b, line_count=%h, pixel_count=%h, vsync=%b",
                         expected_hsync, expected_line_count, expected_pixel_count, expected_vsync);
                $display("  Got:      hsync=%b, line_count=%h, pixel_count=%h, vsync=%b",
                         hsync, line_count, pixel_count, vsync);
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
        $dumpvars(0,pixel_clock, reset, hsync, line_count, pixel_count, vsync);
    end

endmodule
