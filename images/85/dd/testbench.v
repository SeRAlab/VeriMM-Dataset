`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg button0;
    reg button1;
    reg clk;
    reg hdmi_i2c_data_in;
    reg hdmi_tx_int;
    reg reset_n;
    reg scl_in;
    reg sda_in;
    reg uart_rxd;
    wire hdmi_i2c_clk;
    wire hdmi_i2c_data_out;
    wire [23:0] hdmi_tdx;
    wire hdmi_tx_clk;
    wire hdmi_tx_data_en;
    wire hdmi_tx_de;
    wire hdmi_tx_hsync;
    wire hdmi_tx_vsync;
    wire [7:0] led;
    wire scl_out;
    wire sda_out;
    wire uart_txd;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .button0(button0),
        .button1(button1),
        .clk(clk),
        .hdmi_i2c_data_in(hdmi_i2c_data_in),
        .hdmi_tx_int(hdmi_tx_int),
        .reset_n(reset_n),
        .scl_in(scl_in),
        .sda_in(sda_in),
        .uart_rxd(uart_rxd),
        .hdmi_i2c_clk(hdmi_i2c_clk),
        .hdmi_i2c_data_out(hdmi_i2c_data_out),
        .hdmi_tdx(hdmi_tdx),
        .hdmi_tx_clk(hdmi_tx_clk),
        .hdmi_tx_data_en(hdmi_tx_data_en),
        .hdmi_tx_de(hdmi_tx_de),
        .hdmi_tx_hsync(hdmi_tx_hsync),
        .hdmi_tx_vsync(hdmi_tx_vsync),
        .led(led),
        .scl_out(scl_out),
        .sda_out(sda_out),
        .uart_txd(uart_txd)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("\nTestcase %0d: System Reset", test_num);


            reset_n = 0;
            button0 = 0;
            button1 = 0;
            hdmi_i2c_data_in = 0;
            hdmi_tx_int = 0;
            scl_in = 0;
            sda_in = 0;
            uart_rxd = 1;

            #100;


            #1;



            check_outputs(
                1'b0,
                1'b0,
                24'h0,
                1'b0,
                1'b0,
                1'b0,
                1'b0,
                1'b0,
                8'h00,
                1'b0,
                1'b0,
                1'b1
            );
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTestcase %0d: Reset Release/Idle state", test_num);


            reset_n = 0; #20;
            reset_n = 1;


            #200;


            #1;



            check_outputs(
                1'b0, 1'b0, 24'h0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 8'h00, 1'b0, 1'b0, 1'b1
            );
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTestcase %0d: Button Interaction", test_num);

            reset_n = 0; #20;
            reset_n = 1; #20;

            button0 = 1;
            button1 = 1;
            #50;




            #1;





            check_outputs(
                1'b0, 1'b0, 24'h0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 8'h00, 1'b0, 1'b0, 1'b1
            );
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTestcase %0d: Serial Input Activity", test_num);

            reset_n = 0; #20;
            reset_n = 1; #20;


            uart_rxd = 0; #40;
            scl_in = 1;
            sda_in = 1;
            #100;

            #1;


            check_outputs(
                1'b0, 1'b0, 24'h0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 8'h00, 1'b0, 1'b0, 1'b0
            );
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nTestcase %0d: HDMI Interrupt Test", test_num);

            reset_n = 0; #20;
            reset_n = 1; #20;

            hdmi_tx_int = 1;
            #100;

            #1;


            check_outputs(
                1'b0, 1'b0, 24'h0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 8'h00, 1'b0, 1'b0, 1'b1
            );
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
        input expected_hdmi_i2c_clk;
        input expected_hdmi_i2c_data_out;
        input [23:0] expected_hdmi_tdx;
        input expected_hdmi_tx_clk;
        input expected_hdmi_tx_data_en;
        input expected_hdmi_tx_de;
        input expected_hdmi_tx_hsync;
        input expected_hdmi_tx_vsync;
        input [7:0] expected_led;
        input expected_scl_out;
        input expected_sda_out;
        input expected_uart_txd;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_hdmi_i2c_clk === (expected_hdmi_i2c_clk ^ hdmi_i2c_clk ^ expected_hdmi_i2c_clk) &&
                expected_hdmi_i2c_data_out === (expected_hdmi_i2c_data_out ^ hdmi_i2c_data_out ^ expected_hdmi_i2c_data_out) &&
                expected_hdmi_tdx === (expected_hdmi_tdx ^ hdmi_tdx ^ expected_hdmi_tdx) &&
                expected_hdmi_tx_clk === (expected_hdmi_tx_clk ^ hdmi_tx_clk ^ expected_hdmi_tx_clk) &&
                expected_hdmi_tx_data_en === (expected_hdmi_tx_data_en ^ hdmi_tx_data_en ^ expected_hdmi_tx_data_en) &&
                expected_hdmi_tx_de === (expected_hdmi_tx_de ^ hdmi_tx_de ^ expected_hdmi_tx_de) &&
                expected_hdmi_tx_hsync === (expected_hdmi_tx_hsync ^ hdmi_tx_hsync ^ expected_hdmi_tx_hsync) &&
                expected_hdmi_tx_vsync === (expected_hdmi_tx_vsync ^ hdmi_tx_vsync ^ expected_hdmi_tx_vsync) &&
                expected_led === (expected_led ^ led ^ expected_led) &&
                expected_scl_out === (expected_scl_out ^ scl_out ^ expected_scl_out) &&
                expected_sda_out === (expected_sda_out ^ sda_out ^ expected_sda_out) &&
                expected_uart_txd === (expected_uart_txd ^ uart_txd ^ expected_uart_txd)) begin
                $display("PASS");
                $display("  Outputs: hdmi_i2c_clk=%b, hdmi_i2c_data_out=%b, hdmi_tdx=%h, hdmi_tx_clk=%b, hdmi_tx_data_en=%b, hdmi_tx_de=%b, hdmi_tx_hsync=%b, hdmi_tx_vsync=%b, led=%h, scl_out=%b, sda_out=%b, uart_txd=%b",
                         hdmi_i2c_clk, hdmi_i2c_data_out, hdmi_tdx, hdmi_tx_clk, hdmi_tx_data_en, hdmi_tx_de, hdmi_tx_hsync, hdmi_tx_vsync, led, scl_out, sda_out, uart_txd);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: hdmi_i2c_clk=%b, hdmi_i2c_data_out=%b, hdmi_tdx=%h, hdmi_tx_clk=%b, hdmi_tx_data_en=%b, hdmi_tx_de=%b, hdmi_tx_hsync=%b, hdmi_tx_vsync=%b, led=%h, scl_out=%b, sda_out=%b, uart_txd=%b",
                         expected_hdmi_i2c_clk, expected_hdmi_i2c_data_out, expected_hdmi_tdx, expected_hdmi_tx_clk, expected_hdmi_tx_data_en, expected_hdmi_tx_de, expected_hdmi_tx_hsync, expected_hdmi_tx_vsync, expected_led, expected_scl_out, expected_sda_out, expected_uart_txd);
                $display("  Got:      hdmi_i2c_clk=%b, hdmi_i2c_data_out=%b, hdmi_tdx=%h, hdmi_tx_clk=%b, hdmi_tx_data_en=%b, hdmi_tx_de=%b, hdmi_tx_hsync=%b, hdmi_tx_vsync=%b, led=%h, scl_out=%b, sda_out=%b, uart_txd=%b",
                         hdmi_i2c_clk, hdmi_i2c_data_out, hdmi_tdx, hdmi_tx_clk, hdmi_tx_data_en, hdmi_tx_de, hdmi_tx_hsync, hdmi_tx_vsync, led, scl_out, sda_out, uart_txd);
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
