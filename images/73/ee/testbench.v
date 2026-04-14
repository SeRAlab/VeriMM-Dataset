`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [15:0] a;
    reg clk;
    reg [7:0] din;
    reg iorq_n;
    reg kbd_change_video_output;
    reg wr_n;
    reg [7:0] zxuno_addr;
    reg zxuno_regrd;
    reg zxuno_regwr;
    wire csync_option;
    wire [7:0] dout;
    wire [2:0] freq_option;
    wire oe_n;
    wire scanlines_enable;
    wire [1:0] turbo_enable;
    wire vga_enable;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .clk(clk),
        .din(din),
        .iorq_n(iorq_n),
        .kbd_change_video_output(kbd_change_video_output),
        .wr_n(wr_n),
        .zxuno_addr(zxuno_addr),
        .zxuno_regrd(zxuno_regrd),
        .zxuno_regwr(zxuno_regwr),
        .csync_option(csync_option),
        .dout(dout),
        .freq_option(freq_option),
        .oe_n(oe_n),
        .scanlines_enable(scanlines_enable),
        .turbo_enable(turbo_enable),
        .vga_enable(vga_enable)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            a = 16'h0000;
            din = 8'h00;
            iorq_n = 1'b1;
            wr_n = 1'b1;
            kbd_change_video_output = 1'b0;
            zxuno_addr = 8'h00;
            zxuno_regrd = 1'b0;
            zxuno_regwr = 1'b0;
            repeat(5) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();

            #1;


            check_outputs(1'b0, 8'hzz, 3'b000, 1'b1, 1'b0, 2'b00, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            zxuno_addr = 8'h0B;
            din = 8'h01;
            @(posedge clk);
            zxuno_regwr = 1'b1;
            @(posedge clk);
            zxuno_regwr = 1'b0;
            repeat(2) @(posedge clk);

            #1;


            check_outputs(1'b0, 8'hzz, 3'b000, 1'b1, 1'b0, 2'b00, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            zxuno_addr = 8'h0B;

            din = 8'b00011010;
            @(posedge clk);
            zxuno_regwr = 1'b1;
            @(posedge clk);
            zxuno_regwr = 1'b0;
            repeat(2) @(posedge clk);
            #1;

            check_outputs(1'b0, 8'hzz, 3'b011, 1'b1, 1'b1, 2'b00, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            zxuno_addr = 8'h0B;

            din = 8'b11000100;
            @(posedge clk);
            zxuno_regwr = 1'b1;
            @(posedge clk);
            zxuno_regwr = 1'b0;
            repeat(2) @(posedge clk);
            #1;

            check_outputs(1'b1, 8'hzz, 3'b000, 1'b1, 1'b0, 2'b11, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();

            kbd_change_video_output = 1'b1;
            @(posedge clk);
            kbd_change_video_output = 1'b0;
            repeat(2) @(posedge clk);

            #1;


            check_outputs(1'b0, 8'hzz, 3'b000, 1'b1, 1'b0, 2'b00, 1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();

            zxuno_addr = 8'h0B;
            din = 8'hA5;
            @(posedge clk);
            zxuno_regwr = 1'b1;
            @(posedge clk);
            zxuno_regwr = 1'b0;
            @(posedge clk);

            zxuno_regrd = 1'b1;
            repeat(2) @(posedge clk);

            #1;


            check_outputs(1'b1, 8'hA5, 3'b100, 1'b0, 1'b0, 2'b10, 1'b1);
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
        input expected_csync_option;
        input [7:0] expected_dout;
        input [2:0] expected_freq_option;
        input expected_oe_n;
        input expected_scanlines_enable;
        input [1:0] expected_turbo_enable;
        input expected_vga_enable;
        begin
            if (expected_csync_option === (expected_csync_option ^ csync_option ^ expected_csync_option) &&
                expected_dout === (expected_dout ^ dout ^ expected_dout) &&
                expected_freq_option === (expected_freq_option ^ freq_option ^ expected_freq_option) &&
                expected_oe_n === (expected_oe_n ^ oe_n ^ expected_oe_n) &&
                expected_scanlines_enable === (expected_scanlines_enable ^ scanlines_enable ^ expected_scanlines_enable) &&
                expected_turbo_enable === (expected_turbo_enable ^ turbo_enable ^ expected_turbo_enable) &&
                expected_vga_enable === (expected_vga_enable ^ vga_enable ^ expected_vga_enable)) begin
                $display("PASS");
                $display("  Outputs: csync_option=%b, dout=%h, freq_option=%h, oe_n=%b, scanlines_enable=%b, turbo_enable=%h, vga_enable=%b",
                         csync_option, dout, freq_option, oe_n, scanlines_enable, turbo_enable, vga_enable);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: csync_option=%b, dout=%h, freq_option=%h, oe_n=%b, scanlines_enable=%b, turbo_enable=%h, vga_enable=%b",
                         expected_csync_option, expected_dout, expected_freq_option, expected_oe_n, expected_scanlines_enable, expected_turbo_enable, expected_vga_enable);
                $display("  Got:      csync_option=%b, dout=%h, freq_option=%h, oe_n=%b, scanlines_enable=%b, turbo_enable=%h, vga_enable=%b",
                         csync_option, dout, freq_option, oe_n, scanlines_enable, turbo_enable, vga_enable);
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
        $dumpvars(0,a, clk, din, iorq_n, kbd_change_video_output, wr_n, zxuno_addr, zxuno_regrd, zxuno_regwr, csync_option, dout, freq_option, oe_n, scanlines_enable, turbo_enable, vga_enable);
    end

endmodule
