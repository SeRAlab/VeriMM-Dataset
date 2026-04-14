`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [23:0] addr;
    reg clk;
    reg cs;
    reg [3:0] mask;
    reg [68:0] rcn_in;
    reg rst;
    reg [1:0] seq;
    reg [31:0] slave_rdata;
    reg [31:0] wdata;
    reg wr;
    wire busy;
    wire [68:0] rcn_out;
    wire rdone;
    wire [23:0] rsp_addr;
    wire [31:0] rsp_data;
    wire [3:0] rsp_mask;
    wire [1:0] rsp_seq;
    wire [23:0] slave_addr;
    wire slave_cs;
    wire [3:0] slave_mask;
    wire [31:0] slave_wdata;
    wire slave_wr;
    wire wdone;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .addr(addr),
        .clk(clk),
        .cs(cs),
        .mask(mask),
        .rcn_in(rcn_in),
        .rst(rst),
        .seq(seq),
        .slave_rdata(slave_rdata),
        .wdata(wdata),
        .wr(wr),
        .busy(busy),
        .rcn_out(rcn_out),
        .rdone(rdone),
        .rsp_addr(rsp_addr),
        .rsp_data(rsp_data),
        .rsp_mask(rsp_mask),
        .rsp_seq(rsp_seq),
        .slave_addr(slave_addr),
        .slave_cs(slave_cs),
        .slave_mask(slave_mask),
        .slave_wdata(slave_wdata),
        .slave_wr(slave_wr),
        .wdone(wdone)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            cs = 0; seq = 0; mask = 0; addr = 0; wdata = 0; wr = 0;
            rcn_in = 0; slave_rdata = 0;
            #20 rst = 0;
            #10;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            cs = 1; wr = 1; seq = 2'b01; mask = 4'hF; addr = 24'hABCDEF; wdata = 32'h12345678;
            @(posedge clk);
            #2;

            #1;


            check_outputs(1'b0, make_packet(2'b10, 2'b01, 4'hF, 24'hABCDEF, 32'h12345678), 1'b0, 24'h0, 32'h0, 4'h0, 2'b0, 24'h0, 1'b0, 4'h0, 32'h0, 1'b0, 1'b1);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            cs = 1; wr = 0; seq = 2'b10; mask = 4'h3; addr = 24'h112233;
            @(posedge clk);
            #2;

            #1;


            check_outputs(1'b1, make_packet(2'b01, 2'b10, 4'h3, 24'h112233, 32'h0), 1'b0, 24'h0, 32'h0, 4'h0, 2'b0, 24'h0, 1'b0, 4'h0, 32'h0, 1'b0, 1'b0);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            rcn_in = make_packet(2'b10, 2'b00, 4'hC, 24'h654321, 32'hCAFECAFE);
            @(posedge clk);
            #2;

            #1;


            check_outputs(1'b0, 69'h0, 1'b0, 24'h0, 32'h0, 4'h0, 2'b0, 24'h654321, 1'b1, 4'hC, 32'hCAFECAFE, 1'b1, 1'b0);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            rcn_in = make_packet(2'b01, 2'b11, 4'hF, 24'h556677, 32'h0);
            slave_rdata = 32'hDEADBEEF;
            @(posedge clk);
            @(posedge clk);
            #2;

            #1;


            check_outputs(1'b0, make_packet(2'b11, 2'b11, 4'hF, 24'h556677, 32'hDEADBEEF), 1'b0, 24'h0, 32'h0, 4'h0, 2'b0, 24'h0, 1'b0, 4'h0, 32'h0, 1'b0, 1'b0);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            rcn_in = make_packet(2'b11, 2'b10, 4'hF, 24'hABCDEF, 32'h99887766);
            @(posedge clk);
            #2;

            #1;


            check_outputs(1'b0, 69'h0, 1'b1, 24'hABCDEF, 32'h99887766, 4'hF, 2'b10, 24'h0, 1'b0, 4'h0, 32'h0, 1'b0, 1'b0);
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
        input [68:0] expected_rcn_out;
        input expected_rdone;
        input [23:0] expected_rsp_addr;
        input [31:0] expected_rsp_data;
        input [3:0] expected_rsp_mask;
        input [1:0] expected_rsp_seq;
        input [23:0] expected_slave_addr;
        input expected_slave_cs;
        input [3:0] expected_slave_mask;
        input [31:0] expected_slave_wdata;
        input expected_slave_wr;
        input expected_wdone;
        begin
            if (expected_busy === (expected_busy ^ busy ^ expected_busy) &&
                expected_rcn_out === (expected_rcn_out ^ rcn_out ^ expected_rcn_out) &&
                expected_rdone === (expected_rdone ^ rdone ^ expected_rdone) &&
                expected_rsp_addr === (expected_rsp_addr ^ rsp_addr ^ expected_rsp_addr) &&
                expected_rsp_data === (expected_rsp_data ^ rsp_data ^ expected_rsp_data) &&
                expected_rsp_mask === (expected_rsp_mask ^ rsp_mask ^ expected_rsp_mask) &&
                expected_rsp_seq === (expected_rsp_seq ^ rsp_seq ^ expected_rsp_seq) &&
                expected_slave_addr === (expected_slave_addr ^ slave_addr ^ expected_slave_addr) &&
                expected_slave_cs === (expected_slave_cs ^ slave_cs ^ expected_slave_cs) &&
                expected_slave_mask === (expected_slave_mask ^ slave_mask ^ expected_slave_mask) &&
                expected_slave_wdata === (expected_slave_wdata ^ slave_wdata ^ expected_slave_wdata) &&
                expected_slave_wr === (expected_slave_wr ^ slave_wr ^ expected_slave_wr) &&
                expected_wdone === (expected_wdone ^ wdone ^ expected_wdone)) begin
                $display("PASS");
                $display("  Outputs: busy=%b, rcn_out=%h, rdone=%b, rsp_addr=%h, rsp_data=%h, rsp_mask=%h, rsp_seq=%h, slave_addr=%h, slave_cs=%b, slave_mask=%h, slave_wdata=%h, slave_wr=%b, wdone=%b",
                         busy, rcn_out, rdone, rsp_addr, rsp_data, rsp_mask, rsp_seq, slave_addr, slave_cs, slave_mask, slave_wdata, slave_wr, wdone);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: busy=%b, rcn_out=%h, rdone=%b, rsp_addr=%h, rsp_data=%h, rsp_mask=%h, rsp_seq=%h, slave_addr=%h, slave_cs=%b, slave_mask=%h, slave_wdata=%h, slave_wr=%b, wdone=%b",
                         expected_busy, expected_rcn_out, expected_rdone, expected_rsp_addr, expected_rsp_data, expected_rsp_mask, expected_rsp_seq, expected_slave_addr, expected_slave_cs, expected_slave_mask, expected_slave_wdata, expected_slave_wr, expected_wdone);
                $display("  Got:      busy=%b, rcn_out=%h, rdone=%b, rsp_addr=%h, rsp_data=%h, rsp_mask=%h, rsp_seq=%h, slave_addr=%h, slave_cs=%b, slave_mask=%h, slave_wdata=%h, slave_wr=%b, wdone=%b",
                         busy, rcn_out, rdone, rsp_addr, rsp_data, rsp_mask, rsp_seq, slave_addr, slave_cs, slave_mask, slave_wdata, slave_wr, wdone);
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
        $dumpvars(0,addr, clk, cs, mask, rcn_in, rst, seq, slave_rdata, wdata, wr, busy, rcn_out, rdone, rsp_addr, rsp_data, rsp_mask, rsp_seq, slave_addr, slave_cs, slave_mask, slave_wdata, slave_wr, wdone);
    end

endmodule
