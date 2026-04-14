`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [18:0] wb_adr_i;
    reg wb_clk_i;
    reg wb_cyc_i;
    reg [15:0] wb_dat_i;
    reg wb_rst_i;
    reg [1:0] wb_sel_i;
    reg wb_stb_i;
    reg wb_we_i;
    wire [20:0] sram_addr_;
    wire sram_adv_ld_n_;
    wire [3:0] sram_bw_;
    wire sram_cen_;
    wire sram_clk_;
    wire sram_we_n_;
    wire wb_ack_o;
    wire [15:0] wb_dat_o;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .wb_adr_i(wb_adr_i),
        .wb_clk_i(wb_clk_i),
        .wb_cyc_i(wb_cyc_i),
        .wb_dat_i(wb_dat_i),
        .wb_rst_i(wb_rst_i),
        .wb_sel_i(wb_sel_i),
        .wb_stb_i(wb_stb_i),
        .wb_we_i(wb_we_i),
        .sram_addr_(sram_addr_),
        .sram_adv_ld_n_(sram_adv_ld_n_),
        .sram_bw_(sram_bw_),
        .sram_cen_(sram_cen_),
        .sram_clk_(sram_clk_),
        .sram_we_n_(sram_we_n_),
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
            sram_data_en = 0;
            sram_data_drive = 0;
            repeat (5) @(posedge wb_clk_i);
            #1 wb_rst_i = 0;
            repeat (2) @(posedge wb_clk_i);
        end
        endtask
    task testcase001;

        begin
            $display("Running testcase001: Idle State Check");
            test_num = test_num + 1;
            reset_dut();



            #1;




            check_outputs(
                21'b0,
                1'b1,
                4'hf,
                1'b1,
                1'b1,
                1'b1,
                1'b0,
                16'h0
            );
        end
        endtask

    task testcase002;

        begin
            $display("Running testcase002: Single Write (Lower)");
            test_num = test_num + 1;
            reset_dut();

            @(posedge wb_clk_i);
            wb_adr_i = 19'h00002;
            wb_dat_i = 16'hAAAA;
            wb_we_i  = 1;
            wb_sel_i = 2'b11;
            wb_cyc_i = 1;
            wb_stb_i = 1;


            wait(wb_ack_o === 1'b1);




            #1;





            check_outputs(
                21'h00004,
                1'b0,
                4'hc,
                1'b0,
                1'b1,
                1'b0,
                1'b1,
                16'h0
            );

            @(posedge wb_clk_i);
            wb_cyc_i = 0;
            wb_stb_i = 0;
        end
        endtask

    task testcase003;

        begin
            $display("Running testcase003: Single Write (Upper)");
            test_num = test_num + 1;
            reset_dut();

            @(posedge wb_clk_i);
            wb_adr_i = 19'h00003;
            wb_dat_i = 16'h5555;
            wb_we_i  = 1;
            wb_sel_i = 2'b11;
            wb_cyc_i = 1;
            wb_stb_i = 1;

            wait(wb_ack_o === 1'b1);

            #1;


            check_outputs(
                21'h00006,
                1'b0,
                4'h3,
                1'b0,
                1'b1,
                1'b0,
                1'b1,
                16'h0
            );

            @(posedge wb_clk_i);
            wb_cyc_i = 0;
            wb_stb_i = 0;
        end
        endtask

    task testcase004;

        begin
            $display("Running testcase004: Single Read");
            test_num = test_num + 1;
            reset_dut();

            @(posedge wb_clk_i);
            wb_adr_i = 19'h00008;
            wb_we_i  = 0;
            wb_sel_i = 2'b11;
            wb_cyc_i = 1;
            wb_stb_i = 1;


            sram_data_en = 1;
            sram_data_drive = 32'hBEEFCAFE;

            wait(wb_ack_o === 1'b1);
            #1;

            #1;


            check_outputs(
                21'h00010,
                1'b0,
                4'hc,
                1'b0,
                1'b1,
                1'b1,
                1'b1,
                16'hCAFE
            );

            @(posedge wb_clk_i);
            wb_cyc_i = 0;
            wb_stb_i = 0;
            sram_data_en = 0;
        end
        endtask

    task testcase005;

        begin
            $display("Running testcase005: Multi-cycle burst sequence");
            test_num = test_num + 1;
            reset_dut();


            @(posedge wb_clk_i);
            wb_adr_i = 19'h10;
            wb_dat_i = 16'h1234;
            wb_we_i  = 1;
            wb_sel_i = 2'b11;
            wb_cyc_i = 1;
            wb_stb_i = 1;
            wait(wb_ack_o === 1'b1);
            @(posedge wb_clk_i);

            wb_adr_i = 19'h11;
            wb_we_i  = 0;
            wb_cyc_i = 1;
            wb_stb_i = 1;
            sram_data_en = 1;
            sram_data_drive = 32'h87654321;
            wait(wb_ack_o === 1'b1);
            #1;

            #1;


            check_outputs(
                21'h00022,
                1'b0,
                4'h3,
                1'b0,
                1'b1,
                1'b1,
                1'b1,
                16'h8765
            );

            @(posedge wb_clk_i);
            wb_cyc_i = 0;
            wb_stb_i = 0;
            sram_data_en = 0;
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
        input [20:0] expected_sram_addr_;
        input expected_sram_adv_ld_n_;
        input [3:0] expected_sram_bw_;
        input expected_sram_cen_;
        input expected_sram_clk_;
        input expected_sram_we_n_;
        input expected_wb_ack_o;
        input [15:0] expected_wb_dat_o;
        begin
            if (expected_sram_addr_ === (expected_sram_addr_ ^ sram_addr_ ^ expected_sram_addr_) &&
                expected_sram_adv_ld_n_ === (expected_sram_adv_ld_n_ ^ sram_adv_ld_n_ ^ expected_sram_adv_ld_n_) &&
                expected_sram_bw_ === (expected_sram_bw_ ^ sram_bw_ ^ expected_sram_bw_) &&
                expected_sram_cen_ === (expected_sram_cen_ ^ sram_cen_ ^ expected_sram_cen_) &&
                expected_sram_clk_ === (expected_sram_clk_ ^ sram_clk_ ^ expected_sram_clk_) &&
                expected_sram_we_n_ === (expected_sram_we_n_ ^ sram_we_n_ ^ expected_sram_we_n_) &&
                expected_wb_ack_o === (expected_wb_ack_o ^ wb_ack_o ^ expected_wb_ack_o) &&
                expected_wb_dat_o === (expected_wb_dat_o ^ wb_dat_o ^ expected_wb_dat_o)) begin
                $display("PASS");
                $display("  Outputs: sram_addr_=%h, sram_adv_ld_n_=%b, sram_bw_=%h, sram_cen_=%b, sram_clk_=%b, sram_we_n_=%b, wb_ack_o=%b, wb_dat_o=%h",
                         sram_addr_, sram_adv_ld_n_, sram_bw_, sram_cen_, sram_clk_, sram_we_n_, wb_ack_o, wb_dat_o);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: sram_addr_=%h, sram_adv_ld_n_=%b, sram_bw_=%h, sram_cen_=%b, sram_clk_=%b, sram_we_n_=%b, wb_ack_o=%b, wb_dat_o=%h",
                         expected_sram_addr_, expected_sram_adv_ld_n_, expected_sram_bw_, expected_sram_cen_, expected_sram_clk_, expected_sram_we_n_, expected_wb_ack_o, expected_wb_dat_o);
                $display("  Got:      sram_addr_=%h, sram_adv_ld_n_=%b, sram_bw_=%h, sram_cen_=%b, sram_clk_=%b, sram_we_n_=%b, wb_ack_o=%b, wb_dat_o=%h",
                         sram_addr_, sram_adv_ld_n_, sram_bw_, sram_cen_, sram_clk_, sram_we_n_, wb_ack_o, wb_dat_o);
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
        $dumpvars(0,wb_adr_i, wb_clk_i, wb_cyc_i, wb_dat_i, wb_rst_i, wb_sel_i, wb_stb_i, wb_we_i, sram_addr_, sram_adv_ld_n_, sram_bw_, sram_cen_, sram_clk_, sram_we_n_, wb_ack_o, wb_dat_o);
    end

endmodule
