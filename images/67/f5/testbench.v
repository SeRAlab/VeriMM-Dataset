`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg dac_clk;
    reg dac_rd;
    reg dma_clk;
    reg [63:0] dma_rdata;
    reg dma_runf;
    reg [31:0] fifo_rdata;
    reg fifo_rempty;
    reg fifo_runf;
    reg fifo_wfull;
    wire [31:0] dac_rdata;
    wire dac_runf;
    wire dma_rd;
    wire fifo_rd;
    wire fifo_rst;
    wire fifo_rstn;
    wire [63:0] fifo_wdata;
    wire fifo_wr;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .dac_clk(dac_clk),
        .dac_rd(dac_rd),
        .dma_clk(dma_clk),
        .dma_rdata(dma_rdata),
        .dma_runf(dma_runf),
        .fifo_rdata(fifo_rdata),
        .fifo_rempty(fifo_rempty),
        .fifo_runf(fifo_runf),
        .fifo_wfull(fifo_wfull),
        .dac_rdata(dac_rdata),
        .dac_runf(dac_runf),
        .dma_rd(dma_rd),
        .fifo_rd(fifo_rd),
        .fifo_rst(fifo_rst),
        .fifo_rstn(fifo_rstn),
        .fifo_wdata(fifo_wdata),
        .fifo_wr(fifo_wr)
    );

    // Clock generation (10ns period)
    initial begin
        dac_clk = 0;
        forever #5 dac_clk = ~dac_clk;
    end

        task reset_dut;

        begin
            dac_rd = 0;
            dma_rdata = 64'h0;
            dma_runf = 0;
            fifo_rdata = 32'h0;
            fifo_rempty = 1;
            fifo_runf = 0;
            fifo_wfull = 0;
            @(posedge dac_clk);
            @(posedge dma_clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();

            #1;


            check_outputs(32'h0, 0, 1, 0, 0, 1, 64'h0, 1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            dma_rdata = 64'hAABBCCDD_11223344;
            fifo_wfull = 0;
            @(posedge dma_clk);
            #1;

            #1;


            check_outputs(32'h0, 0, 1, 0, 0, 1, 64'hAABBCCDD_11223344, 1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            fifo_rdata = 32'h55667788;
            dac_rd = 1;
            @(posedge dac_clk);
            #1;

            #1;


            check_outputs(32'h55667788, 0, 1, 1, 0, 1, 64'h0, 1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            fifo_wfull = 1;
            dma_rdata = 64'hFFFFFFFF_FFFFFFFF;
            @(posedge dma_clk);
            #1;

            #1;


            check_outputs(32'h0, 0, 0, 0, 0, 1, 64'hFFFFFFFF_FFFFFFFF, 0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            fifo_runf = 1;
            @(posedge dac_clk);
            #1;

            #1;


            check_outputs(32'h0, 1, 1, 0, 0, 1, 64'h0, 1);
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
        input [31:0] expected_dac_rdata;
        input expected_dac_runf;
        input expected_dma_rd;
        input expected_fifo_rd;
        input expected_fifo_rst;
        input expected_fifo_rstn;
        input [63:0] expected_fifo_wdata;
        input expected_fifo_wr;
        begin
            if (expected_dac_rdata === (expected_dac_rdata ^ dac_rdata ^ expected_dac_rdata) &&
                expected_dac_runf === (expected_dac_runf ^ dac_runf ^ expected_dac_runf) &&
                expected_dma_rd === (expected_dma_rd ^ dma_rd ^ expected_dma_rd) &&
                expected_fifo_rd === (expected_fifo_rd ^ fifo_rd ^ expected_fifo_rd) &&
                expected_fifo_rst === (expected_fifo_rst ^ fifo_rst ^ expected_fifo_rst) &&
                expected_fifo_rstn === (expected_fifo_rstn ^ fifo_rstn ^ expected_fifo_rstn) &&
                expected_fifo_wdata === (expected_fifo_wdata ^ fifo_wdata ^ expected_fifo_wdata) &&
                expected_fifo_wr === (expected_fifo_wr ^ fifo_wr ^ expected_fifo_wr)) begin
                $display("PASS");
                $display("  Outputs: dac_rdata=%h, dac_runf=%b, dma_rd=%b, fifo_rd=%b, fifo_rst=%b, fifo_rstn=%b, fifo_wdata=%h, fifo_wr=%b",
                         dac_rdata, dac_runf, dma_rd, fifo_rd, fifo_rst, fifo_rstn, fifo_wdata, fifo_wr);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: dac_rdata=%h, dac_runf=%b, dma_rd=%b, fifo_rd=%b, fifo_rst=%b, fifo_rstn=%b, fifo_wdata=%h, fifo_wr=%b",
                         expected_dac_rdata, expected_dac_runf, expected_dma_rd, expected_fifo_rd, expected_fifo_rst, expected_fifo_rstn, expected_fifo_wdata, expected_fifo_wr);
                $display("  Got:      dac_rdata=%h, dac_runf=%b, dma_rd=%b, fifo_rd=%b, fifo_rst=%b, fifo_rstn=%b, fifo_wdata=%h, fifo_wr=%b",
                         dac_rdata, dac_runf, dma_rd, fifo_rd, fifo_rst, fifo_rstn, fifo_wdata, fifo_wr);
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
        $dumpvars(0,dac_clk, dac_rd, dma_clk, dma_rdata, dma_runf, fifo_rdata, fifo_rempty, fifo_runf, fifo_wfull, dac_rdata, dac_runf, dma_rd, fifo_rd, fifo_rst, fifo_rstn, fifo_wdata, fifo_wr);
    end

endmodule
