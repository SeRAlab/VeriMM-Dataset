`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg enable;
    reg [31:0] fb_addr;
    reg [10:0] hcount;
    reg [31:0] sram_data;
    reg sram_rdy;
    reg [10:0] vcount;
    wire [7:0] rgb;
    wire [31:0] sram_addr;
    wire sram_read;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .enable(enable),
        .fb_addr(fb_addr),
        .hcount(hcount),
        .sram_data(sram_data),
        .sram_rdy(sram_rdy),
        .vcount(vcount),
        .rgb(rgb),
        .sram_addr(sram_addr),
        .sram_read(sram_read)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            enable = 0;
            fb_addr = 0;
            hcount = 0;
            vcount = 0;
            sram_data = 0;
            sram_rdy = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("Testcase 001: System Disabled");
            reset_dut();
            enable = 0;
            fb_addr = 32'h0040_0000;
            hcount = 11'd100;
            vcount = 11'd50;
            @(posedge clk);
            #1;

            #1;


            check_outputs(8'h00, 32'h0000_0000, 1'b0);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Origin Address Calculation (0,0)");
            reset_dut();
            enable = 1;
            fb_addr = 32'h0010_0000;
            hcount = 11'd0;
            vcount = 11'd0;
            @(posedge clk);
            #1;

            #1;


            check_outputs(8'h00, 32'h0010_0000, 1'b1);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Mid-Line Address Calculation (320,0)");
            reset_dut();
            enable = 1;
            fb_addr = 32'h0000_0000;
            hcount = 11'd320;
            vcount = 11'd0;
            @(posedge clk);
            #1;

            #1;


            check_outputs(8'h00, 32'h0000_0140, 1'b1);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Multi-Line Address Calculation (10,5)");
            reset_dut();
            enable = 1;
            fb_addr = 32'h0000_1000;
            hcount = 11'd10;
            vcount = 11'd5;
            @(posedge clk);
            #1;

            #1;


            check_outputs(8'h00, 32'h0000_1C8A, 1'b1);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Data Path Verification");
            reset_dut();
            enable = 1;
            fb_addr = 32'h0;
            hcount = 0;
            vcount = 0;
            sram_rdy = 1;
            sram_data = 32'hAABBCCDD;
            @(posedge clk);
            #1;

            #1;


            check_outputs(8'hDD, 32'h0000_0000, 1'b1);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: Max Bounds Address Calculation (639, 479)");
            reset_dut();
            enable = 1;
            fb_addr = 32'h0;
            hcount = 11'd639;
            vcount = 11'd479;
            @(posedge clk);
            #1;

            #1;


            check_outputs(8'h00, 32'h0004_AFFF, 1'b1);
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
        input [7:0] expected_rgb;
        input [31:0] expected_sram_addr;
        input expected_sram_read;
        begin
            if (expected_rgb === (expected_rgb ^ rgb ^ expected_rgb) &&
                expected_sram_addr === (expected_sram_addr ^ sram_addr ^ expected_sram_addr) &&
                expected_sram_read === (expected_sram_read ^ sram_read ^ expected_sram_read)) begin
                $display("PASS");
                $display("  Outputs: rgb=%h, sram_addr=%h, sram_read=%b",
                         rgb, sram_addr, sram_read);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: rgb=%h, sram_addr=%h, sram_read=%b",
                         expected_rgb, expected_sram_addr, expected_sram_read);
                $display("  Got:      rgb=%h, sram_addr=%h, sram_read=%b",
                         rgb, sram_addr, sram_read);
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
        $dumpvars(0,clk, enable, fb_addr, hcount, sram_data, sram_rdy, vcount, rgb, sram_addr, sram_read);
    end

endmodule
