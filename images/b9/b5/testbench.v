`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg SR;
    reg [6:0] Tx_fifo_data;
    reg abgc_i_reg;
    reg [3:0] out;
    reg s_axi_aclk;
    reg shift_reg_en;
    reg shift_reg_ld_reg;
    reg shift_reg_ld_reg_0;
    reg tx_under_prev_i_reg;
    reg txak;
    wire [7:0] Q;
    wire master_sda_reg;
    wire slave_sda_reg;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .SR(SR),
        .Tx_fifo_data(Tx_fifo_data),
        .abgc_i_reg(abgc_i_reg),
        .out(out),
        .s_axi_aclk(s_axi_aclk),
        .shift_reg_en(shift_reg_en),
        .shift_reg_ld_reg(shift_reg_ld_reg),
        .shift_reg_ld_reg_0(shift_reg_ld_reg_0),
        .tx_under_prev_i_reg(tx_under_prev_i_reg),
        .txak(txak),
        .Q(Q),
        .master_sda_reg(master_sda_reg),
        .slave_sda_reg(slave_sda_reg)
    );

    // Clock generation (10ns period)
    initial begin
        s_axi_aclk = 0;
        forever #5 s_axi_aclk = ~s_axi_aclk;
    end

        task reset_dut;

        begin
            SR = 1;
            Tx_fifo_data = 0;
            abgc_i_reg = 0;
            out = 0;
            shift_reg_en = 0;
            shift_reg_ld_reg = 0;
            shift_reg_ld_reg_0 = 0;
            tx_under_prev_i_reg = 0;
            txak = 0;
            @(posedge s_axi_aclk);
            #1;
            SR = 0;
            @(posedge s_axi_aclk);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("Running testcase001: Reset Check");
            reset_dut();

            #1;


            check_outputs(8'hff, 1'b1, 1'b1);
        end
        endtask

    task testcase002;

        begin
            $display("Running testcase002: Load Data");
            reset_dut();
            Tx_fifo_data = 7'h55;
            txak = 1'b0;
            shift_reg_ld_reg = 1;
            @(posedge s_axi_aclk);
            #1;
            shift_reg_ld_reg = 0;


            #1;



            check_outputs(8'haa, 1'b1, 1'b1);
        end
        endtask

    task testcase003;

        begin
            $display("Running testcase003: Shift Data");
            reset_dut();
            Tx_fifo_data = 7'h45;
            txak = 1'b1;
            shift_reg_ld_reg = 1;
            @(posedge s_axi_aclk);
            #1;
            shift_reg_ld_reg = 0;
            shift_reg_en = 1;
            @(posedge s_axi_aclk);
            #1;
            shift_reg_en = 0;



            #1;




            check_outputs(8'h17, 1'b0, 1'b0);
        end
        endtask

    task testcase004;

        begin
            $display("Running testcase004: Multiple Shifts SDA Check");
            reset_dut();
            Tx_fifo_data = 7'h60;
            txak = 1'b0;
            shift_reg_ld_reg = 1;
            @(posedge s_axi_aclk);
            #1;
            shift_reg_ld_reg = 0;
            shift_reg_en = 1;
            @(posedge s_axi_aclk);
            #1;
            @(posedge s_axi_aclk);
            #1;
            shift_reg_en = 0;




            #1;





            check_outputs(8'h03, 1'b0, 1'b0);
        end
        endtask

    task testcase005;

        begin
            $display("Running testcase005: Secondary Load Check");
            reset_dut();
            shift_reg_ld_reg_0 = 1;
            @(posedge s_axi_aclk);
            #1;
            shift_reg_ld_reg_0 = 0;


            #1;



            check_outputs(8'hff, 1'b1, 1'b1);
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
        input expected_master_sda_reg;
        input expected_slave_sda_reg;
        begin
            if (expected_Q === (expected_Q ^ Q ^ expected_Q) &&
                expected_master_sda_reg === (expected_master_sda_reg ^ master_sda_reg ^ expected_master_sda_reg) &&
                expected_slave_sda_reg === (expected_slave_sda_reg ^ slave_sda_reg ^ expected_slave_sda_reg)) begin
                $display("PASS");
                $display("  Outputs: Q=%h, master_sda_reg=%b, slave_sda_reg=%b",
                         Q, master_sda_reg, slave_sda_reg);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Q=%h, master_sda_reg=%b, slave_sda_reg=%b",
                         expected_Q, expected_master_sda_reg, expected_slave_sda_reg);
                $display("  Got:      Q=%h, master_sda_reg=%b, slave_sda_reg=%b",
                         Q, master_sda_reg, slave_sda_reg);
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
        $dumpvars(0,SR, Tx_fifo_data, abgc_i_reg, out, s_axi_aclk, shift_reg_en, shift_reg_ld_reg, shift_reg_ld_reg_0, tx_under_prev_i_reg, txak, Q, master_sda_reg, slave_sda_reg);
    end

endmodule
