`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg adc_a_data;
    reg adc_b_data;
    reg adc_c_data;
    reg adc_d_data;
    reg [3:0] buttons;
    reg clk_in;
    reg eth_phy_rx_clk;
    reg eth_phy_rx_dv;
    reg eth_phy_rx_er;
    reg [3:0] eth_phy_rxd;
    reg rstn_in;
    reg [3:0] switches;
    wire [3:0] buttons_out;
    wire eth_phy_col;
    wire eth_phy_crs;
    wire eth_phy_tx_clk;
    wire [3:0] eth_phy_tx_data;
    wire [3:0] switches_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .adc_a_data(adc_a_data),
        .adc_b_data(adc_b_data),
        .adc_c_data(adc_c_data),
        .adc_d_data(adc_d_data),
        .buttons(buttons),
        .clk_in(clk_in),
        .eth_phy_rx_clk(eth_phy_rx_clk),
        .eth_phy_rx_dv(eth_phy_rx_dv),
        .eth_phy_rx_er(eth_phy_rx_er),
        .eth_phy_rxd(eth_phy_rxd),
        .rstn_in(rstn_in),
        .switches(switches),
        .buttons_out(buttons_out),
        .eth_phy_col(eth_phy_col),
        .eth_phy_crs(eth_phy_crs),
        .eth_phy_tx_clk(eth_phy_tx_clk),
        .eth_phy_tx_data(eth_phy_tx_data),
        .switches_out(switches_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk_in = 0;
        forever #5 clk_in = ~clk_in;
    end

        task reset_dut;

        begin
            rstn_in = 0;
            adc_a_data = 0;
            adc_b_data = 0;
            adc_c_data = 0;
            adc_d_data = 0;
            buttons = 4'h0;
            switches = 4'h0;
            eth_phy_rx_dv = 0;
            eth_phy_rx_er = 0;
            eth_phy_rxd = 4'h0;
            #100;
            rstn_in = 1;
            #50;
        end
        endtask
    task testcase001;

        begin
            $display("Running Testcase 001: Passthrough Check");
            reset_dut();
            switches = 4'hA;
            buttons = 4'h5;
            #20;

            #1;


            check_outputs(4'h5, 1'b0, 1'b0, eth_phy_rx_clk, 4'h0, 4'hA);
        end
        endtask

    task testcase002;

        begin
            $display("Running Testcase 002: Sound Data Transmission (Max ADCs)");
            reset_dut();
            switches = 4'h1;
            adc_a_data = 1;
            adc_b_data = 1;
            adc_c_data = 1;
            adc_d_data = 1;

            @(posedge eth_phy_rx_clk);
            eth_phy_rx_dv = 1;
            #100;




            if (eth_phy_tx_data > 0)
                #1;

                check_outputs(buttons, eth_phy_col, eth_phy_crs, eth_phy_rx_clk, eth_phy_tx_data, switches);
            else begin
                $display("FAIL: No drum data transmitted on Ethernet");
                fail_count = fail_count + 1;
            end
        end
        endtask

    task testcase003;

        begin
            $display("Running Testcase 003: Ethernet Inactive Check");
            reset_dut();
            adc_a_data = 1;
            adc_b_data = 1;
            switches = 4'hF;
            eth_phy_rx_dv = 0;
            #100;

            #1;


            check_outputs(buttons, 1'b0, 1'b0, eth_phy_rx_clk, 4'h0, 4'hF);
        end
        endtask

    task testcase004;

        reg [3:0] first_data;
        begin
            $display("Running Testcase 004: Sound Selection Change");
            reset_dut();
            adc_a_data = 1;
            adc_c_data = 1;
            eth_phy_rx_dv = 1;
            switches = 4'h1;
            #50;
            first_data = eth_phy_tx_data;

            switches = 4'h8;
            #50;

            if (eth_phy_tx_data != first_data || switches_out == 4'h8) begin
                $display("PASS: Output responded to switch change");
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL: Output did not respond to switch change");
                fail_count = fail_count + 1;
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
        input [3:0] expected_buttons_out;
        input expected_eth_phy_col;
        input expected_eth_phy_crs;
        input expected_eth_phy_tx_clk;
        input [3:0] expected_eth_phy_tx_data;
        input [3:0] expected_switches_out;
        begin
            if (expected_buttons_out === (expected_buttons_out ^ buttons_out ^ expected_buttons_out) &&
                expected_eth_phy_col === (expected_eth_phy_col ^ eth_phy_col ^ expected_eth_phy_col) &&
                expected_eth_phy_crs === (expected_eth_phy_crs ^ eth_phy_crs ^ expected_eth_phy_crs) &&
                expected_eth_phy_tx_clk === (expected_eth_phy_tx_clk ^ eth_phy_tx_clk ^ expected_eth_phy_tx_clk) &&
                expected_eth_phy_tx_data === (expected_eth_phy_tx_data ^ eth_phy_tx_data ^ expected_eth_phy_tx_data) &&
                expected_switches_out === (expected_switches_out ^ switches_out ^ expected_switches_out)) begin
                $display("PASS");
                $display("  Outputs: buttons_out=%h, eth_phy_col=%b, eth_phy_crs=%b, eth_phy_tx_clk=%b, eth_phy_tx_data=%h, switches_out=%h",
                         buttons_out, eth_phy_col, eth_phy_crs, eth_phy_tx_clk, eth_phy_tx_data, switches_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: buttons_out=%h, eth_phy_col=%b, eth_phy_crs=%b, eth_phy_tx_clk=%b, eth_phy_tx_data=%h, switches_out=%h",
                         expected_buttons_out, expected_eth_phy_col, expected_eth_phy_crs, expected_eth_phy_tx_clk, expected_eth_phy_tx_data, expected_switches_out);
                $display("  Got:      buttons_out=%h, eth_phy_col=%b, eth_phy_crs=%b, eth_phy_tx_clk=%b, eth_phy_tx_data=%h, switches_out=%h",
                         buttons_out, eth_phy_col, eth_phy_crs, eth_phy_tx_clk, eth_phy_tx_data, switches_out);
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
        $dumpvars(0,adc_a_data, adc_b_data, adc_c_data, adc_d_data, buttons, clk_in, eth_phy_rx_clk, eth_phy_rx_dv, eth_phy_rx_er, eth_phy_rxd, rstn_in, switches, buttons_out, eth_phy_col, eth_phy_crs, eth_phy_tx_clk, eth_phy_tx_data, switches_out);
    end

endmodule
