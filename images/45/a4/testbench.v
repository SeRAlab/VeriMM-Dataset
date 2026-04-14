`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk_p;
    reg rst;
    wire hsync;
    wire newfield;
    wire newline;
    wire ve;
    wire vsync;
    wire [9:0] x;
    wire [9:0] y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk_p(clk_p),
        .rst(rst),
        .hsync(hsync),
        .newfield(newfield),
        .newline(newline),
        .ve(ve),
        .vsync(vsync),
        .x(x),
        .y(y)
    );

    // Clock generation (10ns period)
    initial begin
        clk_p = 0;
        forever #5 clk_p = ~clk_p;
    end

        task reset_dut;

    begin
        rst = 1;
        repeat(2) @(posedge clk_p);
        #1 rst = 0;
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        reset_dut();
        @(posedge clk_p);
        #1;

        #1;


        check_outputs(1'b1, 1'b0, 1'b0, 1'b1, 1'b1, 10'd0, 10'd0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        reset_dut();
        repeat(101) @(posedge clk_p);
        #1;

        #1;


        check_outputs(1'b1, 1'b0, 1'b0, 1'b1, 1'b1, 10'd100, 10'd0);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        reset_dut();
        repeat(641) @(posedge clk_p);
        #1;

        #1;


        check_outputs(1'b1, 1'b0, 1'b0, 1'b0, 1'b1, 10'd640, 10'd0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        reset_dut();
        repeat(657) @(posedge clk_p);
        #1;

        #1;


        check_outputs(1'b0, 1'b0, 1'b0, 1'b0, 1'b1, 10'd656, 10'd0);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        reset_dut();
        repeat(800) @(posedge clk_p);
        #1;

        #1;


        check_outputs(1'b1, 1'b0, 1'b1, 1'b0, 1'b1, 10'd799, 10'd0);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        reset_dut();
        repeat(801) @(posedge clk_p);
        #1;
        #1;

        check_outputs(1'b1, 1'b0, 1'b0, 1'b1, 1'b1, 10'd0, 10'd1);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        reset_dut();
        repeat(800 * 480 + 1) @(posedge clk_p);
        #1;

        #1;


        check_outputs(1'b1, 1'b0, 1'b0, 1'b0, 1'b1, 10'd0, 10'd480);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        reset_dut();
        repeat(800 * 490 + 1) @(posedge clk_p);
        #1;

        #1;


        check_outputs(1'b1, 1'b0, 1'b0, 1'b0, 1'b0, 10'd0, 10'd490);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        reset_dut();
        repeat(800 * 525) @(posedge clk_p);
        #1;
        #1;

        check_outputs(1'b1, 1'b1, 1'b1, 1'b0, 1'b1, 10'd799, 10'd524);
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
        input expected_newfield;
        input expected_newline;
        input expected_ve;
        input expected_vsync;
        input [9:0] expected_x;
        input [9:0] expected_y;
        begin
            if (expected_hsync === (expected_hsync ^ hsync ^ expected_hsync) &&
                expected_newfield === (expected_newfield ^ newfield ^ expected_newfield) &&
                expected_newline === (expected_newline ^ newline ^ expected_newline) &&
                expected_ve === (expected_ve ^ ve ^ expected_ve) &&
                expected_vsync === (expected_vsync ^ vsync ^ expected_vsync) &&
                expected_x === (expected_x ^ x ^ expected_x) &&
                expected_y === (expected_y ^ y ^ expected_y)) begin
                $display("PASS");
                $display("  Outputs: hsync=%b, newfield=%b, newline=%b, ve=%b, vsync=%b, x=%h, y=%h",
                         hsync, newfield, newline, ve, vsync, x, y);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: hsync=%b, newfield=%b, newline=%b, ve=%b, vsync=%b, x=%h, y=%h",
                         expected_hsync, expected_newfield, expected_newline, expected_ve, expected_vsync, expected_x, expected_y);
                $display("  Got:      hsync=%b, newfield=%b, newline=%b, ve=%b, vsync=%b, x=%h, y=%h",
                         hsync, newfield, newline, ve, vsync, x, y);
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
        $dumpvars(0,clk_p, rst, hsync, newfield, newline, ve, vsync, x, y);
    end

endmodule
