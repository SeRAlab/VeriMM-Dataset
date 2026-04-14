`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg fifo_Read;
    reg fifo_wr;
    reg mux_sel_reg_0;
    reg mux_sel_reg_2;
    reg p_4_in;
    reg reset_TX_FIFO_reg;
    reg s_axi_aclk;
    reg s_axi_aresetn;
    reg [7:0] s_axi_wdata;
    reg [7:0] tx_DataBits;
    reg tx_Data_Enable_reg;
    reg tx_Start;
    wire [7:0] Q;
    wire mux_Out;
    wire tx_Buffer_Full;
    wire tx_Start0;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .fifo_Read(fifo_Read),
        .fifo_wr(fifo_wr),
        .mux_sel_reg_0(mux_sel_reg_0),
        .mux_sel_reg_2(mux_sel_reg_2),
        .p_4_in(p_4_in),
        .reset_TX_FIFO_reg(reset_TX_FIFO_reg),
        .s_axi_aclk(s_axi_aclk),
        .s_axi_aresetn(s_axi_aresetn),
        .s_axi_wdata(s_axi_wdata),
        .tx_DataBits(tx_DataBits),
        .tx_Data_Enable_reg(tx_Data_Enable_reg),
        .tx_Start(tx_Start),
        .Q(Q),
        .mux_Out(mux_Out),
        .tx_Buffer_Full(tx_Buffer_Full),
        .tx_Start0(tx_Start0)
    );

    // Clock generation (10ns period)
    initial begin
        s_axi_aclk = 0;
        forever #5 s_axi_aclk = ~s_axi_aclk;
    end

        task reset_dut;

        begin
            s_axi_aresetn = 0;
            reset_TX_FIFO_reg = 1;
            fifo_Read = 0;
            fifo_wr = 0;
            mux_sel_reg_0 = 0;
            mux_sel_reg_2 = 0;
            p_4_in = 0;
            s_axi_wdata = 0;
            tx_DataBits = 0;
            tx_Data_Enable_reg = 0;
            tx_Start = 0;
            repeat(2) @(posedge s_axi_aclk);
            s_axi_aresetn = 1;
            reset_TX_FIFO_reg = 0;
            @(posedge s_axi_aclk);
        end
        endtask
    task testcase001;

        begin
            reset_dut();

            s_axi_wdata = 8'hA5;
            fifo_wr = 1;
            @(posedge s_axi_aclk);
            fifo_wr = 0;
            @(posedge s_axi_aclk);

            fifo_Read = 1;
            @(posedge s_axi_aclk);
            fifo_Read = 0;
            @(posedge s_axi_aclk);
            #1;

            check_outputs(8'hA5, 1'b0, 1'b0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            reset_dut();

            s_axi_wdata = 8'h55;
            fifo_wr = 1;
            @(posedge s_axi_aclk);

            s_axi_wdata = 8'hAA;
            @(posedge s_axi_aclk);
            fifo_wr = 0;
            @(posedge s_axi_aclk);

            fifo_Read = 1;
            @(posedge s_axi_aclk);

            @(posedge s_axi_aclk);
            fifo_Read = 0;
            @(posedge s_axi_aclk);
            #1;

            check_outputs(8'hAA, 1'b0, 1'b0, 1'b0);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            tx_Start = 1;
            tx_Data_Enable_reg = 1;
            @(posedge s_axi_aclk);

            #1;


            check_outputs(8'h00, 1'b0, 1'b0, 1'b1);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            p_4_in = 1;
            mux_sel_reg_2 = 1;
            mux_sel_reg_0 = 1;
            @(posedge s_axi_aclk);
            #1;

            check_outputs(8'h00, 1'b1, 1'b0, 1'b0);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            s_axi_wdata = 8'hFF;
            fifo_wr = 1;
            @(posedge s_axi_aclk);
            fifo_wr = 0;
            reset_TX_FIFO_reg = 1;
            @(posedge s_axi_aclk);
            reset_TX_FIFO_reg = 0;
            fifo_Read = 1;
            @(posedge s_axi_aclk);
            fifo_Read = 0;

            #1;


            check_outputs(8'h00, 1'b0, 1'b0, 1'b0);
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
        input [7:0] expected_Q;
        input expected_mux_Out;
        input expected_tx_Buffer_Full;
        input expected_tx_Start0;
        begin
            if (expected_Q === (expected_Q ^ Q ^ expected_Q) &&
                expected_mux_Out === (expected_mux_Out ^ mux_Out ^ expected_mux_Out) &&
                expected_tx_Buffer_Full === (expected_tx_Buffer_Full ^ tx_Buffer_Full ^ expected_tx_Buffer_Full) &&
                expected_tx_Start0 === (expected_tx_Start0 ^ tx_Start0 ^ expected_tx_Start0)) begin
                $display("PASS");
                $display("  Outputs: Q=%h, mux_Out=%b, tx_Buffer_Full=%b, tx_Start0=%b",
                         Q, mux_Out, tx_Buffer_Full, tx_Start0);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Q=%h, mux_Out=%b, tx_Buffer_Full=%b, tx_Start0=%b",
                         expected_Q, expected_mux_Out, expected_tx_Buffer_Full, expected_tx_Start0);
                $display("  Got:      Q=%h, mux_Out=%b, tx_Buffer_Full=%b, tx_Start0=%b",
                         Q, mux_Out, tx_Buffer_Full, tx_Start0);
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
        $dumpvars(0,fifo_Read, fifo_wr, mux_sel_reg_0, mux_sel_reg_2, p_4_in, reset_TX_FIFO_reg, s_axi_aclk, s_axi_aresetn, s_axi_wdata, tx_DataBits, tx_Data_Enable_reg, tx_Start, Q, mux_Out, tx_Buffer_Full, tx_Start0);
    end

endmodule
