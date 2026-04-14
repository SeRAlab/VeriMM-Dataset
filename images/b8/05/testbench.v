`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [31:0] mast_adr;
    reg [31:0] mast_din;
    reg mast_go;
    reg [70:0] mast_pt_in;
    reg mast_wait;
    reg mast_we;
    reg pt_sel;
    reg rst;
    reg wb_ack_i;
    reg [31:0] wb_data_i;
    reg wb_err_i;
    reg wb_rty_i;
    wire [31:0] mast_dout;
    wire mast_drdy;
    wire mast_err;
    wire [34:0] mast_pt_out;
    wire [31:0] wb_addr_o;
    wire wb_cyc_o;
    wire [31:0] wb_data_o;
    wire [3:0] wb_sel_o;
    wire wb_stb_o;
    wire wb_we_o;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .mast_adr(mast_adr),
        .mast_din(mast_din),
        .mast_go(mast_go),
        .mast_pt_in(mast_pt_in),
        .mast_wait(mast_wait),
        .mast_we(mast_we),
        .pt_sel(pt_sel),
        .rst(rst),
        .wb_ack_i(wb_ack_i),
        .wb_data_i(wb_data_i),
        .wb_err_i(wb_err_i),
        .wb_rty_i(wb_rty_i),
        .mast_dout(mast_dout),
        .mast_drdy(mast_drdy),
        .mast_err(mast_err),
        .mast_pt_out(mast_pt_out),
        .wb_addr_o(wb_addr_o),
        .wb_cyc_o(wb_cyc_o),
        .wb_data_o(wb_data_o),
        .wb_sel_o(wb_sel_o),
        .wb_stb_o(wb_stb_o),
        .wb_we_o(wb_we_o)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            mast_go = 0;
            mast_adr = 0;
            mast_din = 0;
            mast_we = 0;
            mast_wait = 0;
            wb_ack_i = 0;
            wb_data_i = 0;
            wb_err_i = 0;
            wb_rty_i = 0;
            pt_sel = 0;
            mast_pt_in = 0;
            repeat(2) @(posedge clk);
            #1 rst = 0;
            repeat(1) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            reset_dut();

            mast_adr = 32'h1000_0000;
            mast_we = 0;
            mast_go = 1;
            @(posedge clk);
            #1;



            wb_data_i = 32'hDEADBEEF;
            wb_ack_i = 1;
            @(posedge clk);
            #1;



            #1;




            check_outputs(32'hDEADBEEF, 1'b1, 1'b0, 35'h0, 32'h1000_0000, 1'b1, 32'h0, 4'hf, 1'b1, 1'b0);

            mast_go = 0;
            wb_ack_i = 0;
            @(posedge clk);
        end
        endtask

    task testcase002;

        begin
            reset_dut();

            mast_adr = 32'h2000_4000;
            mast_din = 32'hCAFEBABE;
            mast_we = 1;
            mast_go = 1;
            @(posedge clk);
            #1;


            wb_ack_i = 1;
            @(posedge clk);
            #1;


            #1;



            check_outputs(32'h0, 1'b1, 1'b0, 35'h0, 32'h2000_4000, 1'b1, 32'hCAFEBABE, 4'hf, 1'b1, 1'b1);

            mast_go = 0;
            wb_ack_i = 0;
            @(posedge clk);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            mast_adr = 32'hF000_0000;
            mast_we = 0;
            mast_go = 1;
            @(posedge clk);
            #1;


            wb_err_i = 1;
            @(posedge clk);
            #1;


            #1;



            check_outputs(32'h0, 1'b0, 1'b1, 35'h0, 32'hF000_0000, 1'b1, 32'h0, 4'hf, 1'b1, 1'b0);

            mast_go = 0;
            wb_err_i = 0;
            @(posedge clk);
        end
        endtask

    task testcase004;

        begin
            reset_dut();

            pt_sel = 0;
            mast_pt_in = {36'hA, 35'h1_5555_5555};
            @(posedge clk);
            #1;

            #1;


            check_outputs(32'h0, 1'b0, 1'b0, 35'h1_5555_5555, 32'h0, 1'b0, 32'h0, 4'h0, 1'b0, 1'b0);


            pt_sel = 1;
            mast_pt_in = {36'h5_AAAA_AAAA, 35'h0};
            @(posedge clk);
            #1;

            #1;


            check_outputs(32'h0, 1'b0, 1'b0, 35'h1_AAAA_AAAA, 32'h0, 1'b0, 32'h0, 4'h0, 1'b0, 1'b0);
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
        input [31:0] expected_mast_dout;
        input expected_mast_drdy;
        input expected_mast_err;
        input [34:0] expected_mast_pt_out;
        input [31:0] expected_wb_addr_o;
        input expected_wb_cyc_o;
        input [31:0] expected_wb_data_o;
        input [3:0] expected_wb_sel_o;
        input expected_wb_stb_o;
        input expected_wb_we_o;
        begin
            if (expected_mast_dout === (expected_mast_dout ^ mast_dout ^ expected_mast_dout) &&
                expected_mast_drdy === (expected_mast_drdy ^ mast_drdy ^ expected_mast_drdy) &&
                expected_mast_err === (expected_mast_err ^ mast_err ^ expected_mast_err) &&
                expected_mast_pt_out === (expected_mast_pt_out ^ mast_pt_out ^ expected_mast_pt_out) &&
                expected_wb_addr_o === (expected_wb_addr_o ^ wb_addr_o ^ expected_wb_addr_o) &&
                expected_wb_cyc_o === (expected_wb_cyc_o ^ wb_cyc_o ^ expected_wb_cyc_o) &&
                expected_wb_data_o === (expected_wb_data_o ^ wb_data_o ^ expected_wb_data_o) &&
                expected_wb_sel_o === (expected_wb_sel_o ^ wb_sel_o ^ expected_wb_sel_o) &&
                expected_wb_stb_o === (expected_wb_stb_o ^ wb_stb_o ^ expected_wb_stb_o) &&
                expected_wb_we_o === (expected_wb_we_o ^ wb_we_o ^ expected_wb_we_o)) begin
                $display("PASS");
                $display("  Outputs: mast_dout=%h, mast_drdy=%b, mast_err=%b, mast_pt_out=%h, wb_addr_o=%h, wb_cyc_o=%b, wb_data_o=%h, wb_sel_o=%h, wb_stb_o=%b, wb_we_o=%b",
                         mast_dout, mast_drdy, mast_err, mast_pt_out, wb_addr_o, wb_cyc_o, wb_data_o, wb_sel_o, wb_stb_o, wb_we_o);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: mast_dout=%h, mast_drdy=%b, mast_err=%b, mast_pt_out=%h, wb_addr_o=%h, wb_cyc_o=%b, wb_data_o=%h, wb_sel_o=%h, wb_stb_o=%b, wb_we_o=%b",
                         expected_mast_dout, expected_mast_drdy, expected_mast_err, expected_mast_pt_out, expected_wb_addr_o, expected_wb_cyc_o, expected_wb_data_o, expected_wb_sel_o, expected_wb_stb_o, expected_wb_we_o);
                $display("  Got:      mast_dout=%h, mast_drdy=%b, mast_err=%b, mast_pt_out=%h, wb_addr_o=%h, wb_cyc_o=%b, wb_data_o=%h, wb_sel_o=%h, wb_stb_o=%b, wb_we_o=%b",
                         mast_dout, mast_drdy, mast_err, mast_pt_out, wb_addr_o, wb_cyc_o, wb_data_o, wb_sel_o, wb_stb_o, wb_we_o);
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
        $dumpvars(0,clk, mast_adr, mast_din, mast_go, mast_pt_in, mast_wait, mast_we, pt_sel, rst, wb_ack_i, wb_data_i, wb_err_i, wb_rty_i, mast_dout, mast_drdy, mast_err, mast_pt_out, wb_addr_o, wb_cyc_o, wb_data_o, wb_sel_o, wb_stb_o, wb_we_o);
    end

endmodule
