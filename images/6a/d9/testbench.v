`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [1:0] bluein;
    reg clk;
    reg [2:0] greenin;
    reg [2:0] redin;
    wire [1:0] blue;
    wire [2:0] green;
    wire [9:0] hc;
    wire hsync;
    wire [2:0] red;
    wire [9:0] vc;
    wire vsync;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .bluein(bluein),
        .clk(clk),
        .greenin(greenin),
        .redin(redin),
        .blue(blue),
        .green(green),
        .hc(hc),
        .hsync(hsync),
        .red(red),
        .vc(vc),
        .vsync(vsync)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            redin = 3'b000;
            greenin = 3'b000;
            bluein = 2'b00;
            repeat(5) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();

            @(posedge clk);
            #1;

            $display("Testcase 001: Initial Counter Increment");
            #1;

            check_outputs(2'b00, 3'b000, 10'd1, 1'b0, 3'b000, 10'd0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();

            while (hc < 10'd50) @(posedge clk);
            #1;
            $display("Testcase 002: H-Sync Active (hc=50)");

            #1;


            check_outputs(2'b00, 3'b000, 10'd50, 1'b0, 3'b000, 10'd0, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            redin = 3'b101;
            greenin = 3'b110;
            bluein = 2'b11;

            while (hc < 10'd200) @(posedge clk);
            while (vc < 10'd40) @(posedge clk);
            #1;
            $display("Testcase 003: Active Video Region Color Passthrough");

            #1;


            check_outputs(2'b11, 3'b110, hc, 1'b1, 3'b101, vc, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();

            while (hc < 10'd799) @(posedge clk);
            @(posedge clk);
            #1;
            $display("Testcase 004: Horizontal Wrap to Next Line");

            #1;


            check_outputs(2'b00, 3'b000, 10'd0, 1'b0, 3'b000, 10'd1, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();


            while (vc != 0) @(posedge clk);
            while (hc < 10'd500) @(posedge clk);
            #1;
            $display("Testcase 005: Vertical Sync Active, Horizontal Sync Inactive");

            #1;


            check_outputs(2'b00, 3'b000, 10'd500, 1'b1, 3'b000, 10'd0, 1'b0);
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
        input [1:0] expected_blue;
        input [2:0] expected_green;
        input [9:0] expected_hc;
        input expected_hsync;
        input [2:0] expected_red;
        input [9:0] expected_vc;
        input expected_vsync;
        begin
            if (expected_blue === (expected_blue ^ blue ^ expected_blue) &&
                expected_green === (expected_green ^ green ^ expected_green) &&
                expected_hc === (expected_hc ^ hc ^ expected_hc) &&
                expected_hsync === (expected_hsync ^ hsync ^ expected_hsync) &&
                expected_red === (expected_red ^ red ^ expected_red) &&
                expected_vc === (expected_vc ^ vc ^ expected_vc) &&
                expected_vsync === (expected_vsync ^ vsync ^ expected_vsync)) begin
                $display("PASS");
                $display("  Outputs: blue=%h, green=%h, hc=%h, hsync=%b, red=%h, vc=%h, vsync=%b",
                         blue, green, hc, hsync, red, vc, vsync);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: blue=%h, green=%h, hc=%h, hsync=%b, red=%h, vc=%h, vsync=%b",
                         expected_blue, expected_green, expected_hc, expected_hsync, expected_red, expected_vc, expected_vsync);
                $display("  Got:      blue=%h, green=%h, hc=%h, hsync=%b, red=%h, vc=%h, vsync=%b",
                         blue, green, hc, hsync, red, vc, vsync);
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
        $dumpvars(0,bluein, clk, greenin, redin, blue, green, hc, hsync, red, vc, vsync);
    end

endmodule
