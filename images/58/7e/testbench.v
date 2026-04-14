`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] flash_data_;
    reg wb_adr_i;
    reg wb_clk_i;
    reg wb_cyc_i;
    reg [15:0] wb_dat_i;
    reg wb_rst_i;
    reg [1:0] wb_sel_i;
    reg wb_stb_i;
    reg wb_we_i;
    wire [21:0] flash_addr_;
    wire flash_ce_n_;
    wire flash_oe_n_;
    wire flash_rst_n_;
    wire flash_we_n_;
    wire wb_ack_o;
    wire [15:0] wb_dat_o;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .flash_data_(flash_data_),
        .wb_adr_i(wb_adr_i),
        .wb_clk_i(wb_clk_i),
        .wb_cyc_i(wb_cyc_i),
        .wb_dat_i(wb_dat_i),
        .wb_rst_i(wb_rst_i),
        .wb_sel_i(wb_sel_i),
        .wb_stb_i(wb_stb_i),
        .wb_we_i(wb_we_i),
        .flash_addr_(flash_addr_),
        .flash_ce_n_(flash_ce_n_),
        .flash_oe_n_(flash_oe_n_),
        .flash_rst_n_(flash_rst_n_),
        .flash_we_n_(flash_we_n_),
        .wb_ack_o(wb_ack_o),
        .wb_dat_o(wb_dat_o)
    );

    // Clock generation (10ns period)
    initial begin
        wb_clk_i = 0;
        forever #5 wb_clk_i = ~wb_clk_i;
    end

        task reset_dut;

    begin
        wb_rst_i = 1;
        wb_cyc_i = 0;
        wb_stb_i = 0;
        wb_we_i = 0;
        wb_adr_i = 0;
        wb_dat_i = 0;
        wb_sel_i = 0;
        flash_data_ = 8'hzz;
        #20;
        wb_rst_i = 0;
        #10;
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("\nTestcase %03d: Reset State Verification", test_num);
        reset_dut();


        #1;



        check_outputs(22'h0, 1'b1, 1'b1, 1'b1, 1'b1, 1'b0, 16'h0000);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("\nTestcase %03d: Write Lower Address Bits", test_num);
        reset_dut();
        @(posedge wb_clk_i);
        wb_adr_i = 1'b0;
        wb_dat_i = 16'hABCD;
        wb_we_i = 1'b1;
        wb_sel_i = 2'b11;
        wb_cyc_i = 1'b1;
        wb_stb_i = 1'b1;


        wait(wb_ack_o);
        @(posedge wb_clk_i);
        wb_cyc_i = 1'b0;
        wb_stb_i = 1'b0;


        #1;



        check_outputs(22'h00ABCD, 1'b1, 1'b1, 1'b1, 1'b1, 1'b0, 16'h0000);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("\nTestcase %03d: Write Upper Address Bits", test_num);
        reset_dut();


        @(posedge wb_clk_i);
        wb_adr_i = 1'b0; wb_dat_i = 16'h1234; wb_we_i = 1'b1; wb_sel_i = 2'b11; wb_cyc_i = 1'b1; wb_stb_i = 1'b1;
        wait(wb_ack_o);
        @(posedge wb_clk_i);
        wb_cyc_i = 0; wb_stb_i = 0;


        @(posedge wb_clk_i);
        wb_adr_i = 1'b1; wb_dat_i = 16'h003F; wb_we_i = 1'b1; wb_sel_i = 2'b11; wb_cyc_i = 1'b1; wb_stb_i = 1'b1;
        wait(wb_ack_o);
        @(posedge wb_clk_i);
        wb_cyc_i = 0; wb_stb_i = 0;


        #1;



        check_outputs(22'h3F1234, 1'b1, 1'b1, 1'b1, 1'b1, 1'b0, 16'h0000);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("\nTestcase %03d: Flash Read Operation", test_num);
        reset_dut();


        @(posedge wb_clk_i);
        wb_adr_i = 0; wb_dat_i = 16'h0005; wb_we_i = 1; wb_cyc_i = 1; wb_stb_i = 1;
        wait(wb_ack_o);
        @(posedge wb_clk_i);
        wb_cyc_i = 0; wb_stb_i = 0;


        @(posedge wb_clk_i);
        wb_adr_i = 1; wb_we_i = 0; wb_cyc_i = 1; wb_stb_i = 1;
        flash_data_ = 8'hA5;

        wait(wb_ack_o);

        #1;


        check_outputs(22'h000005, 1'b0, 1'b0, 1'b1, 1'b1, 1'b1, 16'h00A5);

        @(posedge wb_clk_i);
        wb_cyc_i = 0; wb_stb_i = 0;
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("\nTestcase %03d: Flash Write Operation", test_num);
        reset_dut();


        @(posedge wb_clk_i);
        wb_adr_i = 0; wb_dat_i = 16'h0100; wb_we_i = 1; wb_cyc_i = 1; wb_stb_i = 1;
        wait(wb_ack_o);
        @(posedge wb_clk_i);
        wb_cyc_i = 0; wb_stb_i = 0;


        @(posedge wb_clk_i);
        wb_adr_i = 1; wb_we_i = 1; wb_dat_i = 16'h0055; wb_cyc_i = 1; wb_stb_i = 1;

        wait(wb_ack_o);

        #1;


        check_outputs(22'h000100, 1'b0, 1'b1, 1'b1, 1'b0, 1'b1, 16'h0000);

        @(posedge wb_clk_i);
        wb_cyc_i = 0; wb_stb_i = 0;
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
        input [21:0] expected_flash_addr_;
        input expected_flash_ce_n_;
        input expected_flash_oe_n_;
        input expected_flash_rst_n_;
        input expected_flash_we_n_;
        input expected_wb_ack_o;
        input [15:0] expected_wb_dat_o;
        begin
            if (expected_flash_addr_ === (expected_flash_addr_ ^ flash_addr_ ^ expected_flash_addr_) &&
                expected_flash_ce_n_ === (expected_flash_ce_n_ ^ flash_ce_n_ ^ expected_flash_ce_n_) &&
                expected_flash_oe_n_ === (expected_flash_oe_n_ ^ flash_oe_n_ ^ expected_flash_oe_n_) &&
                expected_flash_rst_n_ === (expected_flash_rst_n_ ^ flash_rst_n_ ^ expected_flash_rst_n_) &&
                expected_flash_we_n_ === (expected_flash_we_n_ ^ flash_we_n_ ^ expected_flash_we_n_) &&
                expected_wb_ack_o === (expected_wb_ack_o ^ wb_ack_o ^ expected_wb_ack_o) &&
                expected_wb_dat_o === (expected_wb_dat_o ^ wb_dat_o ^ expected_wb_dat_o)) begin
                $display("PASS");
                $display("  Outputs: flash_addr_=%h, flash_ce_n_=%b, flash_oe_n_=%b, flash_rst_n_=%b, flash_we_n_=%b, wb_ack_o=%b, wb_dat_o=%h",
                         flash_addr_, flash_ce_n_, flash_oe_n_, flash_rst_n_, flash_we_n_, wb_ack_o, wb_dat_o);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: flash_addr_=%h, flash_ce_n_=%b, flash_oe_n_=%b, flash_rst_n_=%b, flash_we_n_=%b, wb_ack_o=%b, wb_dat_o=%h",
                         expected_flash_addr_, expected_flash_ce_n_, expected_flash_oe_n_, expected_flash_rst_n_, expected_flash_we_n_, expected_wb_ack_o, expected_wb_dat_o);
                $display("  Got:      flash_addr_=%h, flash_ce_n_=%b, flash_oe_n_=%b, flash_rst_n_=%b, flash_we_n_=%b, wb_ack_o=%b, wb_dat_o=%h",
                         flash_addr_, flash_ce_n_, flash_oe_n_, flash_rst_n_, flash_we_n_, wb_ack_o, wb_dat_o);
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
        $dumpvars(0,flash_data_, wb_adr_i, wb_clk_i, wb_cyc_i, wb_dat_i, wb_rst_i, wb_sel_i, wb_stb_i, wb_we_i, flash_addr_, flash_ce_n_, flash_oe_n_, flash_rst_n_, flash_we_n_, wb_ack_o, wb_dat_o);
    end

endmodule
