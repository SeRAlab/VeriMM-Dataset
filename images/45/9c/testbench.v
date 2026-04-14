`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [18:0] adr_i;
    reg clk_i;
    reg cyc_i;
    reg [15:0] dat_i;
    reg reset_i;
    reg [1:0] sel_i;
    reg [15:0] sram_d_in;
    reg stb_i;
    reg we_i;
    wire _sram_ce;
    wire _sram_lb;
    wire _sram_oe;
    wire _sram_ub;
    wire _sram_we;
    wire ack_o;
    wire [15:0] dat_o;
    wire [18:0] sram_a;
    wire [15:0] sram_d_out;
    wire stall_o;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .adr_i(adr_i),
        .clk_i(clk_i),
        .cyc_i(cyc_i),
        .dat_i(dat_i),
        .reset_i(reset_i),
        .sel_i(sel_i),
        .sram_d_in(sram_d_in),
        .stb_i(stb_i),
        .we_i(we_i),
        ._sram_ce(_sram_ce),
        ._sram_lb(_sram_lb),
        ._sram_oe(_sram_oe),
        ._sram_ub(_sram_ub),
        ._sram_we(_sram_we),
        .ack_o(ack_o),
        .dat_o(dat_o),
        .sram_a(sram_a),
        .sram_d_out(sram_d_out),
        .stall_o(stall_o)
    );

    // Clock generation (10ns period)
    initial begin
        clk_i = 0;
        forever #5 clk_i = ~clk_i;
    end

        task reset_dut;

        begin
            reset_i = 1;
            clk_i = 0;
            cyc_i = 0;
            stb_i = 0;
            we_i = 0;
            sel_i = 0;
            adr_i = 0;
            dat_i = 0;
            sram_d_in = 0;
            #10;
            reset_i = 0;
            #10;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();

            cyc_i = 0;
            stb_i = 0;

            @(posedge clk_i);
            #1;


            #1;



            check_outputs(1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b0, 16'h0000, 19'h00000, 16'h0000, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();

            @(negedge clk_i);
            cyc_i = 1;
            stb_i = 1;
            we_i = 1;
            sel_i = 2'b11;
            adr_i = 19'h12345;
            dat_i = 16'hA5A5;

            @(posedge clk_i);
            #1;


            #1;



            check_outputs(1'b0, 1'b0, 1'b1, 1'b0, 1'b0, 1'b1, dat_o, 19'h12345, 16'hA5A5, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();

            @(negedge clk_i);
            cyc_i = 1;
            stb_i = 1;
            we_i = 0;
            sel_i = 2'b11;
            adr_i = 19'h54321;
            sram_d_in = 16'h5A5A;

            @(posedge clk_i);
            #1;


            #1;



            check_outputs(1'b0, 1'b0, 1'b0, 1'b0, 1'b1, 1'b1, 16'h5A5A, 19'h54321, 16'h0000, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();

            @(negedge clk_i);
            cyc_i = 1;
            stb_i = 1;
            we_i = 1;
            sel_i = 2'b01;
            adr_i = 19'h0000F;
            dat_i = 16'h1122;

            @(posedge clk_i);
            #1;


            #1;



            check_outputs(1'b0, 1'b0, 1'b1, 1'b1, 1'b0, 1'b1, dat_o, 19'h0000F, 16'h1122, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();

            @(negedge clk_i);
            cyc_i = 1;
            stb_i = 1;
            we_i = 1;
            sel_i = 2'b10;
            adr_i = 19'h7FFFF;
            dat_i = 16'hBEEF;

            @(posedge clk_i);
            #1;


            #1;



            check_outputs(1'b0, 1'b1, 1'b1, 1'b0, 1'b0, 1'b1, dat_o, 19'h7FFFF, 16'hBEEF, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();

            @(negedge clk_i);
            cyc_i = 1;
            stb_i = 0;
            we_i = 1;

            @(posedge clk_i);
            #1;


            #1;



            check_outputs(1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b0, 16'h0000, 19'h00000, 16'h0000, 1'b0);
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
        input expected__sram_ce;
        input expected__sram_lb;
        input expected__sram_oe;
        input expected__sram_ub;
        input expected__sram_we;
        input expected_ack_o;
        input [15:0] expected_dat_o;
        input [18:0] expected_sram_a;
        input [15:0] expected_sram_d_out;
        input expected_stall_o;
        begin
            if (expected__sram_ce === (expected__sram_ce ^ _sram_ce ^ expected__sram_ce) &&
                expected__sram_lb === (expected__sram_lb ^ _sram_lb ^ expected__sram_lb) &&
                expected__sram_oe === (expected__sram_oe ^ _sram_oe ^ expected__sram_oe) &&
                expected__sram_ub === (expected__sram_ub ^ _sram_ub ^ expected__sram_ub) &&
                expected__sram_we === (expected__sram_we ^ _sram_we ^ expected__sram_we) &&
                expected_ack_o === (expected_ack_o ^ ack_o ^ expected_ack_o) &&
                expected_dat_o === (expected_dat_o ^ dat_o ^ expected_dat_o) &&
                expected_sram_a === (expected_sram_a ^ sram_a ^ expected_sram_a) &&
                expected_sram_d_out === (expected_sram_d_out ^ sram_d_out ^ expected_sram_d_out) &&
                expected_stall_o === (expected_stall_o ^ stall_o ^ expected_stall_o)) begin
                $display("PASS");
                $display("  Outputs: _sram_ce=%b, _sram_lb=%b, _sram_oe=%b, _sram_ub=%b, _sram_we=%b, ack_o=%b, dat_o=%h, sram_a=%h, sram_d_out=%h, stall_o=%b",
                         _sram_ce, _sram_lb, _sram_oe, _sram_ub, _sram_we, ack_o, dat_o, sram_a, sram_d_out, stall_o);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: _sram_ce=%b, _sram_lb=%b, _sram_oe=%b, _sram_ub=%b, _sram_we=%b, ack_o=%b, dat_o=%h, sram_a=%h, sram_d_out=%h, stall_o=%b",
                         expected__sram_ce, expected__sram_lb, expected__sram_oe, expected__sram_ub, expected__sram_we, expected_ack_o, expected_dat_o, expected_sram_a, expected_sram_d_out, expected_stall_o);
                $display("  Got:      _sram_ce=%b, _sram_lb=%b, _sram_oe=%b, _sram_ub=%b, _sram_we=%b, ack_o=%b, dat_o=%h, sram_a=%h, sram_d_out=%h, stall_o=%b",
                         _sram_ce, _sram_lb, _sram_oe, _sram_ub, _sram_we, ack_o, dat_o, sram_a, sram_d_out, stall_o);
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
        $dumpvars(0,adr_i, clk_i, cyc_i, dat_i, reset_i, sel_i, sram_d_in, stb_i, we_i, _sram_ce, _sram_lb, _sram_oe, _sram_ub, _sram_we, ack_o, dat_o, sram_a, sram_d_out, stall_o);
    end

endmodule
