`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [15:0] flash_data_;
    reg [15:0] wb_adr_i;
    reg wb_clk_i;
    reg wb_cyc_i;
    reg [15:0] wb_dat_i;
    reg wb_rst_i;
    reg wb_stb_i;
    reg wb_tga_i;
    reg wb_we_i;
    wire [20:0] flash_addr_;
    wire flash_ce2_;
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
        .wb_stb_i(wb_stb_i),
        .wb_tga_i(wb_tga_i),
        .wb_we_i(wb_we_i),
        .flash_addr_(flash_addr_),
        .flash_ce2_(flash_ce2_),
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
            wb_adr_i = 16'h0;
            wb_dat_i = 16'h0;
            wb_tga_i = 1'b0;
            flash_data_ = 16'h0;
            repeat(2) @(posedge wb_clk_i);
            wb_rst_i = 0;
            repeat(2) @(posedge wb_clk_i);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Running Testcase%03d: Reset and Idle Check", test_num);
            reset_dut();
            #1;

            #1;


            check_outputs(flash_addr_, 1'b0, 1'b1, 1'b0, wb_dat_o);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Running Testcase%03d: Basic Read Operation", test_num);
            reset_dut();

            wb_adr_i = 16'h1234;
            wb_tga_i = 1'b0;
            flash_data_ = 16'hABCD;
            wb_cyc_i = 1;
            wb_stb_i = 1;
            wb_we_i = 0;

            @(posedge wb_clk_i);
            while (wb_ack_o !== 1'b1) @(posedge wb_clk_i);

            #1;

            #1;


            check_outputs(21'h01234, 1'b1, 1'b1, 1'b1, 16'hABCD);

            wb_cyc_i = 0;
            wb_stb_i = 0;
            @(posedge wb_clk_i);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Running Testcase%03d: Basic Write Operation", test_num);
            reset_dut();

            wb_adr_i = 16'hAAAA;
            wb_tga_i = 1'b0;
            wb_dat_i = 16'h5555;
            flash_data_ = 16'h0;
            wb_cyc_i = 1;
            wb_stb_i = 1;
            wb_we_i = 1;

            @(posedge wb_clk_i);
            while (wb_ack_o !== 1'b1) @(posedge wb_clk_i);

            #1;

            #1;


            check_outputs(21'h0AAAA, 1'b1, 1'b0, 1'b1, 16'h0000);

            wb_cyc_i = 0;
            wb_stb_i = 0;
            @(posedge wb_clk_i);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Running Testcase%03d: Address Expansion via TGA", test_num);
            reset_dut();

            wb_adr_i = 16'h5555;
            wb_tga_i = 1'b1;
            flash_data_ = 16'hFFFF;
            wb_cyc_i = 1;
            wb_stb_i = 1;
            wb_we_i = 0;

            @(posedge wb_clk_i);
            while (wb_ack_o !== 1'b1) @(posedge wb_clk_i);

            #1;

            #1;


            check_outputs(21'h15555, 1'b1, 1'b1, 1'b1, 16'hFFFF);

            wb_cyc_i = 0;
            wb_stb_i = 0;
            @(posedge wb_clk_i);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Running Testcase%03d: Full Address Range Check", test_num);
            reset_dut();

            wb_adr_i = 16'hFFFF;
            wb_tga_i = 1'b1;
            flash_data_ = 16'h0000;
            wb_cyc_i = 1;
            wb_stb_i = 1;
            wb_we_i = 0;

            @(posedge wb_clk_i);
            while (wb_ack_o !== 1'b1) @(posedge wb_clk_i);

            #1;

            #1;


            check_outputs(21'h1FFFF, 1'b1, 1'b1, 1'b1, 16'h0000);

            wb_cyc_i = 0;
            wb_stb_i = 0;
            @(posedge wb_clk_i);
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
        input [20:0] expected_flash_addr_;
        input expected_flash_ce2_;
        input expected_flash_we_n_;
        input expected_wb_ack_o;
        input [15:0] expected_wb_dat_o;
        begin
            if (expected_flash_addr_ === (expected_flash_addr_ ^ flash_addr_ ^ expected_flash_addr_) &&
                expected_flash_ce2_ === (expected_flash_ce2_ ^ flash_ce2_ ^ expected_flash_ce2_) &&
                expected_flash_we_n_ === (expected_flash_we_n_ ^ flash_we_n_ ^ expected_flash_we_n_) &&
                expected_wb_ack_o === (expected_wb_ack_o ^ wb_ack_o ^ expected_wb_ack_o) &&
                expected_wb_dat_o === (expected_wb_dat_o ^ wb_dat_o ^ expected_wb_dat_o)) begin
                $display("PASS");
                $display("  Outputs: flash_addr_=%h, flash_ce2_=%b, flash_we_n_=%b, wb_ack_o=%b, wb_dat_o=%h",
                         flash_addr_, flash_ce2_, flash_we_n_, wb_ack_o, wb_dat_o);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: flash_addr_=%h, flash_ce2_=%b, flash_we_n_=%b, wb_ack_o=%b, wb_dat_o=%h",
                         expected_flash_addr_, expected_flash_ce2_, expected_flash_we_n_, expected_wb_ack_o, expected_wb_dat_o);
                $display("  Got:      flash_addr_=%h, flash_ce2_=%b, flash_we_n_=%b, wb_ack_o=%b, wb_dat_o=%h",
                         flash_addr_, flash_ce2_, flash_we_n_, wb_ack_o, wb_dat_o);
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
        $dumpvars(0,flash_data_, wb_adr_i, wb_clk_i, wb_cyc_i, wb_dat_i, wb_rst_i, wb_stb_i, wb_tga_i, wb_we_i, flash_addr_, flash_ce2_, flash_we_n_, wb_ack_o, wb_dat_o);
    end

endmodule
