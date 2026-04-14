`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [17:0] ax;
    reg [17:0] ay;
    reg [17:0] bx;
    reg [17:0] by;
    reg [17:0] cx;
    reg [17:0] cy;
    reg [11:0] drx;
    reg [11:0] dry;
    reg [17:0] dx;
    reg [17:0] dy;
    reg pipe_ack_i;
    reg pipe_stb_i;
    reg sys_clk;
    reg sys_rst;
    wire [17:0] ax_f;
    wire [17:0] ay_f;
    wire busy;
    wire [17:0] bx_f;
    wire [17:0] by_f;
    wire [16:0] diff_cx;
    wire diff_cx_positive;
    wire [16:0] diff_cy;
    wire diff_cy_positive;
    wire [16:0] diff_dx;
    wire diff_dx_positive;
    wire [16:0] diff_dy;
    wire diff_dy_positive;
    wire [11:0] drx_f;
    wire [11:0] dry_f;
    wire pipe_ack_o;
    wire pipe_stb_o;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ax(ax),
        .ay(ay),
        .bx(bx),
        .by(by),
        .cx(cx),
        .cy(cy),
        .drx(drx),
        .dry(dry),
        .dx(dx),
        .dy(dy),
        .pipe_ack_i(pipe_ack_i),
        .pipe_stb_i(pipe_stb_i),
        .sys_clk(sys_clk),
        .sys_rst(sys_rst),
        .ax_f(ax_f),
        .ay_f(ay_f),
        .busy(busy),
        .bx_f(bx_f),
        .by_f(by_f),
        .diff_cx(diff_cx),
        .diff_cx_positive(diff_cx_positive),
        .diff_cy(diff_cy),
        .diff_cy_positive(diff_cy_positive),
        .diff_dx(diff_dx),
        .diff_dx_positive(diff_dx_positive),
        .diff_dy(diff_dy),
        .diff_dy_positive(diff_dy_positive),
        .drx_f(drx_f),
        .dry_f(dry_f),
        .pipe_ack_o(pipe_ack_o),
        .pipe_stb_o(pipe_stb_o)
    );

    // Clock generation (10ns period)
    initial begin
        sys_clk = 0;
        forever #5 sys_clk = ~sys_clk;
    end

        task reset_dut;

        begin
            sys_rst = 1;
            ax = 0; ay = 0; bx = 0; by = 0;
            cx = 0; cy = 0; dx = 0; dy = 0;
            drx = 0; dry = 0;
            pipe_stb_i = 0;
            pipe_ack_i = 0;
            repeat(5) @(posedge sys_clk);
            sys_rst = 0;
            repeat(2) @(posedge sys_clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            reset_dut();
            ax = 18'sh0000A; ay = 18'sh0000B; bx = 18'sh0000C; by = 18'sh0000D;
            cx = 18'sh00100; cy = 18'sh00200; dx = 18'sh00300; dy = 18'sh00400;
            drx = 12'sh001; dry = 12'sh002;

            @(posedge sys_clk);
            pipe_stb_i = 1;
            wait(pipe_ack_o);
            @(posedge sys_clk);
            pipe_stb_i = 0;

            wait(pipe_stb_o);
            pipe_ack_i = 1;
            #1;
            #1;

            check_outputs(18'sh0000A, 18'sh0000B, 1'bx, 18'sh0000C, 18'sh0000D, 17'h00100, 1'b1, 17'h00200, 1'b1, 17'h00300, 1'b1, 17'h00400, 1'b1, 12'sh001, 12'sh002, 1'bx, 1'b1);
            @(posedge sys_clk);
            pipe_ack_i = 0;
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            reset_dut();
            ax = 18'sh0; ay = 18'sh0; bx = 18'sh0; by = 18'sh0;
            cx = -18'sh00064;
            cy = -18'sh000C8;
            dx = -18'sh0012C;
            dy = -18'sh00190;
            drx = 0; dry = 0;

            @(posedge sys_clk);
            pipe_stb_i = 1;
            wait(pipe_ack_o);
            @(posedge sys_clk);
            pipe_stb_i = 0;

            wait(pipe_stb_o);
            pipe_ack_i = 1;
            #1;
            #1;

            check_outputs(18'sh0, 18'sh0, 1'bx, 18'sh0, 18'sh0, 17'h00064, 1'b0, 17'h000C8, 1'b0, 17'h0012C, 1'b0, 17'h00190, 1'b0, 12'sh0, 12'sh0, 1'bx, 1'b1);
            @(posedge sys_clk);
            pipe_ack_i = 0;
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            reset_dut();
            ax = 18'sh1FFFF; ay = -18'sh20000;
            cx = 18'sh1FFFF;
            cy = -18'sh1FFFF;
            dx = 18'sh00000;
            dy = -18'sh00001;
            drx = 12'sh7FF; dry = -12'sh800;

            @(posedge sys_clk);
            pipe_stb_i = 1;
            wait(pipe_ack_o);
            @(posedge sys_clk);
            pipe_stb_i = 0;

            wait(pipe_stb_o);
            pipe_ack_i = 1;
            #1;

            #1;


            check_outputs(18'sh1FFFF, -18'sh20000, 1'bx, 18'sh0, 18'sh0, 17'h1FFFF, 1'b1, 17'h1FFFF, 1'b0, 17'h0, 1'b1, 17'h1, 1'b0, 12'sh7FF, -12'sh800, 1'bx, 1'b1);
            @(posedge sys_clk);
            pipe_ack_i = 0;
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            reset_dut();
            ax = 0; ay = 0; bx = 0; by = 0;
            cx = 0; cy = 0; dx = 0; dy = 0;
            drx = 0; dry = 0;

            @(posedge sys_clk);
            pipe_stb_i = 1;
            wait(pipe_ack_o);
            @(posedge sys_clk);
            pipe_stb_i = 0;

            wait(pipe_stb_o);
            pipe_ack_i = 1;
            #1;
            #1;

            check_outputs(0, 0, 1'bx, 0, 0, 17'h0, 1'b1, 17'h0, 1'b1, 17'h0, 1'b1, 17'h0, 1'b1, 0, 0, 1'bx, 1'b1);
            @(posedge sys_clk);
            pipe_ack_i = 0;
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
        input [17:0] expected_ax_f;
        input [17:0] expected_ay_f;
        input expected_busy;
        input [17:0] expected_bx_f;
        input [17:0] expected_by_f;
        input [16:0] expected_diff_cx;
        input expected_diff_cx_positive;
        input [16:0] expected_diff_cy;
        input expected_diff_cy_positive;
        input [16:0] expected_diff_dx;
        input expected_diff_dx_positive;
        input [16:0] expected_diff_dy;
        input expected_diff_dy_positive;
        input [11:0] expected_drx_f;
        input [11:0] expected_dry_f;
        input expected_pipe_ack_o;
        input expected_pipe_stb_o;
        begin
            if (expected_ax_f === (expected_ax_f ^ ax_f ^ expected_ax_f) &&
                expected_ay_f === (expected_ay_f ^ ay_f ^ expected_ay_f) &&
                expected_busy === (expected_busy ^ busy ^ expected_busy) &&
                expected_bx_f === (expected_bx_f ^ bx_f ^ expected_bx_f) &&
                expected_by_f === (expected_by_f ^ by_f ^ expected_by_f) &&
                expected_diff_cx === (expected_diff_cx ^ diff_cx ^ expected_diff_cx) &&
                expected_diff_cx_positive === (expected_diff_cx_positive ^ diff_cx_positive ^ expected_diff_cx_positive) &&
                expected_diff_cy === (expected_diff_cy ^ diff_cy ^ expected_diff_cy) &&
                expected_diff_cy_positive === (expected_diff_cy_positive ^ diff_cy_positive ^ expected_diff_cy_positive) &&
                expected_diff_dx === (expected_diff_dx ^ diff_dx ^ expected_diff_dx) &&
                expected_diff_dx_positive === (expected_diff_dx_positive ^ diff_dx_positive ^ expected_diff_dx_positive) &&
                expected_diff_dy === (expected_diff_dy ^ diff_dy ^ expected_diff_dy) &&
                expected_diff_dy_positive === (expected_diff_dy_positive ^ diff_dy_positive ^ expected_diff_dy_positive) &&
                expected_drx_f === (expected_drx_f ^ drx_f ^ expected_drx_f) &&
                expected_dry_f === (expected_dry_f ^ dry_f ^ expected_dry_f) &&
                expected_pipe_ack_o === (expected_pipe_ack_o ^ pipe_ack_o ^ expected_pipe_ack_o) &&
                expected_pipe_stb_o === (expected_pipe_stb_o ^ pipe_stb_o ^ expected_pipe_stb_o)) begin
                $display("PASS");
                $display("  Outputs: ax_f=%h, ay_f=%h, busy=%b, bx_f=%h, by_f=%h, diff_cx=%h, diff_cx_positive=%b, diff_cy=%h, diff_cy_positive=%b, diff_dx=%h, diff_dx_positive=%b, diff_dy=%h, diff_dy_positive=%b, drx_f=%h, dry_f=%h, pipe_ack_o=%b, pipe_stb_o=%b",
                         ax_f, ay_f, busy, bx_f, by_f, diff_cx, diff_cx_positive, diff_cy, diff_cy_positive, diff_dx, diff_dx_positive, diff_dy, diff_dy_positive, drx_f, dry_f, pipe_ack_o, pipe_stb_o);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ax_f=%h, ay_f=%h, busy=%b, bx_f=%h, by_f=%h, diff_cx=%h, diff_cx_positive=%b, diff_cy=%h, diff_cy_positive=%b, diff_dx=%h, diff_dx_positive=%b, diff_dy=%h, diff_dy_positive=%b, drx_f=%h, dry_f=%h, pipe_ack_o=%b, pipe_stb_o=%b",
                         expected_ax_f, expected_ay_f, expected_busy, expected_bx_f, expected_by_f, expected_diff_cx, expected_diff_cx_positive, expected_diff_cy, expected_diff_cy_positive, expected_diff_dx, expected_diff_dx_positive, expected_diff_dy, expected_diff_dy_positive, expected_drx_f, expected_dry_f, expected_pipe_ack_o, expected_pipe_stb_o);
                $display("  Got:      ax_f=%h, ay_f=%h, busy=%b, bx_f=%h, by_f=%h, diff_cx=%h, diff_cx_positive=%b, diff_cy=%h, diff_cy_positive=%b, diff_dx=%h, diff_dx_positive=%b, diff_dy=%h, diff_dy_positive=%b, drx_f=%h, dry_f=%h, pipe_ack_o=%b, pipe_stb_o=%b",
                         ax_f, ay_f, busy, bx_f, by_f, diff_cx, diff_cx_positive, diff_cy, diff_cy_positive, diff_dx, diff_dx_positive, diff_dy, diff_dy_positive, drx_f, dry_f, pipe_ack_o, pipe_stb_o);
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
        $dumpvars(0,ax, ay, bx, by, cx, cy, drx, dry, dx, dy, pipe_ack_i, pipe_stb_i, sys_clk, sys_rst, ax_f, ay_f, busy, bx_f, by_f, diff_cx, diff_cx_positive, diff_cy, diff_cy_positive, diff_dx, diff_dx_positive, diff_dy, diff_dy_positive, drx_f, dry_f, pipe_ack_o, pipe_stb_o);
    end

endmodule
