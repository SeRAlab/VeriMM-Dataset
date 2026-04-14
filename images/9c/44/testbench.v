`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [8:0] color;
    reg enable;
    reg [9:0] hcount;
    reg [9:0] vcount;
    reg [9:0] x_loc;
    reg [9:0] y_loc;
    wire [8:0] pixel;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .color(color),
        .enable(enable),
        .hcount(hcount),
        .vcount(vcount),
        .x_loc(x_loc),
        .y_loc(y_loc),
        .pixel(pixel)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            enable = 0;
            color = 9'h000;
            hcount = 0;
            vcount = 0;
            x_loc = 0;
            y_loc = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            x_loc = 10'd50;
            y_loc = 10'd50;
            hcount = 10'd55;
            vcount = 10'd55;
            color = 9'h1FF;
            enable = 0;
            @(posedge clk);
            #1;
            $display("Test Case 001: Inside area, Enable LOW");
            #1;

            check_outputs(9'h000);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            x_loc = 10'd100;
            y_loc = 10'd100;
            hcount = 10'd100;
            vcount = 10'd100;
            color = 9'h0AA;
            enable = 1;
            @(posedge clk);
            #1;
            $display("Test Case 002: Top-left corner (100,100), Enable HIGH");
            #1;

            check_outputs(9'h0AA);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            x_loc = 10'd100;
            y_loc = 10'd100;
            hcount = 10'd115;
            vcount = 10'd115;
            color = 9'h155;
            enable = 1;
            @(posedge clk);
            #1;
            $display("Test Case 003: Bottom-right corner (115,115), Enable HIGH");
            #1;

            check_outputs(9'h155);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            x_loc = 10'd100;
            y_loc = 10'd100;
            hcount = 10'd116;
            vcount = 10'd110;
            color = 9'h1FF;
            enable = 1;
            @(posedge clk);
            #1;
            $display("Test Case 004: Outside right boundary (116,110)");
            #1;

            check_outputs(9'h000);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            x_loc = 10'd100;
            y_loc = 10'd100;
            hcount = 10'd105;
            vcount = 10'd99;
            color = 9'h1FF;
            enable = 1;
            @(posedge clk);
            #1;
            $display("Test Case 005: Outside top boundary (105,99)");
            #1;

            check_outputs(9'h000);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = 6;
            x_loc = 10'd300;
            y_loc = 10'd200;
            hcount = 10'd310;
            vcount = 10'd210;
            color = 9'h0F0;
            enable = 1;
            @(posedge clk);
            #1;
            $display("Test Case 006: Dynamic location (300,200), Color Green");
            #1;

            check_outputs(9'h0F0);
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            test_num = 7;
            x_loc = 10'd0;
            y_loc = 10'd0;
            hcount = 10'd8;
            vcount = 10'd8;
            color = 9'h123;
            enable = 1;
            @(posedge clk);
            #1;
            $display("Test Case 007: Origin location (0,0), middle pixel (8,8)");
            #1;

            check_outputs(9'h123);
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
        input [8:0] expected_pixel;
        begin
            if (expected_pixel === (expected_pixel ^ pixel ^ expected_pixel)) begin
                $display("PASS");
                $display("  Outputs: pixel=%h",
                         pixel);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: pixel=%h",
                         expected_pixel);
                $display("  Got:      pixel=%h",
                         pixel);
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
        $dumpvars(0,clk, color, enable, hcount, vcount, x_loc, y_loc, pixel);
    end

endmodule
