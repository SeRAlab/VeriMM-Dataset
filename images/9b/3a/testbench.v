`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [10:0] dst_hres;
    reg [10:0] dst_vres;
    reg [11:0] dx;
    reg [11:0] dy;
    reg pipe_ack_i;
    reg pipe_stb_i;
    reg sys_clk;
    reg sys_rst;
    reg [10:0] tex_hres;
    reg [10:0] tex_vres;
    reg [17:0] tx;
    reg [17:0] ty;
    wire busy;
    wire [10:0] dx_c;
    wire [10:0] dy_c;
    wire pipe_ack_o;
    wire pipe_stb_o;
    wire [16:0] tx_c;
    wire [16:0] ty_c;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .dst_hres(dst_hres),
        .dst_vres(dst_vres),
        .dx(dx),
        .dy(dy),
        .pipe_ack_i(pipe_ack_i),
        .pipe_stb_i(pipe_stb_i),
        .sys_clk(sys_clk),
        .sys_rst(sys_rst),
        .tex_hres(tex_hres),
        .tex_vres(tex_vres),
        .tx(tx),
        .ty(ty),
        .busy(busy),
        .dx_c(dx_c),
        .dy_c(dy_c),
        .pipe_ack_o(pipe_ack_o),
        .pipe_stb_o(pipe_stb_o),
        .tx_c(tx_c),
        .ty_c(ty_c)
    );

    // Clock generation (10ns period)
    initial begin
        sys_clk = 0;
        forever #5 sys_clk = ~sys_clk;
    end

        task reset_dut;

        begin
            sys_rst = 1;
            pipe_stb_i = 0;
            pipe_ack_i = 0;
            dx = 0;
            dy = 0;
            tx = 0;
            ty = 0;
            tex_hres = 0;
            tex_vres = 0;
            dst_hres = 0;
            dst_vres = 0;
            repeat (2) @(posedge sys_clk);
            sys_rst = 0;
            @(posedge sys_clk);
        end
        endtask
    task testcase001;

        begin
            $display("Testcase 001: Inputs within normal range");
            reset_dut();

            dst_hres = 11'd800;
            dst_vres = 11'd600;
            tex_hres = 11'd512;
            tex_vres = 11'd512;

            dx = 12'sd100;
            dy = 12'sd150;
            tx = 18'sd256;
            ty = 18'sd128;

            pipe_stb_i = 1;
            pipe_ack_i = 1;

            @(posedge sys_clk);
            pipe_stb_i = 0;


            while (!pipe_stb_o) @(posedge sys_clk);


            #1;



            check_outputs(busy, 11'd100, 11'd150, pipe_ack_o, 1, 17'd256, 17'd128);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Negative values clamping to zero");
            reset_dut();

            dst_hres = 11'd800;
            dst_vres = 11'd600;
            tex_hres = 11'd1024;
            tex_vres = 11'd1024;

            dx = -12'sd50;
            dy = -12'sd1;
            tx = -18'sd1000;
            ty = -18'sd1;

            pipe_stb_i = 1;
            pipe_ack_i = 1;

            @(posedge sys_clk);
            pipe_stb_i = 0;

            while (!pipe_stb_o) @(posedge sys_clk);


            #1;



            check_outputs(busy, 11'd0, 11'd0, pipe_ack_o, 1, 17'd0, 17'd0);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: High values clamping to res-1");
            reset_dut();

            dst_hres = 11'd800;
            dst_vres = 11'd600;
            tex_hres = 11'd1024;
            tex_vres = 11'd1024;

            dx = 12'sd1000;
            dy = 12'sd600;
            tx = 18'sd5000;
            ty = 18'sd1024;

            pipe_stb_i = 1;
            pipe_ack_i = 1;

            @(posedge sys_clk);
            pipe_stb_i = 0;

            while (!pipe_stb_o) @(posedge sys_clk);


            #1;



            check_outputs(busy, 11'd799, 11'd599, pipe_ack_o, 1, 17'd1023, 17'd1023);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Exact boundary check");
            reset_dut();

            dst_hres = 11'd100;
            dst_vres = 11'd100;
            tex_hres = 11'd200;
            tex_vres = 11'd200;

            dx = 12'sd0;
            dy = 12'sd99;
            tx = 18'sd0;
            ty = 18'sd199;

            pipe_stb_i = 1;
            pipe_ack_i = 1;

            @(posedge sys_clk);
            pipe_stb_i = 0;

            while (!pipe_stb_o) @(posedge sys_clk);


            #1;



            check_outputs(busy, 11'd0, 11'd99, pipe_ack_o, 1, 17'd0, 17'd199);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Extreme signed input values");
            reset_dut();

            dst_hres = 11'd2047;
            dst_vres = 11'd2047;
            tex_hres = 11'd2047;
            tex_vres = 11'd2047;

            dx = -12'sd2048;
            dy = 12'sd2047;
            tx = -18'sd131072;
            ty = 18'sd131071;

            pipe_stb_i = 1;
            pipe_ack_i = 1;

            @(posedge sys_clk);
            pipe_stb_i = 0;

            while (!pipe_stb_o) @(posedge sys_clk);


            #1;



            check_outputs(busy, 11'd0, 11'd2046, pipe_ack_o, 1, 17'd0, 17'd2046);
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
        input expected_busy;
        input [10:0] expected_dx_c;
        input [10:0] expected_dy_c;
        input expected_pipe_ack_o;
        input expected_pipe_stb_o;
        input [16:0] expected_tx_c;
        input [16:0] expected_ty_c;
        begin
            if (expected_busy === (expected_busy ^ busy ^ expected_busy) &&
                expected_dx_c === (expected_dx_c ^ dx_c ^ expected_dx_c) &&
                expected_dy_c === (expected_dy_c ^ dy_c ^ expected_dy_c) &&
                expected_pipe_ack_o === (expected_pipe_ack_o ^ pipe_ack_o ^ expected_pipe_ack_o) &&
                expected_pipe_stb_o === (expected_pipe_stb_o ^ pipe_stb_o ^ expected_pipe_stb_o) &&
                expected_tx_c === (expected_tx_c ^ tx_c ^ expected_tx_c) &&
                expected_ty_c === (expected_ty_c ^ ty_c ^ expected_ty_c)) begin
                $display("PASS");
                $display("  Outputs: busy=%b, dx_c=%h, dy_c=%h, pipe_ack_o=%b, pipe_stb_o=%b, tx_c=%h, ty_c=%h",
                         busy, dx_c, dy_c, pipe_ack_o, pipe_stb_o, tx_c, ty_c);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: busy=%b, dx_c=%h, dy_c=%h, pipe_ack_o=%b, pipe_stb_o=%b, tx_c=%h, ty_c=%h",
                         expected_busy, expected_dx_c, expected_dy_c, expected_pipe_ack_o, expected_pipe_stb_o, expected_tx_c, expected_ty_c);
                $display("  Got:      busy=%b, dx_c=%h, dy_c=%h, pipe_ack_o=%b, pipe_stb_o=%b, tx_c=%h, ty_c=%h",
                         busy, dx_c, dy_c, pipe_ack_o, pipe_stb_o, tx_c, ty_c);
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
        $dumpvars(0,dst_hres, dst_vres, dx, dy, pipe_ack_i, pipe_stb_i, sys_clk, sys_rst, tex_hres, tex_vres, tx, ty, busy, dx_c, dy_c, pipe_ack_o, pipe_stb_o, tx_c, ty_c);
    end

endmodule
