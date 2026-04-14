`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg Q;
    reg aclk;
    reg [7:0] burst_count_reg;
    reg m_axi_wready;
    reg s_dclk_o;
    reg tx_fifo_wr;
    reg tx_fifowren_reg;
    wire [7:0] count_d1_reg;
    wire [31:0] m_axi_wdata;
    wire out;
    wire [31:0] tx_fifo_dataout_reg;

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
        .s_dclk_o(s_dclk_o),
        .tx_fifo_wr(tx_fifo_wr),
        .tx_fifowren_reg(tx_fifowren_reg),
        .count_d1_reg(count_d1_reg),
        .m_axi_wdata(m_axi_wdata),
        .out(out),
        .tx_fifo_dataout_reg(tx_fifo_dataout_reg)
    );

    // Clock generation (10ns period)
    initial begin
        aclk = 0;
        forever #5 aclk = ~aclk;
    end

        task reset_dut;

        begin
            Q = 0;
            burst_count_reg = 8'h00;
            m_axi_wready = 0;
            s_dclk_o = 0;
            tx_fifo_wr = 0;
            tx_fifowren_reg = 0;
            repeat(5) @(posedge aclk);
            $display("DUT Reset/Initialized.");
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("\nTest Case 001: Initial State Check");
            reset_dut();

            #1;


            check_outputs(8'h00, 32'h00000000, 1'b0, 32'h00000000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTest Case 002: Single Write Pulse");
            reset_dut();

            @(posedge aclk);
            tx_fifowren_reg = 1;
            burst_count_reg = 8'h01;
            @(posedge aclk);
            tx_fifo_wr = 1;
            @(posedge aclk);
            tx_fifo_wr = 0;
            tx_fifowren_reg = 0;

            repeat(2) @(posedge aclk);



            #1;




            check_outputs(count_d1_reg, m_axi_wdata, out, tx_fifo_dataout_reg);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTest Case 003: AXI Ready Signal Interaction");
            reset_dut();


            burst_count_reg = 8'h04;
            tx_fifowren_reg = 1;
            @(posedge aclk);
            tx_fifo_wr = 1;
            @(posedge aclk);
            tx_fifo_wr = 0;


            @(posedge aclk);
            m_axi_wready = 1;

            repeat(5) @(posedge aclk);

            #1;


            check_outputs(count_d1_reg, tx_fifo_dataout_reg, out, tx_fifo_dataout_reg);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTest Case 004: JTAG Clock Interaction");
            reset_dut();


            Q = 1;
            repeat(4) begin
                s_dclk_o = 1;
                #10;
                s_dclk_o = 0;
                #10;
            end


            @(posedge aclk);
            tx_fifowren_reg = 1;
            tx_fifo_wr = 1;
            @(posedge aclk);
            tx_fifo_wr = 0;

            repeat(3) @(posedge aclk);
            #1;

            check_outputs(count_d1_reg, m_axi_wdata, out, tx_fifo_dataout_reg);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nTest Case 005: Burst Write Scenario");
            reset_dut();

            burst_count_reg = 8'h08;
            tx_fifowren_reg = 1;


            repeat(4) begin
                @(posedge aclk);
                tx_fifo_wr = 1;
                @(posedge aclk);
                tx_fifo_wr = 0;
            end

            repeat(2) @(posedge aclk);
            #1;

            check_outputs(count_d1_reg, m_axi_wdata, out, tx_fifo_dataout_reg);
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
        input [7:0] expected_count_d1_reg;
        input [31:0] expected_m_axi_wdata;
        input expected_out;
        input [31:0] expected_tx_fifo_dataout_reg;
        begin
            if (expected_count_d1_reg === (expected_count_d1_reg ^ count_d1_reg ^ expected_count_d1_reg) &&
                expected_m_axi_wdata === (expected_m_axi_wdata ^ m_axi_wdata ^ expected_m_axi_wdata) &&
                expected_out === (expected_out ^ out ^ expected_out) &&
                expected_tx_fifo_dataout_reg === (expected_tx_fifo_dataout_reg ^ tx_fifo_dataout_reg ^ expected_tx_fifo_dataout_reg)) begin
                $display("PASS");
                $display("  Outputs: count_d1_reg=%h, m_axi_wdata=%h, out=%b, tx_fifo_dataout_reg=%h",
                         count_d1_reg, m_axi_wdata, out, tx_fifo_dataout_reg);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: count_d1_reg=%h, m_axi_wdata=%h, out=%b, tx_fifo_dataout_reg=%h",
                         expected_count_d1_reg, expected_m_axi_wdata, expected_out, expected_tx_fifo_dataout_reg);
                $display("  Got:      count_d1_reg=%h, m_axi_wdata=%h, out=%b, tx_fifo_dataout_reg=%h",
                         count_d1_reg, m_axi_wdata, out, tx_fifo_dataout_reg);
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
        $dumpvars(0,Q, aclk, burst_count_reg, m_axi_wready, s_dclk_o, tx_fifo_wr, tx_fifowren_reg, count_d1_reg, m_axi_wdata, out, tx_fifo_dataout_reg);
    end

endmodule
