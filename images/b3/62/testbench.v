`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg aclk;
    reg [11:0] axaddr_incr;
    reg [47:0] m_payload_i_reg;
    reg next;
    reg si_rs_awvalid;
    reg [1:0] state_reg;
    wire Q;
    wire [3:0] S;
    wire [11:0] m_axi_awaddr;
    wire next_pending_r_reg;
    wire [3:0] wrap_second_len_r_reg;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .aclk(aclk),
        .axaddr_incr(axaddr_incr),
        .m_payload_i_reg(m_payload_i_reg),
        .next(next),
        .si_rs_awvalid(si_rs_awvalid),
        .state_reg(state_reg),
        .Q(Q),
        .S(S),
        .m_axi_awaddr(m_axi_awaddr),
        .next_pending_r_reg(next_pending_r_reg),
        .wrap_second_len_r_reg(wrap_second_len_r_reg)
    );

    // Clock generation (10ns period)
    initial begin
        aclk = 0;
        forever #5 aclk = ~aclk;
    end

        task reset_dut;

        begin
            si_rs_awvalid = 0;
            m_payload_i_reg = 48'h0;
            state_reg = 2'b00;
            axaddr_incr = 12'h0;
            next = 0;
            @(posedge aclk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();

            #1;


            check_outputs(0, 4'h0, 12'h000, 0, 4'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            si_rs_awvalid = 1;
            state_reg = 2'b01;

            m_payload_i_reg = 48'h0000_0000_A123;
            axaddr_incr = 12'h000;
            @(posedge aclk);
            #1;


            #1;



            check_outputs(1, 4'h0, 12'h123, 0, 4'h0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            si_rs_awvalid = 1;
            state_reg = 2'b10;
            m_payload_i_reg = 48'h0000_0000_1000;
            axaddr_incr = 12'h004;
            @(posedge aclk);
            #1;

            #1;


            check_outputs(1, 4'h0, 12'h104, 0, 4'h0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            si_rs_awvalid = 1;
            state_reg = 2'b01;
            next = 1;
            @(posedge aclk);
            #1;

            #1;


            check_outputs(1, 4'h0, 12'h000, 1, 4'h0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            si_rs_awvalid = 1;
            state_reg = 2'b01;

            m_payload_i_reg = 48'h0000_F000_0000;
            @(posedge aclk);
            #1;

            #1;


            check_outputs(1, 4'h0, 12'h000, 0, 4'hF);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();
            next = 1;
            @(posedge aclk);
            #1;
            next = 0;
            @(posedge aclk);
            #1;

            #1;


            check_outputs(0, 4'h0, 12'h000, 0, 4'h0);
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
        input expected_Q;
        input [3:0] expected_S;
        input [11:0] expected_m_axi_awaddr;
        input expected_next_pending_r_reg;
        input [3:0] expected_wrap_second_len_r_reg;
        begin
            if (expected_Q === (expected_Q ^ Q ^ expected_Q) &&
                expected_S === (expected_S ^ S ^ expected_S) &&
                expected_m_axi_awaddr === (expected_m_axi_awaddr ^ m_axi_awaddr ^ expected_m_axi_awaddr) &&
                expected_next_pending_r_reg === (expected_next_pending_r_reg ^ next_pending_r_reg ^ expected_next_pending_r_reg) &&
                expected_wrap_second_len_r_reg === (expected_wrap_second_len_r_reg ^ wrap_second_len_r_reg ^ expected_wrap_second_len_r_reg)) begin
                $display("PASS");
                $display("  Outputs: Q=%b, S=%h, m_axi_awaddr=%h, next_pending_r_reg=%b, wrap_second_len_r_reg=%h",
                         Q, S, m_axi_awaddr, next_pending_r_reg, wrap_second_len_r_reg);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Q=%b, S=%h, m_axi_awaddr=%h, next_pending_r_reg=%b, wrap_second_len_r_reg=%h",
                         expected_Q, expected_S, expected_m_axi_awaddr, expected_next_pending_r_reg, expected_wrap_second_len_r_reg);
                $display("  Got:      Q=%b, S=%h, m_axi_awaddr=%h, next_pending_r_reg=%b, wrap_second_len_r_reg=%h",
                         Q, S, m_axi_awaddr, next_pending_r_reg, wrap_second_len_r_reg);
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
        $dumpvars(0,aclk, axaddr_incr, m_payload_i_reg, next, si_rs_awvalid, state_reg, Q, S, m_axi_awaddr, next_pending_r_reg, wrap_second_len_r_reg);
    end

endmodule
