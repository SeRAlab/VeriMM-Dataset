`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg ENA_I;
    reg ENB_I;
    reg POR_A;
    reg [7:0] RD_PNTR;
    reg [7:0] WR_PNTR;
    reg aclk;
    reg p_20_out;
    reg [31:0] rx_fifo_data_o_reg;
    reg s_dclk_o;
    wire [31:0] D;
    wire ENB_dly_D;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ENA_I(ENA_I),
        .ENB_I(ENB_I),
        .POR_A(POR_A),
        .RD_PNTR(RD_PNTR),
        .WR_PNTR(WR_PNTR),
        .aclk(aclk),
        .p_20_out(p_20_out),
        .rx_fifo_data_o_reg(rx_fifo_data_o_reg),
        .s_dclk_o(s_dclk_o),
        .D(D),
        .ENB_dly_D(ENB_dly_D)
    );

    // Clock generation (10ns period)
    initial begin
        aclk = 0;
        forever #5 aclk = ~aclk;
    end

        task reset_dut;

        begin
            POR_A = 1;
            ENA_I = 0;
            ENB_I = 0;
            RD_PNTR = 0;
            WR_PNTR = 0;
            p_20_out = 0;
            rx_fifo_data_o_reg = 0;
            s_dclk_o = 0;
            repeat(2) @(posedge aclk);
            #2 POR_A = 0;
            repeat(2) @(posedge aclk);
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            $display("Running testcase001: Basic Write and Read...");


            p_20_out = 1;
            rx_fifo_data_o_reg = 32'hA5A5_5A5A;
            #10 s_dclk_o = 1; #10 s_dclk_o = 0;


            @(posedge aclk);
            WR_PNTR = 8'h0A;
            ENB_I = 1;
            @(posedge aclk);
            #1 ENB_I = 0;


            RD_PNTR = 8'h0A;
            ENA_I = 1;
            @(posedge aclk);
            #2;

            #1;


            check_outputs(32'hA5A5_5A5A, 0);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            $display("Running testcase002: Boundary Address (0xFF)...");


            p_20_out = 1;
            rx_fifo_data_o_reg = 32'hDEAD_BEEF;
            #10 s_dclk_o = 1; #10 s_dclk_o = 0;


            @(posedge aclk);
            WR_PNTR = 8'hFF;
            ENB_I = 1;
            @(posedge aclk);
            #1 ENB_I = 0;


            RD_PNTR = 8'hFF;
            ENA_I = 1;
            @(posedge aclk);
            #2;

            #1;


            check_outputs(32'hDEAD_BEEF, 0);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            $display("Running testcase003: p_20_out Gating...");


            p_20_out = 1;
            rx_fifo_data_o_reg = 32'h1111_2222;
            #10 s_dclk_o = 1; #10 s_dclk_o = 0;


            p_20_out = 0;
            rx_fifo_data_o_reg = 32'hEEEE_EEEE;
            #10 s_dclk_o = 1; #10 s_dclk_o = 0;


            @(posedge aclk);
            WR_PNTR = 8'h20;
            ENB_I = 1;
            @(posedge aclk);
            #1 ENB_I = 0;
            RD_PNTR = 8'h20;
            ENA_I = 1;
            @(posedge aclk);
            #2;

            #1;


            check_outputs(32'h1111_2222, 0);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            $display("Running testcase004: Delayed Enable Check...");


            @(posedge aclk);
            ENB_I = 1;
            WR_PNTR = 8'h00;


            @(posedge aclk);
            #2;


            #1;



            check_outputs(D, 1);
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
        input [31:0] expected_D;
        input expected_ENB_dly_D;
        begin
            if (expected_D === (expected_D ^ D ^ expected_D) &&
                expected_ENB_dly_D === (expected_ENB_dly_D ^ ENB_dly_D ^ expected_ENB_dly_D)) begin
                $display("PASS");
                $display("  Outputs: D=%h, ENB_dly_D=%b",
                         D, ENB_dly_D);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: D=%h, ENB_dly_D=%b",
                         expected_D, expected_ENB_dly_D);
                $display("  Got:      D=%h, ENB_dly_D=%b",
                         D, ENB_dly_D);
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
        $dumpvars(0,ENA_I, ENB_I, POR_A, RD_PNTR, WR_PNTR, aclk, p_20_out, rx_fifo_data_o_reg, s_dclk_o, D, ENB_dly_D);
    end

endmodule
