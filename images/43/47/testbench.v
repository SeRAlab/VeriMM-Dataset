`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] color;
    wire [1:0] blue;
    wire [2:0] green;
    wire hsync;
    wire [2:0] red;
    wire vsync;
    wire [9:0] x;
    wire [9:0] y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .color(color),
        .blue(blue),
        .green(green),
        .hsync(hsync),
        .red(red),
        .vsync(vsync),
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
            $display("Resetting/Initializing simulation state...");
            color = 8'h00;


            #10;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Checking pixel (0,0) color mapping", test_num);
            reset_dut();
            color = 8'b111_000_11;
            #1;

            #1;


            check_outputs(2'h3, 3'h0, 1'b1, 3'h7, 1'b1, 10'd0, 10'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Checking pixel (100, 0)", test_num);
            reset_dut();
            color = 8'b010_110_01;

            repeat(100) @(posedge clk);
            #1;
            #1;

            check_outputs(2'h1, 3'h6, 1'b1, 3'h2, 1'b1, 10'd100, 10'd0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Checking H-Blanking area (x=645)", test_num);
            reset_dut();
            color = 8'hFF;
            repeat(645) @(posedge clk);
            #1;

            #1;


            check_outputs(2'h0, 3'h0, 1'b1, 3'h0, 1'b1, 10'd645, 10'd0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Checking H-Sync Pulse active low (x=700)", test_num);
            reset_dut();

            repeat(700) @(posedge clk);
            #1;

            #1;


            check_outputs(2'h0, 3'h0, 1'b0, 3'h0, 1'b1, 10'd700, 10'd0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Checking transition to second line (y=1)", test_num);
            reset_dut();
            color = 8'b000_111_00;

            repeat(800) @(posedge clk);
            #1;

            #1;


            check_outputs(2'h0, 3'h7, 1'b1, 3'h0, 1'b1, 10'd0, 10'd1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Checking V-Sync Pulse", test_num);
            reset_dut();


            repeat(800 * 490) @(posedge clk);
            #1;

            #1;


            check_outputs(2'h0, 3'h0, 1'b1, 3'h0, 1'b0, 10'd0, 10'd490);
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
        input [1:0] expected_blue;
        input [2:0] expected_green;
        input expected_hsync;
        input [2:0] expected_red;
        input expected_vsync;
        input [9:0] expected_x;
        input [9:0] expected_y;
        begin
            if (expected_blue === (expected_blue ^ blue ^ expected_blue) &&
                expected_green === (expected_green ^ green ^ expected_green) &&
                expected_hsync === (expected_hsync ^ hsync ^ expected_hsync) &&
                expected_red === (expected_red ^ red ^ expected_red) &&
                expected_vsync === (expected_vsync ^ vsync ^ expected_vsync) &&
                expected_x === (expected_x ^ x ^ expected_x) &&
                expected_y === (expected_y ^ y ^ expected_y)) begin
                $display("PASS");
                $display("  Outputs: blue=%h, green=%h, hsync=%b, red=%h, vsync=%b, x=%h, y=%h",
                         blue, green, hsync, red, vsync, x, y);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: blue=%h, green=%h, hsync=%b, red=%h, vsync=%b, x=%h, y=%h",
                         expected_blue, expected_green, expected_hsync, expected_red, expected_vsync, expected_x, expected_y);
                $display("  Got:      blue=%h, green=%h, hsync=%b, red=%h, vsync=%b, x=%h, y=%h",
                         blue, green, hsync, red, vsync, x, y);
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
        $dumpvars(0,clk, color, blue, green, hsync, red, vsync, x, y);
    end

endmodule
