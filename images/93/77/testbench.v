`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg rst;
    reg wbm_ack_i;
    reg [15:0] wbm_dat_i;
    reg [18:0] wbs_adr_i;
    reg wbs_cyc_i;
    reg [15:0] wbs_dat_i;
    reg [1:0] wbs_sel_i;
    reg wbs_stb_i;
    reg wbs_tga_i;
    reg wbs_we_i;
    wire [18:0] wbm_adr_o;
    wire wbm_cyc_o;
    wire [15:0] wbm_dat_o;
    wire [1:0] wbm_sel_o;
    wire wbm_stb_o;
    wire wbm_tga_o;
    wire wbm_we_o;
    wire wbs_ack_o;
    wire [15:0] wbs_dat_o;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .rst(rst),
        .wbm_ack_i(wbm_ack_i),
        .wbm_dat_i(wbm_dat_i),
        .wbs_adr_i(wbs_adr_i),
        .wbs_cyc_i(wbs_cyc_i),
        .wbs_dat_i(wbs_dat_i),
        .wbs_sel_i(wbs_sel_i),
        .wbs_stb_i(wbs_stb_i),
        .wbs_tga_i(wbs_tga_i),
        .wbs_we_i(wbs_we_i),
        .wbm_adr_o(wbm_adr_o),
        .wbm_cyc_o(wbm_cyc_o),
        .wbm_dat_o(wbm_dat_o),
        .wbm_sel_o(wbm_sel_o),
        .wbm_stb_o(wbm_stb_o),
        .wbm_tga_o(wbm_tga_o),
        .wbm_we_o(wbm_we_o),
        .wbs_ack_o(wbs_ack_o),
        .wbs_dat_o(wbs_dat_o)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            wbm_ack_i = 0;
            wbm_dat_i = 0;
            wbs_adr_i = 0;
            wbs_cyc_i = 0;
            wbs_dat_i = 0;
            wbs_sel_i = 0;
            wbs_stb_i = 0;
            wbs_tga_i = 0;
            wbs_we_i = 0;
            repeat(2) @(posedge clk);
            #1 rst = 0;
            repeat(1) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            $display("Running testcase001: Reset Verification");
            reset_dut();

            #1;


            check_outputs(19'h0, 0, 16'h0, 2'b0, 0, 0, 0, 0, 16'h0);
        end
        endtask

    task testcase002;

        begin
            $display("Running testcase002: Write Transaction Propagation");
            reset_dut();


            @(posedge clk);
            #1;
            wbs_adr_i = 19'h5A5A5;
            wbs_dat_i = 16'h1234;
            wbs_sel_i = 2'b11;
            wbs_we_i  = 1;
            wbs_cyc_i = 1;
            wbs_stb_i = 1;
            wbs_tga_i = 0;


            @(posedge clk);
            #1;
            wbm_ack_i = 1;


            @(posedge clk);
            #1;
            #1;

            check_outputs(19'h5A5A5, 1, 16'h1234, 2'b11, 1, 0, 1, 1, 16'h0);
        end
        endtask

    task testcase003;

        begin
            $display("Running testcase003: Read Transaction Data Return");
            reset_dut();


            @(posedge clk);
            #1;
            wbs_adr_i = 19'h00FFF;
            wbs_we_i  = 0;
            wbs_cyc_i = 1;
            wbs_stb_i = 1;
            wbs_sel_i = 2'b11;

            @(posedge clk);
            #1;
            wbm_ack_i = 1;
            wbm_dat_i = 16'hCAFE;

            @(posedge clk);
            #1;

            #1;


            check_outputs(19'h00FFF, 1, 16'h0, 2'b11, 1, 0, 0, 1, 16'hCAFE);
        end
        endtask

    task testcase004;

        begin
            $display("Running testcase004: Sel and Tag Propagation");
            reset_dut();

            @(posedge clk);
            #1;
            wbs_adr_i = 19'h7FFFF;
            wbs_dat_i = 16'hABCD;
            wbs_sel_i = 2'b01;
            wbs_tga_i = 1;
            wbs_we_i  = 1;
            wbs_cyc_i = 1;
            wbs_stb_i = 1;

            @(posedge clk);
            #1;
            wbm_ack_i = 1;

            @(posedge clk);
            #1;

            #1;


            check_outputs(19'h7FFFF, 1, 16'hABCD, 2'b01, 1, 1, 1, 1, 16'h0);
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
        input [18:0] expected_wbm_adr_o;
        input expected_wbm_cyc_o;
        input [15:0] expected_wbm_dat_o;
        input [1:0] expected_wbm_sel_o;
        input expected_wbm_stb_o;
        input expected_wbm_tga_o;
        input expected_wbm_we_o;
        input expected_wbs_ack_o;
        input [15:0] expected_wbs_dat_o;
        begin
            if (expected_wbm_adr_o === (expected_wbm_adr_o ^ wbm_adr_o ^ expected_wbm_adr_o) &&
                expected_wbm_cyc_o === (expected_wbm_cyc_o ^ wbm_cyc_o ^ expected_wbm_cyc_o) &&
                expected_wbm_dat_o === (expected_wbm_dat_o ^ wbm_dat_o ^ expected_wbm_dat_o) &&
                expected_wbm_sel_o === (expected_wbm_sel_o ^ wbm_sel_o ^ expected_wbm_sel_o) &&
                expected_wbm_stb_o === (expected_wbm_stb_o ^ wbm_stb_o ^ expected_wbm_stb_o) &&
                expected_wbm_tga_o === (expected_wbm_tga_o ^ wbm_tga_o ^ expected_wbm_tga_o) &&
                expected_wbm_we_o === (expected_wbm_we_o ^ wbm_we_o ^ expected_wbm_we_o) &&
                expected_wbs_ack_o === (expected_wbs_ack_o ^ wbs_ack_o ^ expected_wbs_ack_o) &&
                expected_wbs_dat_o === (expected_wbs_dat_o ^ wbs_dat_o ^ expected_wbs_dat_o)) begin
                $display("PASS");
                $display("  Outputs: wbm_adr_o=%h, wbm_cyc_o=%b, wbm_dat_o=%h, wbm_sel_o=%h, wbm_stb_o=%b, wbm_tga_o=%b, wbm_we_o=%b, wbs_ack_o=%b, wbs_dat_o=%h",
                         wbm_adr_o, wbm_cyc_o, wbm_dat_o, wbm_sel_o, wbm_stb_o, wbm_tga_o, wbm_we_o, wbs_ack_o, wbs_dat_o);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: wbm_adr_o=%h, wbm_cyc_o=%b, wbm_dat_o=%h, wbm_sel_o=%h, wbm_stb_o=%b, wbm_tga_o=%b, wbm_we_o=%b, wbs_ack_o=%b, wbs_dat_o=%h",
                         expected_wbm_adr_o, expected_wbm_cyc_o, expected_wbm_dat_o, expected_wbm_sel_o, expected_wbm_stb_o, expected_wbm_tga_o, expected_wbm_we_o, expected_wbs_ack_o, expected_wbs_dat_o);
                $display("  Got:      wbm_adr_o=%h, wbm_cyc_o=%b, wbm_dat_o=%h, wbm_sel_o=%h, wbm_stb_o=%b, wbm_tga_o=%b, wbm_we_o=%b, wbs_ack_o=%b, wbs_dat_o=%h",
                         wbm_adr_o, wbm_cyc_o, wbm_dat_o, wbm_sel_o, wbm_stb_o, wbm_tga_o, wbm_we_o, wbs_ack_o, wbs_dat_o);
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
        $dumpvars(0,clk, rst, wbm_ack_i, wbm_dat_i, wbs_adr_i, wbs_cyc_i, wbs_dat_i, wbs_sel_i, wbs_stb_i, wbs_tga_i, wbs_we_i, wbm_adr_o, wbm_cyc_o, wbm_dat_o, wbm_sel_o, wbm_stb_o, wbm_tga_o, wbm_we_o, wbs_ack_o, wbs_dat_o);
    end

endmodule
