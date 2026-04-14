`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk_i;
    reg [31:0] reg_data_i;
    reg reg_load_i;
    reg [1:0] reg_sel_i;
    reg reset_n_i;
    reg rx_empty_i;
    reg spi_busy_i;
    reg trans_start_i;
    reg tx_full_i;
    wire [31:0] reg_control_o;
    wire [31:0] reg_status_o;
    wire [31:0] reg_trans_ctrl_o;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk_i(clk_i),
        .reg_data_i(reg_data_i),
        .reg_load_i(reg_load_i),
        .reg_sel_i(reg_sel_i),
        .reset_n_i(reset_n_i),
        .rx_empty_i(rx_empty_i),
        .spi_busy_i(spi_busy_i),
        .trans_start_i(trans_start_i),
        .tx_full_i(tx_full_i),
        .reg_control_o(reg_control_o),
        .reg_status_o(reg_status_o),
        .reg_trans_ctrl_o(reg_trans_ctrl_o)
    );

    // Clock generation (10ns period)
    initial begin
        clk_i = 0;
        forever #5 clk_i = ~clk_i;
    end

        task reset_dut;

        begin
            reset_n_i = 0;
            reg_data_i = 0;
            reg_load_i = 0;
            reg_sel_i = 0;
            spi_busy_i = 0;
            trans_start_i = 0;
            rx_empty_i = 0;
            tx_full_i = 0;
            @(posedge clk_i);
            #1;
            reset_n_i = 1;
            @(posedge clk_i);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %03d: System Reset Verification", test_num);
            reset_dut();


            #1;



            check_outputs(32'h0, 32'h0, 32'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %03d: Load Control Register", test_num);
            reset_dut();
            reg_sel_i = 2'b00;
            reg_data_i = 32'hA5A5_5A5A;
            reg_load_i = 1;
            @(posedge clk_i);
            #1;
            reg_load_i = 0;
            @(posedge clk_i);
            #1;
            #1;

            check_outputs(32'hA5A5_5A5A, 32'h0, 32'h0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %03d: Load Transaction Control Register", test_num);
            reset_dut();
            reg_sel_i = 2'b01;
            reg_data_i = 32'h1234_5678;
            reg_load_i = 1;
            @(posedge clk_i);
            #1;
            reg_load_i = 0;
            @(posedge clk_i);
            #1;

            #1;


            check_outputs(32'h0, 32'h0, 32'h1234_5678);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %03d: Status Register Flags Reflection", test_num);
            reset_dut();

            spi_busy_i = 1;
            rx_empty_i = 1;
            tx_full_i = 1;
            @(posedge clk_i);
            #1;

            #1;


            check_outputs(32'h0, 32'h0000_0007, 32'h0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %03d: Combined Register Writes and Transaction Start", test_num);
            reset_dut();


            reg_sel_i = 2'b00;
            reg_data_i = 32'hFFFF_0000;
            reg_load_i = 1;
            @(posedge clk_i);
            #1;


            reg_sel_i = 2'b01;
            reg_data_i = 32'h0000_FFFF;
            trans_start_i = 1;
            @(posedge clk_i);
            #1;
            reg_load_i = 0;


            spi_busy_i = 1;
            @(posedge clk_i);
            #1;



            #1;




            check_outputs(32'hFFFF_0000, 32'h0000_0001, 32'h0000_FFFF);
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
        input [31:0] expected_reg_control_o;
        input [31:0] expected_reg_status_o;
        input [31:0] expected_reg_trans_ctrl_o;
        begin
            if (expected_reg_control_o === (expected_reg_control_o ^ reg_control_o ^ expected_reg_control_o) &&
                expected_reg_status_o === (expected_reg_status_o ^ reg_status_o ^ expected_reg_status_o) &&
                expected_reg_trans_ctrl_o === (expected_reg_trans_ctrl_o ^ reg_trans_ctrl_o ^ expected_reg_trans_ctrl_o)) begin
                $display("PASS");
                $display("  Outputs: reg_control_o=%h, reg_status_o=%h, reg_trans_ctrl_o=%h",
                         reg_control_o, reg_status_o, reg_trans_ctrl_o);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: reg_control_o=%h, reg_status_o=%h, reg_trans_ctrl_o=%h",
                         expected_reg_control_o, expected_reg_status_o, expected_reg_trans_ctrl_o);
                $display("  Got:      reg_control_o=%h, reg_status_o=%h, reg_trans_ctrl_o=%h",
                         reg_control_o, reg_status_o, reg_trans_ctrl_o);
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
        $dumpvars(0,clk_i, reg_data_i, reg_load_i, reg_sel_i, reset_n_i, rx_empty_i, spi_busy_i, trans_start_i, tx_full_i, reg_control_o, reg_status_o, reg_trans_ctrl_o);
    end

endmodule
