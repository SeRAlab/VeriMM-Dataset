`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg aclk;
    reg grant_rnw_reg;
    reg grant_rnw_reg_0;
    reg [2:0] m_atarget_enc;
    reg m_atarget_enc_reg_0;
    reg m_atarget_enc_reg_1;
    reg [1:0] m_axi_awready;
    reg [1:0] m_axi_bvalid;
    reg [2:0] m_axi_wready;
    reg m_ready_d0;
    reg m_ready_d_reg_1_1;
    reg m_valid_i_reg;
    reg s_axi_wlast;
    reg s_axi_wready_i_reg;
    wire [2:0] m_ready_d;
    wire m_ready_d_reg_1_0;
    wire m_ready_d_reg_2_0;
    wire m_ready_d_reg_2_1;
    wire m_valid_o;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .aclk(aclk),
        .grant_rnw_reg(grant_rnw_reg),
        .grant_rnw_reg_0(grant_rnw_reg_0),
        .m_atarget_enc(m_atarget_enc),
        .m_atarget_enc_reg_0(m_atarget_enc_reg_0),
        .m_atarget_enc_reg_1(m_atarget_enc_reg_1),
        .m_axi_awready(m_axi_awready),
        .m_axi_bvalid(m_axi_bvalid),
        .m_axi_wready(m_axi_wready),
        .m_ready_d0(m_ready_d0),
        .m_ready_d_reg_1_1(m_ready_d_reg_1_1),
        .m_valid_i_reg(m_valid_i_reg),
        .s_axi_wlast(s_axi_wlast),
        .s_axi_wready_i_reg(s_axi_wready_i_reg),
        .m_ready_d(m_ready_d),
        .m_ready_d_reg_1_0(m_ready_d_reg_1_0),
        .m_ready_d_reg_2_0(m_ready_d_reg_2_0),
        .m_ready_d_reg_2_1(m_ready_d_reg_2_1),
        .m_valid_o(m_valid_o)
    );
    task reset_signals;

        begin
            aclk = 0;
            m_valid_i_reg = 0;
            m_ready_d0 = 0;
            s_axi_wready_i_reg = 0;
            grant_rnw_reg = 0;
            m_axi_wready = 3'b000;
            m_atarget_enc = 3'b000;
            m_axi_awready = 2'b00;
            m_axi_bvalid = 2'b00;
            m_ready_d_reg_1_1 = 0;
            m_atarget_enc_reg_1 = 0;
            m_atarget_enc_reg_0 = 0;
            grant_rnw_reg_0 = 0;
            s_axi_wlast = 0;
            #10;
        end
        endtask

    task testcase001;

        begin
            test_num = 1;
            reset_signals();
            $display("Test %0d: Idle State", test_num);

            #1;


            check_outputs(3'b000, 0, 0, 0, 0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_signals();
            $display("Test %0d: Route to Slave 0", test_num);
            m_valid_i_reg = 1;
            m_atarget_enc = 3'b001;
            m_axi_wready = 3'b001;
            m_ready_d0 = 1;
            #10;

            #1;


            check_outputs(3'b001, 0, 0, 0, 1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_signals();
            $display("Test %0d: Route to Slave 1", test_num);
            m_valid_i_reg = 1;
            m_atarget_enc = 3'b010;
            m_axi_wready = 3'b010;
            m_atarget_enc_reg_1 = 1;
            #10;
            #1;

            check_outputs(3'b010, 1, 0, 0, 1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_signals();
            $display("Test %0d: Route to Slave 2 with RNW Grant", test_num);
            m_valid_i_reg = 1;
            m_atarget_enc = 3'b100;
            m_axi_wready = 3'b100;
            grant_rnw_reg = 1;
            #10;
            #1;

            check_outputs(3'b100, 0, 1, 1, 1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_signals();
            $display("Test %0d: Burst Transfer End (WLAST)", test_num);
            m_valid_i_reg = 1;
            m_atarget_enc = 3'b001;
            m_axi_wready = 3'b001;
            s_axi_wlast = 1;
            s_axi_wready_i_reg = 1;
            #10;
            #1;

            check_outputs(3'b001, 0, 0, 0, 1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_signals();
            $display("Test %0d: Priority/Selection Check", test_num);
            m_valid_i_reg = 1;
            m_atarget_enc = 3'b010;
            m_axi_wready = 3'b111;
            m_ready_d0 = 1;
            #10;

            #1;


            check_outputs(3'b010, 1, 0, 0, 1);
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
        input [2:0] expected_m_ready_d;
        input expected_m_ready_d_reg_1_0;
        input expected_m_ready_d_reg_2_0;
        input expected_m_ready_d_reg_2_1;
        input expected_m_valid_o;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_m_ready_d === (expected_m_ready_d ^ m_ready_d ^ expected_m_ready_d) &&
                expected_m_ready_d_reg_1_0 === (expected_m_ready_d_reg_1_0 ^ m_ready_d_reg_1_0 ^ expected_m_ready_d_reg_1_0) &&
                expected_m_ready_d_reg_2_0 === (expected_m_ready_d_reg_2_0 ^ m_ready_d_reg_2_0 ^ expected_m_ready_d_reg_2_0) &&
                expected_m_ready_d_reg_2_1 === (expected_m_ready_d_reg_2_1 ^ m_ready_d_reg_2_1 ^ expected_m_ready_d_reg_2_1) &&
                expected_m_valid_o === (expected_m_valid_o ^ m_valid_o ^ expected_m_valid_o)) begin
                $display("PASS");
                $display("  Outputs: m_ready_d=%h, m_ready_d_reg_1_0=%b, m_ready_d_reg_2_0=%b, m_ready_d_reg_2_1=%b, m_valid_o=%b",
                         m_ready_d, m_ready_d_reg_1_0, m_ready_d_reg_2_0, m_ready_d_reg_2_1, m_valid_o);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: m_ready_d=%h, m_ready_d_reg_1_0=%b, m_ready_d_reg_2_0=%b, m_ready_d_reg_2_1=%b, m_valid_o=%b",
                         expected_m_ready_d, expected_m_ready_d_reg_1_0, expected_m_ready_d_reg_2_0, expected_m_ready_d_reg_2_1, expected_m_valid_o);
                $display("  Got:      m_ready_d=%h, m_ready_d_reg_1_0=%b, m_ready_d_reg_2_0=%b, m_ready_d_reg_2_1=%b, m_valid_o=%b",
                         m_ready_d, m_ready_d_reg_1_0, m_ready_d_reg_2_0, m_ready_d_reg_2_1, m_valid_o);
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
