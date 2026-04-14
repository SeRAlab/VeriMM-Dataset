`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg clk;
    reg m_fmc_select;
    reg [14:0] m_ma;
    reg [35:0] m_mb_write;
    reg m_rd_rq;
    reg m_rq_cyc;
    reg [3:0] m_sel;
    reg m_wr_rq;
    reg m_wr_rs;
    reg reset;
    reg s0_addr_ack;
    reg [35:0] s0_mb_read;
    reg s0_rd_rs;
    reg s1_addr_ack;
    reg [35:0] s1_mb_read;
    reg s1_rd_rs;
    wire m_addr_ack;
    wire [35:0] m_mb_read;
    wire m_rd_rs;
    wire s0_fmc_select;
    wire [14:0] s0_ma;
    wire [35:0] s0_mb_write;
    wire s0_rd_rq;
    wire s0_rq_cyc;
    wire [3:0] s0_sel;
    wire s0_wr_rq;
    wire s0_wr_rs;
    wire s1_fmc_select;
    wire [14:0] s1_ma;
    wire [35:0] s1_mb_write;
    wire s1_rd_rq;
    wire s1_rq_cyc;
    wire [3:0] s1_sel;
    wire s1_wr_rq;
    wire s1_wr_rs;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .m_fmc_select(m_fmc_select),
        .m_ma(m_ma),
        .m_mb_write(m_mb_write),
        .m_rd_rq(m_rd_rq),
        .m_rq_cyc(m_rq_cyc),
        .m_sel(m_sel),
        .m_wr_rq(m_wr_rq),
        .m_wr_rs(m_wr_rs),
        .reset(reset),
        .s0_addr_ack(s0_addr_ack),
        .s0_mb_read(s0_mb_read),
        .s0_rd_rs(s0_rd_rs),
        .s1_addr_ack(s1_addr_ack),
        .s1_mb_read(s1_mb_read),
        .s1_rd_rs(s1_rd_rs),
        .m_addr_ack(m_addr_ack),
        .m_mb_read(m_mb_read),
        .m_rd_rs(m_rd_rs),
        .s0_fmc_select(s0_fmc_select),
        .s0_ma(s0_ma),
        .s0_mb_write(s0_mb_write),
        .s0_rd_rq(s0_rd_rq),
        .s0_rq_cyc(s0_rq_cyc),
        .s0_sel(s0_sel),
        .s0_wr_rq(s0_wr_rq),
        .s0_wr_rs(s0_wr_rs),
        .s1_fmc_select(s1_fmc_select),
        .s1_ma(s1_ma),
        .s1_mb_write(s1_mb_write),
        .s1_rd_rq(s1_rd_rq),
        .s1_rq_cyc(s1_rq_cyc),
        .s1_sel(s1_sel),
        .s1_wr_rq(s1_wr_rq),
        .s1_wr_rs(s1_wr_rs)
    );
    task testcase001;

    begin
        test_num = 1;
        reset = 1;
        m_fmc_select = 0; m_ma = 0; m_mb_write = 0; m_rd_rq = 0;
        m_rq_cyc = 0; m_sel = 0; m_wr_rq = 0; m_wr_rs = 0;
        s0_addr_ack = 0; s0_mb_read = 0; s0_rd_rs = 0;
        s1_addr_ack = 0; s1_mb_read = 0; s1_rd_rs = 0;
        #10; reset = 0; #10;

        #1;


        check_outputs(0, 36'h0, 0, 0, 15'h0, 36'h0, 0, 0, 4'h0, 0, 0, 0, 15'h0, 36'h0, 0, 0, 4'h0, 0, 0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        reset = 1; #10; reset = 0; #10;

        m_rq_cyc = 1;
        m_wr_rq = 1;
        m_ma = 15'h1234;
        m_sel = 4'hF;
        m_mb_write = 36'hA_5A5A_5A5A;
        s0_addr_ack = 1;
        s1_addr_ack = 0;
        #10;

        #1;


        check_outputs(1, 36'h0, 0, 0, 15'h1234, 36'hA_5A5A_5A5A, 0, 1, 4'hF, 1, 0, 0, 15'h1234, 36'hA_5A5A_5A5A, 0, 1, 4'hF, 1, 0);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        reset = 1; #10; reset = 0; #10;

        m_rq_cyc = 1;
        m_wr_rq = 1;
        m_ma = 15'h4321;
        m_sel = 4'h5;
        m_mb_write = 36'h5_A5A5_A5A5;
        s0_addr_ack = 0;
        s1_addr_ack = 1;
        #10;
        #1;

        check_outputs(1, 36'h0, 0, 0, 15'h4321, 36'h5_A5A5_A5A5, 0, 1, 4'h5, 1, 0, 0, 15'h4321, 36'h5_A5A5_A5A5, 0, 1, 4'h5, 1, 0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        reset = 1; #10; reset = 0; #10;

        m_rq_cyc = 1;
        m_rd_rq = 1;
        m_ma = 15'h7FFF;
        m_sel = 4'h0;
        s0_addr_ack = 1;
        s0_rd_rs = 1;
        s0_mb_read = 36'h1_2345_6789;
        s1_addr_ack = 0;
        s1_rd_rs = 0;
        s1_mb_read = 36'h0;
        #10;

        #1;


        check_outputs(1, 36'h1_2345_6789, 1, 0, 15'h7FFF, 36'h0, 1, 1, 4'h0, 0, 0, 0, 15'h7FFF, 36'h0, 1, 1, 4'h0, 0, 0);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        reset = 1; #10; reset = 0; #10;

        m_rq_cyc = 1;
        m_rd_rq = 1;
        m_ma = 15'h0001;
        m_sel = 4'h8;
        s0_addr_ack = 0;
        s0_rd_rs = 0;
        s0_mb_read = 36'h0;
        s1_addr_ack = 1;
        s1_rd_rs = 1;
        s1_mb_read = 36'hF_EDCB_A987;
        #10;

        #1;


        check_outputs(1, 36'hF_EDCB_A987, 1, 0, 15'h0001, 36'h0, 1, 1, 4'h8, 0, 0, 0, 15'h0001, 36'h0, 1, 1, 4'h8, 0, 0);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        reset = 1; #10; reset = 0; #10;

        m_rq_cyc = 1;
        m_wr_rs = 1;
        m_fmc_select = 1;
        m_ma = 15'h55AA;
        #10;
        #1;

        check_outputs(0, 36'h0, 0, 1, 15'h55AA, 36'h0, 0, 1, 4'h0, 0, 1, 1, 15'h55AA, 36'h0, 0, 1, 4'h0, 0, 1);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        reset = 1; #10; reset = 0; #10;

        m_rq_cyc = 1;
        m_rd_rq = 1;
        s0_addr_ack = 1;
        s1_addr_ack = 1;
        s0_rd_rs = 1;
        s1_rd_rs = 0;
        s0_mb_read = 36'hF_0000_FFFF;
        s1_mb_read = 36'h0_FFFF_0000;
        #10;

        #1;


        check_outputs(1, 36'hF_FFFF_FFFF, 1, 0, 15'h0, 36'h0, 1, 1, 4'h0, 0, 0, 0, 15'h0, 36'h0, 1, 1, 4'h0, 0, 0);
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
        testcase007();
        
        
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
        input expected_m_addr_ack;
        input [35:0] expected_m_mb_read;
        input expected_m_rd_rs;
        input expected_s0_fmc_select;
        input [14:0] expected_s0_ma;
        input [35:0] expected_s0_mb_write;
        input expected_s0_rd_rq;
        input expected_s0_rq_cyc;
        input [3:0] expected_s0_sel;
        input expected_s0_wr_rq;
        input expected_s0_wr_rs;
        input expected_s1_fmc_select;
        input [14:0] expected_s1_ma;
        input [35:0] expected_s1_mb_write;
        input expected_s1_rd_rq;
        input expected_s1_rq_cyc;
        input [3:0] expected_s1_sel;
        input expected_s1_wr_rq;
        input expected_s1_wr_rs;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_m_addr_ack === (expected_m_addr_ack ^ m_addr_ack ^ expected_m_addr_ack) &&
                expected_m_mb_read === (expected_m_mb_read ^ m_mb_read ^ expected_m_mb_read) &&
                expected_m_rd_rs === (expected_m_rd_rs ^ m_rd_rs ^ expected_m_rd_rs) &&
                expected_s0_fmc_select === (expected_s0_fmc_select ^ s0_fmc_select ^ expected_s0_fmc_select) &&
                expected_s0_ma === (expected_s0_ma ^ s0_ma ^ expected_s0_ma) &&
                expected_s0_mb_write === (expected_s0_mb_write ^ s0_mb_write ^ expected_s0_mb_write) &&
                expected_s0_rd_rq === (expected_s0_rd_rq ^ s0_rd_rq ^ expected_s0_rd_rq) &&
                expected_s0_rq_cyc === (expected_s0_rq_cyc ^ s0_rq_cyc ^ expected_s0_rq_cyc) &&
                expected_s0_sel === (expected_s0_sel ^ s0_sel ^ expected_s0_sel) &&
                expected_s0_wr_rq === (expected_s0_wr_rq ^ s0_wr_rq ^ expected_s0_wr_rq) &&
                expected_s0_wr_rs === (expected_s0_wr_rs ^ s0_wr_rs ^ expected_s0_wr_rs) &&
                expected_s1_fmc_select === (expected_s1_fmc_select ^ s1_fmc_select ^ expected_s1_fmc_select) &&
                expected_s1_ma === (expected_s1_ma ^ s1_ma ^ expected_s1_ma) &&
                expected_s1_mb_write === (expected_s1_mb_write ^ s1_mb_write ^ expected_s1_mb_write) &&
                expected_s1_rd_rq === (expected_s1_rd_rq ^ s1_rd_rq ^ expected_s1_rd_rq) &&
                expected_s1_rq_cyc === (expected_s1_rq_cyc ^ s1_rq_cyc ^ expected_s1_rq_cyc) &&
                expected_s1_sel === (expected_s1_sel ^ s1_sel ^ expected_s1_sel) &&
                expected_s1_wr_rq === (expected_s1_wr_rq ^ s1_wr_rq ^ expected_s1_wr_rq) &&
                expected_s1_wr_rs === (expected_s1_wr_rs ^ s1_wr_rs ^ expected_s1_wr_rs)) begin
                $display("PASS");
                $display("  Outputs: m_addr_ack=%b, m_mb_read=%h, m_rd_rs=%b, s0_fmc_select=%b, s0_ma=%h, s0_mb_write=%h, s0_rd_rq=%b, s0_rq_cyc=%b, s0_sel=%h, s0_wr_rq=%b, s0_wr_rs=%b, s1_fmc_select=%b, s1_ma=%h, s1_mb_write=%h, s1_rd_rq=%b, s1_rq_cyc=%b, s1_sel=%h, s1_wr_rq=%b, s1_wr_rs=%b",
                         m_addr_ack, m_mb_read, m_rd_rs, s0_fmc_select, s0_ma, s0_mb_write, s0_rd_rq, s0_rq_cyc, s0_sel, s0_wr_rq, s0_wr_rs, s1_fmc_select, s1_ma, s1_mb_write, s1_rd_rq, s1_rq_cyc, s1_sel, s1_wr_rq, s1_wr_rs);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: m_addr_ack=%b, m_mb_read=%h, m_rd_rs=%b, s0_fmc_select=%b, s0_ma=%h, s0_mb_write=%h, s0_rd_rq=%b, s0_rq_cyc=%b, s0_sel=%h, s0_wr_rq=%b, s0_wr_rs=%b, s1_fmc_select=%b, s1_ma=%h, s1_mb_write=%h, s1_rd_rq=%b, s1_rq_cyc=%b, s1_sel=%h, s1_wr_rq=%b, s1_wr_rs=%b",
                         expected_m_addr_ack, expected_m_mb_read, expected_m_rd_rs, expected_s0_fmc_select, expected_s0_ma, expected_s0_mb_write, expected_s0_rd_rq, expected_s0_rq_cyc, expected_s0_sel, expected_s0_wr_rq, expected_s0_wr_rs, expected_s1_fmc_select, expected_s1_ma, expected_s1_mb_write, expected_s1_rd_rq, expected_s1_rq_cyc, expected_s1_sel, expected_s1_wr_rq, expected_s1_wr_rs);
                $display("  Got:      m_addr_ack=%b, m_mb_read=%h, m_rd_rs=%b, s0_fmc_select=%b, s0_ma=%h, s0_mb_write=%h, s0_rd_rq=%b, s0_rq_cyc=%b, s0_sel=%h, s0_wr_rq=%b, s0_wr_rs=%b, s1_fmc_select=%b, s1_ma=%h, s1_mb_write=%h, s1_rd_rq=%b, s1_rq_cyc=%b, s1_sel=%h, s1_wr_rq=%b, s1_wr_rs=%b",
                         m_addr_ack, m_mb_read, m_rd_rs, s0_fmc_select, s0_ma, s0_mb_write, s0_rd_rq, s0_rq_cyc, s0_sel, s0_wr_rq, s0_wr_rs, s1_fmc_select, s1_ma, s1_mb_write, s1_rd_rq, s1_rq_cyc, s1_sel, s1_wr_rq, s1_wr_rs);
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
