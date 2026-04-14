`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg blank;
    reg h_synch;
    reg pixel_clock;
    reg reset;
    reg v_synch;
    reg vga_blue_data;
    reg vga_green_data;
    reg vga_red_data;
    wire VGA_HSYNCH;
    wire VGA_OUT_BLUE;
    wire VGA_OUT_GREEN;
    wire VGA_OUT_RED;
    wire VGA_VSYNCH;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .blank(blank),
        .h_synch(h_synch),
        .pixel_clock(pixel_clock),
        .reset(reset),
        .v_synch(v_synch),
        .vga_blue_data(vga_blue_data),
        .vga_green_data(vga_green_data),
        .vga_red_data(vga_red_data),
        .VGA_HSYNCH(VGA_HSYNCH),
        .VGA_OUT_BLUE(VGA_OUT_BLUE),
        .VGA_OUT_GREEN(VGA_OUT_GREEN),
        .VGA_OUT_RED(VGA_OUT_RED),
        .VGA_VSYNCH(VGA_VSYNCH)
    );

    // Clock generation (10ns period)
    initial begin
        pixel_clock = 0;
        forever #5 pixel_clock = ~pixel_clock;
    end

        task reset_dut;

    begin
        reset = 1;
        blank = 0;
        h_synch = 0;
        v_synch = 0;
        vga_red_data = 0;
        vga_green_data = 0;
        vga_blue_data = 0;
        @(posedge pixel_clock);
        #1 reset = 0;
        @(posedge pixel_clock);
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %0d: Reset State Verification", test_num);
        reset_dut();

        #1;


        check_outputs(0, 0, 0, 0, 0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %0d: Normal Mode (Blank=0, RGB Data Pass-through)", test_num);
        reset_dut();
        blank = 0;
        h_synch = 1;
        v_synch = 1;
        vga_red_data = 1;
        vga_green_data = 0;
        vga_blue_data = 1;
        @(posedge pixel_clock);
        #2;

        #1;


        check_outputs(1, 1, 0, 1, 1);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %0d: Blanking Mode (Blank=1, RGB Data Forced Low)", test_num);
        reset_dut();
        blank = 1;
        h_synch = 1;
        v_synch = 1;
        vga_red_data = 1;
        vga_green_data = 1;
        vga_blue_data = 1;
        @(posedge pixel_clock);
        #2;

        #1;


        check_outputs(1, 0, 0, 0, 1);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %0d: H-Sync Signal Verification", test_num);
        reset_dut();
        blank = 0;
        h_synch = 0;
        v_synch = 1;
        vga_red_data = 0;
        vga_green_data = 1;
        vga_blue_data = 0;
        @(posedge pixel_clock);
        #2;
        #1;

        check_outputs(0, 0, 1, 0, 1);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %0d: V-Sync Signal Verification during Blanking", test_num);
        reset_dut();
        blank = 1;
        h_synch = 1;
        v_synch = 0;
        vga_red_data = 1;
        vga_green_data = 1;
        vga_blue_data = 1;
        @(posedge pixel_clock);
        #2;

        #1;


        check_outputs(1, 0, 0, 0, 0);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %0d: Alternating RGB Colors", test_num);
        reset_dut();
        blank = 0;
        h_synch = 1;
        v_synch = 1;
        vga_red_data = 0;
        vga_green_data = 1;
        vga_blue_data = 1;
        @(posedge pixel_clock);
        #2;
        #1;

        check_outputs(1, 1, 1, 0, 1);
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
        input expected_VGA_HSYNCH;
        input expected_VGA_OUT_BLUE;
        input expected_VGA_OUT_GREEN;
        input expected_VGA_OUT_RED;
        input expected_VGA_VSYNCH;
        begin
            if (expected_VGA_HSYNCH === (expected_VGA_HSYNCH ^ VGA_HSYNCH ^ expected_VGA_HSYNCH) &&
                expected_VGA_OUT_BLUE === (expected_VGA_OUT_BLUE ^ VGA_OUT_BLUE ^ expected_VGA_OUT_BLUE) &&
                expected_VGA_OUT_GREEN === (expected_VGA_OUT_GREEN ^ VGA_OUT_GREEN ^ expected_VGA_OUT_GREEN) &&
                expected_VGA_OUT_RED === (expected_VGA_OUT_RED ^ VGA_OUT_RED ^ expected_VGA_OUT_RED) &&
                expected_VGA_VSYNCH === (expected_VGA_VSYNCH ^ VGA_VSYNCH ^ expected_VGA_VSYNCH)) begin
                $display("PASS");
                $display("  Outputs: VGA_HSYNCH=%b, VGA_OUT_BLUE=%b, VGA_OUT_GREEN=%b, VGA_OUT_RED=%b, VGA_VSYNCH=%b",
                         VGA_HSYNCH, VGA_OUT_BLUE, VGA_OUT_GREEN, VGA_OUT_RED, VGA_VSYNCH);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: VGA_HSYNCH=%b, VGA_OUT_BLUE=%b, VGA_OUT_GREEN=%b, VGA_OUT_RED=%b, VGA_VSYNCH=%b",
                         expected_VGA_HSYNCH, expected_VGA_OUT_BLUE, expected_VGA_OUT_GREEN, expected_VGA_OUT_RED, expected_VGA_VSYNCH);
                $display("  Got:      VGA_HSYNCH=%b, VGA_OUT_BLUE=%b, VGA_OUT_GREEN=%b, VGA_OUT_RED=%b, VGA_VSYNCH=%b",
                         VGA_HSYNCH, VGA_OUT_BLUE, VGA_OUT_GREEN, VGA_OUT_RED, VGA_VSYNCH);
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
        $dumpvars(0,blank, h_synch, pixel_clock, reset, v_synch, vga_blue_data, vga_green_data, vga_red_data, VGA_HSYNCH, VGA_OUT_BLUE, VGA_OUT_GREEN, VGA_OUT_RED, VGA_VSYNCH);
    end

endmodule
