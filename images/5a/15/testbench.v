`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg vga_clock;
    wire at_display_area;
    wire [10:0] hcount;
    wire hsync;
    wire [9:0] vcount;
    wire vsync;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .vga_clock(vga_clock),
        .at_display_area(at_display_area),
        .hcount(hcount),
        .hsync(hsync),
        .vcount(vcount),
        .vsync(vsync)
    );

    // Clock generation (10ns period)
    initial begin
        vga_clock = 0;
        forever #5 vga_clock = ~vga_clock;
    end

        task reset_dut;

        begin
            force dut.hcount = 0;
            force dut.vcount = 0;
            @(posedge vga_clock);
            #1;
            release dut.hcount;
            release dut.vcount;
        end
        endtask
    task testcase001;

        begin
            $display("Testcase 001: Checking initial state (0,0)...");
            reset_dut();

            #1;


            check_outputs(1'b1, 11'd0, 1'b1, 10'd0, 1'b1);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Checking boundary of horizontal display area (1023,0)...");
            reset_dut();
            repeat(1023) @(posedge vga_clock);
            #1;
            #1;

            check_outputs(1'b1, 11'd1023, 1'b1, 10'd0, 1'b1);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Checking horizontal front porch start (1024,0)...");
            reset_dut();
            repeat(1024) @(posedge vga_clock);
            #1;
            #1;

            check_outputs(1'b0, 11'd1024, 1'b1, 10'd0, 1'b1);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Checking hsync pulse start (1048,0)...");
            reset_dut();
            repeat(1048) @(posedge vga_clock);
            #1;
            #1;

            check_outputs(1'b0, 11'd1048, 1'b0, 10'd0, 1'b1);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Checking end of line 0 (1343,0)...");
            reset_dut();
            repeat(1343) @(posedge vga_clock);
            #1;
            #1;

            check_outputs(1'b0, 11'd1343, 1'b1, 10'd0, 1'b1);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: Checking transition to line 1 (0,1)...");
            reset_dut();
            repeat(1344) @(posedge vga_clock);
            #1;
            #1;

            check_outputs(1'b1, 11'd0, 1'b1, 10'd1, 1'b1);
        end
        endtask

    task testcase007;

        begin
            $display("Testcase 007: Checking vertical display area boundary (0,767)...");
            reset_dut();

            repeat(767 * 1344) @(posedge vga_clock);
            #1;
            #1;

            check_outputs(1'b1, 11'd0, 1'b1, 10'd767, 1'b1);
        end
        endtask

    task testcase008;

        begin
            $display("Testcase 008: Checking vsync pulse start (0,771)...");
            reset_dut();

            repeat(771 * 1344) @(posedge vga_clock);
            #1;
            #1;

            check_outputs(1'b0, 11'd0, 1'b1, 10'd771, 1'b0);
        end
        endtask

    task testcase009;

        begin
            $display("Testcase 009: Checking full frame rollover (806 lines total)...");
            reset_dut();

            repeat(1344 * 806) @(posedge vga_clock);
            #1;
            #1;

            check_outputs(1'b1, 11'd0, 1'b1, 10'd0, 1'b1);
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
        input expected_at_display_area;
        input [10:0] expected_hcount;
        input expected_hsync;
        input [9:0] expected_vcount;
        input expected_vsync;
        begin
            if (expected_at_display_area === (expected_at_display_area ^ at_display_area ^ expected_at_display_area) &&
                expected_hcount === (expected_hcount ^ hcount ^ expected_hcount) &&
                expected_hsync === (expected_hsync ^ hsync ^ expected_hsync) &&
                expected_vcount === (expected_vcount ^ vcount ^ expected_vcount) &&
                expected_vsync === (expected_vsync ^ vsync ^ expected_vsync)) begin
                $display("PASS");
                $display("  Outputs: at_display_area=%b, hcount=%h, hsync=%b, vcount=%h, vsync=%b",
                         at_display_area, hcount, hsync, vcount, vsync);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: at_display_area=%b, hcount=%h, hsync=%b, vcount=%h, vsync=%b",
                         expected_at_display_area, expected_hcount, expected_hsync, expected_vcount, expected_vsync);
                $display("  Got:      at_display_area=%b, hcount=%h, hsync=%b, vcount=%h, vsync=%b",
                         at_display_area, hcount, hsync, vcount, vsync);
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
        $dumpvars(0,vga_clock, at_display_area, hcount, hsync, vcount, vsync);
    end

endmodule
