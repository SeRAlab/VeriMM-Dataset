`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg Q;
    reg aclk;
    reg [7:0] burst_count_reg;
    reg m_axi_wready;
    reg [31:0] tx_fifo_dataout_reg;
    reg tx_fifo_wr;
    reg tx_fifowren_reg;
    wire [7:0] gc0_count_d1_reg;
    wire [31:0] m_axi_wdata;
    wire out;
    wire s_dclk_o;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .Q(Q),
        .aclk(aclk),
        .burst_count_reg(burst_count_reg),
        .m_axi_wready(m_axi_wready),
        .tx_fifo_dataout_reg(tx_fifo_dataout_reg),
        .tx_fifo_wr(tx_fifo_wr),
        .tx_fifowren_reg(tx_fifowren_reg),
        .gc0_count_d1_reg(gc0_count_d1_reg),
        .m_axi_wdata(m_axi_wdata),
        .out(out),
        .s_dclk_o(s_dclk_o)
    );

    // Clock generation (10ns period)
    initial begin
        aclk = 0;
        forever #5 aclk = ~aclk;
    end

        task reset_dut;

        begin
            Q = 0;
            burst_count_reg = 0;
            m_axi_wready = 0;
            tx_fifo_dataout_reg = 0;
            tx_fifo_wr = 0;
            tx_fifowren_reg = 0;
            repeat(2) @(posedge aclk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();


            #1;



            check_outputs(8'h00, 32'h00000000, 1'b0, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            tx_fifo_dataout_reg = 32'hDEADBEEF;
            tx_fifo_wr = 1'b1;
            tx_fifowren_reg = 1'b1;
            @(posedge aclk);
            #1;
            #1;

            check_outputs(8'h00, 32'hDEADBEEF, 1'b0, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            burst_count_reg = 8'hAA;
            @(posedge aclk);
            #1;
            #1;

            check_outputs(8'hAA, 32'h00000000, 1'b0, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            Q = 1'b1;
            @(posedge aclk);
            #1;
            #1;

            check_outputs(8'h00, 32'h00000000, 1'b1, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            tx_fifo_dataout_reg = 32'h12345678;
            burst_count_reg = 8'h0F;
            m_axi_wready = 1'b1;
            Q = 1'b1;
            @(posedge aclk);
            #1;
            #1;

            check_outputs(8'h0F, 32'h12345678, 1'b1, 1'b1);
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
        input [7:0] expected_gc0_count_d1_reg;
        input [31:0] expected_m_axi_wdata;
        input expected_out;
        input expected_s_dclk_o;
        begin
            if (expected_gc0_count_d1_reg === (expected_gc0_count_d1_reg ^ gc0_count_d1_reg ^ expected_gc0_count_d1_reg) &&
                expected_m_axi_wdata === (expected_m_axi_wdata ^ m_axi_wdata ^ expected_m_axi_wdata) &&
                expected_out === (expected_out ^ out ^ expected_out) &&
                expected_s_dclk_o === (expected_s_dclk_o ^ s_dclk_o ^ expected_s_dclk_o)) begin
                $display("PASS");
                $display("  Outputs: gc0_count_d1_reg=%h, m_axi_wdata=%h, out=%b, s_dclk_o=%b",
                         gc0_count_d1_reg, m_axi_wdata, out, s_dclk_o);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: gc0_count_d1_reg=%h, m_axi_wdata=%h, out=%b, s_dclk_o=%b",
                         expected_gc0_count_d1_reg, expected_m_axi_wdata, expected_out, expected_s_dclk_o);
                $display("  Got:      gc0_count_d1_reg=%h, m_axi_wdata=%h, out=%b, s_dclk_o=%b",
                         gc0_count_d1_reg, m_axi_wdata, out, s_dclk_o);
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
        $dumpvars(0,Q, aclk, burst_count_reg, m_axi_wready, tx_fifo_dataout_reg, tx_fifo_wr, tx_fifowren_reg, gc0_count_d1_reg, m_axi_wdata, out, s_dclk_o);
    end

endmodule
