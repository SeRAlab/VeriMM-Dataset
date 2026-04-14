`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg ce;
    reg clk;
    reg m_axis_data_tready;
    reg rst;
    reg s_axis_config_tdata_fwd_inv;
    reg s_axis_config_tvalid;
    reg [15:0] s_axis_data_tdata_xn_im_0;
    reg [15:0] s_axis_data_tdata_xn_re_0;
    reg s_axis_data_tlast;
    reg s_axis_data_tvalid;
    wire [24:0] m_axis_data_tdata_xn_im_0;
    wire [24:0] m_axis_data_tdata_xn_re_0;
    wire m_axis_data_tlast;
    wire m_axis_data_tvalid;
    wire s_axis_config_tready;
    wire s_axis_data_tready;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ce(ce),
        .clk(clk),
        .m_axis_data_tready(m_axis_data_tready),
        .rst(rst),
        .s_axis_config_tdata_fwd_inv(s_axis_config_tdata_fwd_inv),
        .s_axis_config_tvalid(s_axis_config_tvalid),
        .s_axis_data_tdata_xn_im_0(s_axis_data_tdata_xn_im_0),
        .s_axis_data_tdata_xn_re_0(s_axis_data_tdata_xn_re_0),
        .s_axis_data_tlast(s_axis_data_tlast),
        .s_axis_data_tvalid(s_axis_data_tvalid),
        .m_axis_data_tdata_xn_im_0(m_axis_data_tdata_xn_im_0),
        .m_axis_data_tdata_xn_re_0(m_axis_data_tdata_xn_re_0),
        .m_axis_data_tlast(m_axis_data_tlast),
        .m_axis_data_tvalid(m_axis_data_tvalid),
        .s_axis_config_tready(s_axis_config_tready),
        .s_axis_data_tready(s_axis_data_tready)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        rst = 1;
        ce = 0;
        m_axis_data_tready = 0;
        s_axis_config_tvalid = 0;
        s_axis_config_tdata_fwd_inv = 0;
        s_axis_data_tvalid = 0;
        s_axis_data_tlast = 0;
        s_axis_data_tdata_xn_re_0 = 0;
        s_axis_data_tdata_xn_im_0 = 0;
        #20;
        rst = 0;
        #10;
        @(posedge clk);
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Basic Positive Values", test_num);
        reset_dut();

        ce = 1;
        m_axis_data_tready = 1;
        s_axis_data_tvalid = 1;
        s_axis_data_tdata_xn_re_0 = 16'sd10;
        s_axis_data_tdata_xn_im_0 = 16'sd25;
        s_axis_data_tlast = 0;


        wait(m_axis_data_tvalid === 1);
        @(posedge clk);
        #1;

        #1;


        check_outputs(
            25'sd150,
            25'sd60,
            1'b0,
            1'b1,
            1'b1,
            1'b1
        );
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Negative Signed Values", test_num);
        reset_dut();

        ce = 1;
        m_axis_data_tready = 1;
        s_axis_data_tvalid = 1;
        s_axis_data_tdata_xn_re_0 = -16'sd100;
        s_axis_data_tdata_xn_im_0 = -16'sd50;
        s_axis_data_tlast = 0;

        wait(m_axis_data_tvalid === 1);
        @(posedge clk);
        #1;

        #1;


        check_outputs(
            -25'sd300,
            -25'sd600,
            1'b0,
            1'b1,
            1'b1,
            1'b1
        );
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Large Values", test_num);
        reset_dut();

        ce = 1;
        m_axis_data_tready = 1;
        s_axis_data_tvalid = 1;
        s_axis_data_tdata_xn_re_0 = 16'sd5000;
        s_axis_data_tdata_xn_im_0 = -16'sd8000;
        s_axis_data_tlast = 0;

        wait(m_axis_data_tvalid === 1);
        @(posedge clk);
        #1;

        #1;


        check_outputs(
            -25'sd48000,
            25'sd30000,
            1'b0,
            1'b1,
            1'b1,
            1'b1
        );
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: TLAST Propagation", test_num);
        reset_dut();

        ce = 1;
        m_axis_data_tready = 1;
        s_axis_data_tvalid = 1;
        s_axis_data_tdata_xn_re_0 = 16'sd1;
        s_axis_data_tdata_xn_im_0 = 16'sd1;
        s_axis_data_tlast = 1;

        wait(m_axis_data_tvalid === 1);
        @(posedge clk);
        #1;

        #1;


        check_outputs(
            25'sd6,
            25'sd6,
            1'b1,
            1'b1,
            1'b1,
            1'b1
        );
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Clock Enable (CE) Gating", test_num);
        reset_dut();

        ce = 0;
        m_axis_data_tready = 1;
        s_axis_data_tvalid = 1;
        s_axis_data_tdata_xn_re_0 = 16'sd7;
        s_axis_data_tdata_xn_im_0 = 16'sd7;

        #50;

        if (m_axis_data_tvalid === 1) begin
            $display("Fail: Output valid while ce=0");
            fail_count = fail_count + 1;
        end else begin
            ce = 1;
            wait(m_axis_data_tvalid === 1);
            @(posedge clk);
            #1;
            #1;

            check_outputs(25'sd42, 25'sd42, 1'b0, 1'b1, 1'b1, 1'b1);
        end
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
        input [24:0] expected_m_axis_data_tdata_xn_im_0;
        input [24:0] expected_m_axis_data_tdata_xn_re_0;
        input expected_m_axis_data_tlast;
        input expected_m_axis_data_tvalid;
        input expected_s_axis_config_tready;
        input expected_s_axis_data_tready;
        begin
            if (expected_m_axis_data_tdata_xn_im_0 === (expected_m_axis_data_tdata_xn_im_0 ^ m_axis_data_tdata_xn_im_0 ^ expected_m_axis_data_tdata_xn_im_0) &&
                expected_m_axis_data_tdata_xn_re_0 === (expected_m_axis_data_tdata_xn_re_0 ^ m_axis_data_tdata_xn_re_0 ^ expected_m_axis_data_tdata_xn_re_0) &&
                expected_m_axis_data_tlast === (expected_m_axis_data_tlast ^ m_axis_data_tlast ^ expected_m_axis_data_tlast) &&
                expected_m_axis_data_tvalid === (expected_m_axis_data_tvalid ^ m_axis_data_tvalid ^ expected_m_axis_data_tvalid) &&
                expected_s_axis_config_tready === (expected_s_axis_config_tready ^ s_axis_config_tready ^ expected_s_axis_config_tready) &&
                expected_s_axis_data_tready === (expected_s_axis_data_tready ^ s_axis_data_tready ^ expected_s_axis_data_tready)) begin
                $display("PASS");
                $display("  Outputs: m_axis_data_tdata_xn_im_0=%h, m_axis_data_tdata_xn_re_0=%h, m_axis_data_tlast=%b, m_axis_data_tvalid=%b, s_axis_config_tready=%b, s_axis_data_tready=%b",
                         m_axis_data_tdata_xn_im_0, m_axis_data_tdata_xn_re_0, m_axis_data_tlast, m_axis_data_tvalid, s_axis_config_tready, s_axis_data_tready);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: m_axis_data_tdata_xn_im_0=%h, m_axis_data_tdata_xn_re_0=%h, m_axis_data_tlast=%b, m_axis_data_tvalid=%b, s_axis_config_tready=%b, s_axis_data_tready=%b",
                         expected_m_axis_data_tdata_xn_im_0, expected_m_axis_data_tdata_xn_re_0, expected_m_axis_data_tlast, expected_m_axis_data_tvalid, expected_s_axis_config_tready, expected_s_axis_data_tready);
                $display("  Got:      m_axis_data_tdata_xn_im_0=%h, m_axis_data_tdata_xn_re_0=%h, m_axis_data_tlast=%b, m_axis_data_tvalid=%b, s_axis_config_tready=%b, s_axis_data_tready=%b",
                         m_axis_data_tdata_xn_im_0, m_axis_data_tdata_xn_re_0, m_axis_data_tlast, m_axis_data_tvalid, s_axis_config_tready, s_axis_data_tready);
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
        $dumpvars(0,ce, clk, m_axis_data_tready, rst, s_axis_config_tdata_fwd_inv, s_axis_config_tvalid, s_axis_data_tdata_xn_im_0, s_axis_data_tdata_xn_re_0, s_axis_data_tlast, s_axis_data_tvalid, m_axis_data_tdata_xn_im_0, m_axis_data_tdata_xn_re_0, m_axis_data_tlast, m_axis_data_tvalid, s_axis_config_tready, s_axis_data_tready);
    end

endmodule
