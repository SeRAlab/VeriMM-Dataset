`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [4:0] ch_sel;
    reg clk;
    reg [31:0] de_adr0;
    reg de_adr0_we;
    reg [31:0] de_adr1;
    reg de_adr1_we;
    reg [31:0] de_csr;
    reg de_csr_we;
    reg de_fetch_descr;
    reg [11:0] de_txsz;
    reg de_txsz_we;
    reg dma_busy;
    reg dma_done;
    reg dma_done_all;
    reg dma_err;
    reg dma_rest;
    reg ndnr;
    reg ptr_set;
    reg rst;
    reg [7:0] wb_rf_adr;
    reg [31:0] wb_rf_din;
    reg wb_rf_re;
    reg wb_rf_we;
    wire [31:0] ch_adr0;
    wire [31:0] ch_adr1;
    wire [31:0] ch_am0;
    wire [31:0] ch_am1;
    wire [31:0] ch_csr;
    wire ch_dis;
    wire ch_stop;
    wire [31:0] ch_txsz;
    wire irq;
    wire [31:0] pointer;
    wire [31:0] pointer_s;
    wire [31:0] sw_pointer;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ch_sel(ch_sel),
        .clk(clk),
        .de_adr0(de_adr0),
        .de_adr0_we(de_adr0_we),
        .de_adr1(de_adr1),
        .de_adr1_we(de_adr1_we),
        .de_csr(de_csr),
        .de_csr_we(de_csr_we),
        .de_fetch_descr(de_fetch_descr),
        .de_txsz(de_txsz),
        .de_txsz_we(de_txsz_we),
        .dma_busy(dma_busy),
        .dma_done(dma_done),
        .dma_done_all(dma_done_all),
        .dma_err(dma_err),
        .dma_rest(dma_rest),
        .ndnr(ndnr),
        .ptr_set(ptr_set),
        .rst(rst),
        .wb_rf_adr(wb_rf_adr),
        .wb_rf_din(wb_rf_din),
        .wb_rf_re(wb_rf_re),
        .wb_rf_we(wb_rf_we),
        .ch_adr0(ch_adr0),
        .ch_adr1(ch_adr1),
        .ch_am0(ch_am0),
        .ch_am1(ch_am1),
        .ch_csr(ch_csr),
        .ch_dis(ch_dis),
        .ch_stop(ch_stop),
        .ch_txsz(ch_txsz),
        .irq(irq),
        .pointer(pointer),
        .pointer_s(pointer_s),
        .sw_pointer(sw_pointer)
    );
    task testcase001;

    begin
        test_num = 1;

        ch_sel = 0;
        de_adr0 = 0; de_adr0_we = 0;
        de_adr1 = 0; de_adr1_we = 0;
        de_csr = 0; de_csr_we = 0;
        de_fetch_descr = 0;
        de_txsz = 0; de_txsz_we = 0;
        dma_busy = 0; dma_done = 0; dma_done_all = 0; dma_err = 0; dma_rest = 0;
        ndnr = 0; ptr_set = 0;
        wb_rf_adr = 0; wb_rf_din = 0; wb_rf_re = 0; wb_rf_we = 0;


        clk = 0;
        rst = 1;
        #20 rst = 0;
        #20;


        #1;



        check_outputs(32'h0, 32'h0, 32'h0, 32'h0, 32'h0, 1'b0, 1'b0, 32'h0, 1'b0, 32'h0, 32'h0, 32'h0);
    end
    endtask

    task testcase002;

    begin
        test_num = 2;
        rst = 1; #20 rst = 0; #10;


        ch_sel = 5'd0;
        de_adr0 = 32'hAABBCCDD;
        de_adr0_we = 1;
        @(posedge clk);
        #2 de_adr0_we = 0;


        #1;



        check_outputs(32'hAABBCCDD, 32'h0, 32'h0, 32'h0, 32'h0, 1'b0, 1'b0, 32'h0, 1'b0, 32'h0, 32'h0, 32'h0);
    end
    endtask

    task testcase003;

    begin
        test_num = 3;
        rst = 1; #20 rst = 0; #10;


        ch_sel = 5'd0;
        de_csr = 32'h00000001;
        de_csr_we = 1;
        de_txsz = 12'hFFF;
        de_txsz_we = 1;
        @(posedge clk);
        #2 de_csr_we = 0; de_txsz_we = 0;


        #1;



        check_outputs(32'h0, 32'h0, 32'h0, 32'h0, 32'h1, 1'b0, 1'b0, 32'hFFF, 1'b0, 32'h0, 32'h0, 32'h0);
    end
    endtask

    task testcase004;

    begin
        test_num = 4;
        rst = 1; #20 rst = 0; #10;


        ch_sel = 5'd1;
        de_adr1 = 32'h11223344;
        de_adr1_we = 1;
        @(posedge clk);
        #2 de_adr1_we = 0;


        ch_sel = 5'd1;
        #10;
        #1;

        check_outputs(32'h0, 32'h11223344, 32'h0, 32'h0, 32'h0, 1'b0, 1'b0, 32'h0, 1'b0, 32'h0, 32'h0, 32'h0);
    end
    endtask

    task testcase005;

    begin
        test_num = 5;
        rst = 1; #20 rst = 0; #10;



        ch_sel = 5'd2;
        wb_rf_din = 32'h55667788;
        wb_rf_adr = 8'h18;
        wb_rf_we = 1;
        ptr_set = 1;
        @(posedge clk);
        #2 wb_rf_we = 0; ptr_set = 0;


        ch_sel = 5'd2;
        #10;

        #1;


        check_outputs(32'h0, 32'h0, 32'h0, 32'h0, 32'h0, 1'b0, 1'b0, 32'h0, 1'b0, 32'h55667788, 32'h0, 32'h55667788);
    end
    endtask

    task testcase006;

    begin
        test_num = 6;
        rst = 1; #20 rst = 0; #10;


        ch_sel = 5'd0;
        de_csr = 32'h00000008;
        de_csr_we = 1;
        @(posedge clk);
        #2 de_csr_we = 0;

        dma_done_all = 1;
        #10;

        #1;


        check_outputs(32'h0, 32'h0, 32'h0, 32'h0, 32'h8, 1'b0, 1'b0, 32'h0, 1'b1, 32'h0, 32'h0, 32'h0);
        dma_done_all = 0;
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
        input [31:0] expected_ch_adr0;
        input [31:0] expected_ch_adr1;
        input [31:0] expected_ch_am0;
        input [31:0] expected_ch_am1;
        input [31:0] expected_ch_csr;
        input expected_ch_dis;
        input expected_ch_stop;
        input [31:0] expected_ch_txsz;
        input expected_irq;
        input [31:0] expected_pointer;
        input [31:0] expected_pointer_s;
        input [31:0] expected_sw_pointer;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_ch_adr0 === (expected_ch_adr0 ^ ch_adr0 ^ expected_ch_adr0) &&
                expected_ch_adr1 === (expected_ch_adr1 ^ ch_adr1 ^ expected_ch_adr1) &&
                expected_ch_am0 === (expected_ch_am0 ^ ch_am0 ^ expected_ch_am0) &&
                expected_ch_am1 === (expected_ch_am1 ^ ch_am1 ^ expected_ch_am1) &&
                expected_ch_csr === (expected_ch_csr ^ ch_csr ^ expected_ch_csr) &&
                expected_ch_dis === (expected_ch_dis ^ ch_dis ^ expected_ch_dis) &&
                expected_ch_stop === (expected_ch_stop ^ ch_stop ^ expected_ch_stop) &&
                expected_ch_txsz === (expected_ch_txsz ^ ch_txsz ^ expected_ch_txsz) &&
                expected_irq === (expected_irq ^ irq ^ expected_irq) &&
                expected_pointer === (expected_pointer ^ pointer ^ expected_pointer) &&
                expected_pointer_s === (expected_pointer_s ^ pointer_s ^ expected_pointer_s) &&
                expected_sw_pointer === (expected_sw_pointer ^ sw_pointer ^ expected_sw_pointer)) begin
                $display("PASS");
                $display("  Outputs: ch_adr0=%h, ch_adr1=%h, ch_am0=%h, ch_am1=%h, ch_csr=%h, ch_dis=%b, ch_stop=%b, ch_txsz=%h, irq=%b, pointer=%h, pointer_s=%h, sw_pointer=%h",
                         ch_adr0, ch_adr1, ch_am0, ch_am1, ch_csr, ch_dis, ch_stop, ch_txsz, irq, pointer, pointer_s, sw_pointer);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ch_adr0=%h, ch_adr1=%h, ch_am0=%h, ch_am1=%h, ch_csr=%h, ch_dis=%b, ch_stop=%b, ch_txsz=%h, irq=%b, pointer=%h, pointer_s=%h, sw_pointer=%h",
                         expected_ch_adr0, expected_ch_adr1, expected_ch_am0, expected_ch_am1, expected_ch_csr, expected_ch_dis, expected_ch_stop, expected_ch_txsz, expected_irq, expected_pointer, expected_pointer_s, expected_sw_pointer);
                $display("  Got:      ch_adr0=%h, ch_adr1=%h, ch_am0=%h, ch_am1=%h, ch_csr=%h, ch_dis=%b, ch_stop=%b, ch_txsz=%h, irq=%b, pointer=%h, pointer_s=%h, sw_pointer=%h",
                         ch_adr0, ch_adr1, ch_am0, ch_am1, ch_csr, ch_dis, ch_stop, ch_txsz, irq, pointer, pointer_s, sw_pointer);
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

endmodule
