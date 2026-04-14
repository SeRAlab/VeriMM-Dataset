`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg wb_clk_i;
    reg wb_rst_i;
    reg wbm_ack_i;
    reg [15:0] wbm_dat_i;
    reg [15:0] wbs_adr_i;
    reg [15:0] wbs_dat_i;
    reg [1:0] wbs_sel_i;
    reg wbs_stb_i;
    reg wbs_we_i;
    wire [16:0] wbm_adr_o;
    wire [15:0] wbm_dat_o;
    wire [1:0] wbm_sel_o;
    wire wbm_stb_o;
    wire wbm_we_o;
    wire wbs_ack_o;
    wire [15:0] wbs_dat_o;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .wb_clk_i(wb_clk_i),
        .wb_rst_i(wb_rst_i),
        .wbm_ack_i(wbm_ack_i),
        .wbm_dat_i(wbm_dat_i),
        .wbs_adr_i(wbs_adr_i),
        .wbs_dat_i(wbs_dat_i),
        .wbs_sel_i(wbs_sel_i),
        .wbs_stb_i(wbs_stb_i),
        .wbs_we_i(wbs_we_i),
        .wbm_adr_o(wbm_adr_o),
        .wbm_dat_o(wbm_dat_o),
        .wbm_sel_o(wbm_sel_o),
        .wbm_stb_o(wbm_stb_o),
        .wbm_we_o(wbm_we_o),
        .wbs_ack_o(wbs_ack_o),
        .wbs_dat_o(wbs_dat_o)
    );

    // Clock generation (10ns period)
    initial begin
        wb_clk_i = 0;
        forever #5 wb_clk_i = ~wb_clk_i;
    end

        task reset_dut;

        begin
            wb_clk_i = 0;
            wb_rst_i = 1;
            wbm_ack_i = 0;
            wbm_dat_i = 16'h0;
            wbs_adr_i = 16'h0;
            wbs_dat_i = 16'h0;
            wbs_sel_i = 2'b0;
            wbs_stb_i = 0;
            wbs_we_i = 0;
            #20;
            wb_rst_i = 0;
            #10;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            $display("Testcase %03d: Reset State Verification", test_num);


            #1;



            check_outputs(17'h0, 16'h0, 2'h0, 1'b0, 1'b0, 1'b0, 16'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            $display("Testcase %03d: Simple Write Transaction", test_num);

            @(posedge wb_clk_i);
            wbs_adr_i = 16'h1234;
            wbs_dat_i = 16'hABCD;
            wbs_sel_i = 2'b11;
            wbs_we_i  = 1'b1;
            wbs_stb_i = 1'b1;


            #2;
            wbm_ack_i = 1'b1;

            @(posedge wb_clk_i);
            #2;


            #1;



            check_outputs({1'b0, 16'h1234}, 16'hABCD, 2'b11, 1'b1, 1'b1, 1'b1, 16'h0);

            wbs_stb_i = 0;
            wbm_ack_i = 0;
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            $display("Testcase %03d: Simple Read Transaction", test_num);

            @(posedge wb_clk_i);
            wbs_adr_i = 16'h5AA5;
            wbs_sel_i = 2'b11;
            wbs_we_i  = 1'b0;
            wbs_stb_i = 1'b1;


            wbm_dat_i = 16'hDEAD;
            #2;
            wbm_ack_i = 1'b1;

            @(posedge wb_clk_i);
            #2;

            #1;


            check_outputs({1'b0, 16'h5AA5}, 16'h0, 2'b11, 1'b1, 1'b0, 1'b1, 16'hDEAD);

            wbs_stb_i = 0;
            wbm_ack_i = 0;
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            $display("Testcase %03d: Byte Selection Logic (Lower Byte)", test_num);

            @(posedge wb_clk_i);
            wbs_adr_i = 16'h0001;
            wbs_sel_i = 2'b01;
            wbs_we_i  = 1'b1;
            wbs_stb_i = 1'b1;
            wbs_dat_i = 16'h00FF;

            #2;
            wbm_ack_i = 1'b1;

            @(posedge wb_clk_i);
            #2;
            #1;

            check_outputs({1'b0, 16'h0001}, 16'h00FF, 2'b01, 1'b1, 1'b1, 1'b1, 16'h0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            $display("Testcase %03d: High Address Mapping", test_num);

            @(posedge wb_clk_i);
            wbs_adr_i = 16'hFFFF;
            wbs_sel_i = 2'b11;
            wbs_we_i  = 1'b1;
            wbs_stb_i = 1'b1;
            wbs_dat_i = 16'h55AA;

            #2;
            wbm_ack_i = 1'b1;

            @(posedge wb_clk_i);
            #2;

            #1;


            check_outputs({1'b0, 16'hFFFF}, 16'h55AA, 2'b11, 1'b1, 1'b1, 1'b1, 16'h0);
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
        input [16:0] expected_wbm_adr_o;
        input [15:0] expected_wbm_dat_o;
        input [1:0] expected_wbm_sel_o;
        input expected_wbm_stb_o;
        input expected_wbm_we_o;
        input expected_wbs_ack_o;
        input [15:0] expected_wbs_dat_o;
        begin
            if (expected_wbm_adr_o === (expected_wbm_adr_o ^ wbm_adr_o ^ expected_wbm_adr_o) &&
                expected_wbm_dat_o === (expected_wbm_dat_o ^ wbm_dat_o ^ expected_wbm_dat_o) &&
                expected_wbm_sel_o === (expected_wbm_sel_o ^ wbm_sel_o ^ expected_wbm_sel_o) &&
                expected_wbm_stb_o === (expected_wbm_stb_o ^ wbm_stb_o ^ expected_wbm_stb_o) &&
                expected_wbm_we_o === (expected_wbm_we_o ^ wbm_we_o ^ expected_wbm_we_o) &&
                expected_wbs_ack_o === (expected_wbs_ack_o ^ wbs_ack_o ^ expected_wbs_ack_o) &&
                expected_wbs_dat_o === (expected_wbs_dat_o ^ wbs_dat_o ^ expected_wbs_dat_o)) begin
                $display("PASS");
                $display("  Outputs: wbm_adr_o=%h, wbm_dat_o=%h, wbm_sel_o=%h, wbm_stb_o=%b, wbm_we_o=%b, wbs_ack_o=%b, wbs_dat_o=%h",
                         wbm_adr_o, wbm_dat_o, wbm_sel_o, wbm_stb_o, wbm_we_o, wbs_ack_o, wbs_dat_o);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: wbm_adr_o=%h, wbm_dat_o=%h, wbm_sel_o=%h, wbm_stb_o=%b, wbm_we_o=%b, wbs_ack_o=%b, wbs_dat_o=%h",
                         expected_wbm_adr_o, expected_wbm_dat_o, expected_wbm_sel_o, expected_wbm_stb_o, expected_wbm_we_o, expected_wbs_ack_o, expected_wbs_dat_o);
                $display("  Got:      wbm_adr_o=%h, wbm_dat_o=%h, wbm_sel_o=%h, wbm_stb_o=%b, wbm_we_o=%b, wbs_ack_o=%b, wbs_dat_o=%h",
                         wbm_adr_o, wbm_dat_o, wbm_sel_o, wbm_stb_o, wbm_we_o, wbs_ack_o, wbs_dat_o);
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
        $dumpvars(0,wb_clk_i, wb_rst_i, wbm_ack_i, wbm_dat_i, wbs_adr_i, wbs_dat_i, wbs_sel_i, wbs_stb_i, wbs_we_i, wbm_adr_o, wbm_dat_o, wbm_sel_o, wbm_stb_o, wbm_we_o, wbs_ack_o, wbs_dat_o);
    end

endmodule
