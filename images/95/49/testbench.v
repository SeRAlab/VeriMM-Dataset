`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg clk;
    reg m_cono_clear;
    reg m_cono_set;
    reg m_datao_clear;
    reg m_datao_set;
    reg m_iob_fm_datai;
    reg m_iob_fm_status;
    reg m_iob_poweron;
    reg m_iob_reset;
    reg [35:0] m_iob_write;
    reg [6:0] m_ios;
    reg m_rdi_pulse;
    reg reset;
    reg s0_dr_split;
    reg [35:0] s0_iob_read;
    reg [6:0] s0_pi_req;
    reg s0_rdi_data;
    wire m_dr_split;
    wire [35:0] m_iob_read;
    wire [6:0] m_pi_req;
    wire m_rdi_data;
    wire s0_cono_clear;
    wire s0_cono_set;
    wire s0_datao_clear;
    wire s0_datao_set;
    wire s0_iob_fm_datai;
    wire s0_iob_fm_status;
    wire s0_iob_poweron;
    wire s0_iob_reset;
    wire [35:0] s0_iob_write;
    wire [6:0] s0_ios;
    wire s0_rdi_pulse;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .m_cono_clear(m_cono_clear),
        .m_cono_set(m_cono_set),
        .m_datao_clear(m_datao_clear),
        .m_datao_set(m_datao_set),
        .m_iob_fm_datai(m_iob_fm_datai),
        .m_iob_fm_status(m_iob_fm_status),
        .m_iob_poweron(m_iob_poweron),
        .m_iob_reset(m_iob_reset),
        .m_iob_write(m_iob_write),
        .m_ios(m_ios),
        .m_rdi_pulse(m_rdi_pulse),
        .reset(reset),
        .s0_dr_split(s0_dr_split),
        .s0_iob_read(s0_iob_read),
        .s0_pi_req(s0_pi_req),
        .s0_rdi_data(s0_rdi_data),
        .m_dr_split(m_dr_split),
        .m_iob_read(m_iob_read),
        .m_pi_req(m_pi_req),
        .m_rdi_data(m_rdi_data),
        .s0_cono_clear(s0_cono_clear),
        .s0_cono_set(s0_cono_set),
        .s0_datao_clear(s0_datao_clear),
        .s0_datao_set(s0_datao_set),
        .s0_iob_fm_datai(s0_iob_fm_datai),
        .s0_iob_fm_status(s0_iob_fm_status),
        .s0_iob_poweron(s0_iob_poweron),
        .s0_iob_reset(s0_iob_reset),
        .s0_iob_write(s0_iob_write),
        .s0_ios(s0_ios),
        .s0_rdi_pulse(s0_rdi_pulse)
    );
    task clear_inputs;

    begin
        m_cono_clear = 0;
        m_cono_set = 0;
        m_datao_clear = 0;
        m_datao_set = 0;
        m_iob_fm_datai = 0;
        m_iob_fm_status = 0;
        m_iob_poweron = 0;
        m_iob_reset = 0;
        m_iob_write = 36'h0;
        m_ios = 7'h0;
        m_rdi_pulse = 0;
        s0_dr_split = 0;
        s0_iob_read = 36'h0;
        s0_pi_req = 7'h0;
        s0_rdi_data = 0;
        reset = 0;
        clk = 0;
    end
        endtask

    task testcase001;

    begin
        clear_inputs();
        test_num = 1;
        reset = 1;
        #10 clk = 1; #10 clk = 0;
        reset = 0;
        #10;


        #1;



        check_outputs(0, 36'h0, 7'h0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 36'h0, 7'h0, 0);
    end
        endtask

    task testcase002;

    begin
        clear_inputs();
        test_num = 2;
        reset = 1; #10 reset = 0; #10;
        m_iob_poweron = 1;
        m_iob_reset = 1;
        #10;
        #1;

        check_outputs(0, 36'h0, 7'h0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 36'h0, 7'h0, 0);
    end
        endtask

    task testcase003;

    begin
        clear_inputs();
        test_num = 3;
        reset = 1; #10 reset = 0; #10;
        m_cono_clear = 1;
        m_cono_set = 1;
        m_datao_clear = 1;
        m_datao_set = 1;
        #10;
        #1;

        check_outputs(0, 36'h0, 7'h0, 0, 1, 1, 1, 1, 0, 0, 0, 0, 36'h0, 7'h0, 0);
    end
        endtask

    task testcase004;

    begin
        clear_inputs();
        test_num = 4;
        reset = 1; #10 reset = 0; #10;
        m_iob_fm_datai = 1;
        m_iob_fm_status = 1;
        m_rdi_pulse = 1;
        m_ios = 7'h5A;
        #10;
        #1;

        check_outputs(0, 36'h0, 7'h0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 36'h0, 7'h5A, 1);
    end
        endtask

    task testcase005;

    begin
        clear_inputs();
        test_num = 5;
        reset = 1; #10 reset = 0; #10;
        m_iob_write = 36'hABCDE1234;
        #10;
        #1;

        check_outputs(0, 36'h0, 7'h0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 36'hABCDE1234, 7'h0, 0);
    end
        endtask

    task testcase006;

    begin
        clear_inputs();
        test_num = 6;
        reset = 1; #10 reset = 0; #10;
        s0_pi_req = 7'h3F;
        s0_iob_read = 36'h55555AAAA;
        s0_dr_split = 1;
        s0_rdi_data = 1;
        #10;
        #1;

        check_outputs(1, 36'h55555AAAA, 7'h3F, 1, 0, 0, 0, 0, 0, 0, 0, 0, 36'h0, 7'h0, 0);
    end
        endtask

    task testcase007;

    begin
        clear_inputs();
        test_num = 7;
        reset = 1; #10 reset = 0; #10;

        m_iob_write = 36'hFFFFFFFFF;
        m_ios = 7'h7F;

        s0_iob_read = 36'h123456789;
        s0_pi_req = 7'h42;
        #10;
        #1;

        check_outputs(0, 36'h123456789, 7'h42, 0, 0, 0, 0, 0, 0, 0, 0, 0, 36'hFFFFFFFFF, 7'h7F, 0);
    end
        endtask

    task testcase008;

    begin
        clear_inputs();
        test_num = 8;
        reset = 1; #10 reset = 0; #10;
        m_rdi_pulse = 1;
        #10 m_rdi_pulse = 0;
        #10 m_rdi_pulse = 1;
        #10;
        #1;

        check_outputs(0, 36'h0, 7'h0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 36'h0, 7'h0, 1);
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
        testcase008();
        
        
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
        input expected_m_dr_split;
        input [35:0] expected_m_iob_read;
        input [6:0] expected_m_pi_req;
        input expected_m_rdi_data;
        input expected_s0_cono_clear;
        input expected_s0_cono_set;
        input expected_s0_datao_clear;
        input expected_s0_datao_set;
        input expected_s0_iob_fm_datai;
        input expected_s0_iob_fm_status;
        input expected_s0_iob_poweron;
        input expected_s0_iob_reset;
        input [35:0] expected_s0_iob_write;
        input [6:0] expected_s0_ios;
        input expected_s0_rdi_pulse;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_m_dr_split === (expected_m_dr_split ^ m_dr_split ^ expected_m_dr_split) &&
                expected_m_iob_read === (expected_m_iob_read ^ m_iob_read ^ expected_m_iob_read) &&
                expected_m_pi_req === (expected_m_pi_req ^ m_pi_req ^ expected_m_pi_req) &&
                expected_m_rdi_data === (expected_m_rdi_data ^ m_rdi_data ^ expected_m_rdi_data) &&
                expected_s0_cono_clear === (expected_s0_cono_clear ^ s0_cono_clear ^ expected_s0_cono_clear) &&
                expected_s0_cono_set === (expected_s0_cono_set ^ s0_cono_set ^ expected_s0_cono_set) &&
                expected_s0_datao_clear === (expected_s0_datao_clear ^ s0_datao_clear ^ expected_s0_datao_clear) &&
                expected_s0_datao_set === (expected_s0_datao_set ^ s0_datao_set ^ expected_s0_datao_set) &&
                expected_s0_iob_fm_datai === (expected_s0_iob_fm_datai ^ s0_iob_fm_datai ^ expected_s0_iob_fm_datai) &&
                expected_s0_iob_fm_status === (expected_s0_iob_fm_status ^ s0_iob_fm_status ^ expected_s0_iob_fm_status) &&
                expected_s0_iob_poweron === (expected_s0_iob_poweron ^ s0_iob_poweron ^ expected_s0_iob_poweron) &&
                expected_s0_iob_reset === (expected_s0_iob_reset ^ s0_iob_reset ^ expected_s0_iob_reset) &&
                expected_s0_iob_write === (expected_s0_iob_write ^ s0_iob_write ^ expected_s0_iob_write) &&
                expected_s0_ios === (expected_s0_ios ^ s0_ios ^ expected_s0_ios) &&
                expected_s0_rdi_pulse === (expected_s0_rdi_pulse ^ s0_rdi_pulse ^ expected_s0_rdi_pulse)) begin
                $display("PASS");
                $display("  Outputs: m_dr_split=%b, m_iob_read=%h, m_pi_req=%h, m_rdi_data=%b, s0_cono_clear=%b, s0_cono_set=%b, s0_datao_clear=%b, s0_datao_set=%b, s0_iob_fm_datai=%b, s0_iob_fm_status=%b, s0_iob_poweron=%b, s0_iob_reset=%b, s0_iob_write=%h, s0_ios=%h, s0_rdi_pulse=%b",
                         m_dr_split, m_iob_read, m_pi_req, m_rdi_data, s0_cono_clear, s0_cono_set, s0_datao_clear, s0_datao_set, s0_iob_fm_datai, s0_iob_fm_status, s0_iob_poweron, s0_iob_reset, s0_iob_write, s0_ios, s0_rdi_pulse);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: m_dr_split=%b, m_iob_read=%h, m_pi_req=%h, m_rdi_data=%b, s0_cono_clear=%b, s0_cono_set=%b, s0_datao_clear=%b, s0_datao_set=%b, s0_iob_fm_datai=%b, s0_iob_fm_status=%b, s0_iob_poweron=%b, s0_iob_reset=%b, s0_iob_write=%h, s0_ios=%h, s0_rdi_pulse=%b",
                         expected_m_dr_split, expected_m_iob_read, expected_m_pi_req, expected_m_rdi_data, expected_s0_cono_clear, expected_s0_cono_set, expected_s0_datao_clear, expected_s0_datao_set, expected_s0_iob_fm_datai, expected_s0_iob_fm_status, expected_s0_iob_poweron, expected_s0_iob_reset, expected_s0_iob_write, expected_s0_ios, expected_s0_rdi_pulse);
                $display("  Got:      m_dr_split=%b, m_iob_read=%h, m_pi_req=%h, m_rdi_data=%b, s0_cono_clear=%b, s0_cono_set=%b, s0_datao_clear=%b, s0_datao_set=%b, s0_iob_fm_datai=%b, s0_iob_fm_status=%b, s0_iob_poweron=%b, s0_iob_reset=%b, s0_iob_write=%h, s0_ios=%h, s0_rdi_pulse=%b",
                         m_dr_split, m_iob_read, m_pi_req, m_rdi_data, s0_cono_clear, s0_cono_set, s0_datao_clear, s0_datao_set, s0_iob_fm_datai, s0_iob_fm_status, s0_iob_poweron, s0_iob_reset, s0_iob_write, s0_ios, s0_rdi_pulse);
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
