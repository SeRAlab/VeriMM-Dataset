`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [5:0] atm_paldata;
    reg atm_palwr;
    reg [3:0] border;
    reg clk;
    reg hblank;
    reg hpix;
    reg [3:0] pixels;
    reg vblank;
    reg vpix;
    wire [5:0] color;
    wire [5:0] palcolor;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .atm_paldata(atm_paldata),
        .atm_palwr(atm_palwr),
        .border(border),
        .clk(clk),
        .hblank(hblank),
        .hpix(hpix),
        .pixels(pixels),
        .vblank(vblank),
        .vpix(vpix),
        .color(color),
        .palcolor(palcolor)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        atm_paldata = 0;
        atm_palwr = 0;
        border = 0;
        hblank = 0;
        hpix = 0;
        pixels = 0;
        vblank = 0;
        vpix = 0;
        repeat(2) @(posedge clk);
        #1;
    end
        endtask
    task testcase001;

    begin
        reset_dut();
        test_num = 1;
        $display("Testcase %0d: Active Pixel Selection and Palette Write", test_num);


        pixels = 4'h5;
        atm_paldata = 6'h2A;
        atm_palwr = 1;
        @(posedge clk);
        #1;
        atm_palwr = 0;


        hpix = 1; vpix = 1;
        hblank = 0; vblank = 0;
        pixels = 4'h5;
        @(posedge clk);
        #1;
        #1;

        check_outputs(6'h2A, 6'h2A);
    end
        endtask

    task testcase002;

    begin
        reset_dut();
        test_num = 2;
        $display("Testcase %0d: Border Color Selection", test_num);


        border = 4'hA;
        atm_paldata = 6'h15;
        atm_palwr = 1;
        @(posedge clk);
        #1;
        atm_palwr = 0;


        hpix = 0; vpix = 1;
        hblank = 0; vblank = 0;
        border = 4'hA;
        @(posedge clk);
        #1;
        #1;

        check_outputs(6'h15, 6'h15);
    end
        endtask

    task testcase003;

    begin
        reset_dut();
        test_num = 3;
        $display("Testcase %0d: Horizontal Blanking Effect", test_num);


        pixels = 4'h2;
        atm_paldata = 6'h3F;
        atm_palwr = 1;
        @(posedge clk);
        #1;
        atm_palwr = 0;


        hpix = 1; vpix = 1;
        hblank = 1; vblank = 0;
        pixels = 4'h2;
        @(posedge clk);
        #1;

        #1;


        check_outputs(6'h00, 6'h3F);
    end
        endtask

    task testcase004;

    begin
        reset_dut();
        test_num = 4;
        $display("Testcase %0d: Vertical Blanking Effect", test_num);


        pixels = 4'h8;
        atm_paldata = 6'h07;
        atm_palwr = 1;
        @(posedge clk);
        #1;
        atm_palwr = 0;


        hpix = 1; vpix = 1;
        hblank = 0; vblank = 1;
        pixels = 4'h8;
        @(posedge clk);
        #1;
        #1;

        check_outputs(6'h00, 6'h07);
    end
        endtask

    task testcase005;

    begin
        reset_dut();
        test_num = 5;
        $display("Testcase %0d: Dynamic Switching Pixels vs Border", test_num);


        atm_palwr = 1;
        pixels = 4'h1; atm_paldata = 6'h03; @(posedge clk); #1;
        pixels = 4'h2; atm_paldata = 6'h30; @(posedge clk); #1;
        atm_palwr = 0;


        hpix = 1; vpix = 1; hblank = 0; vblank = 0;
        pixels = 4'h1; border = 4'h2;
        @(posedge clk); #1;
        if (color !== 6'h03) fail_count++;


        hpix = 0; vpix = 1;
        @(posedge clk); #1;
        #1;

        check_outputs(6'h30, 6'h30);
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
        input [5:0] expected_color;
        input [5:0] expected_palcolor;
        begin
            if (expected_color === (expected_color ^ color ^ expected_color) &&
                expected_palcolor === (expected_palcolor ^ palcolor ^ expected_palcolor)) begin
                $display("PASS");
                $display("  Outputs: color=%h, palcolor=%h",
                         color, palcolor);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: color=%h, palcolor=%h",
                         expected_color, expected_palcolor);
                $display("  Got:      color=%h, palcolor=%h",
                         color, palcolor);
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
        $dumpvars(0,atm_paldata, atm_palwr, border, clk, hblank, hpix, pixels, vblank, vpix, color, palcolor);
    end

endmodule
