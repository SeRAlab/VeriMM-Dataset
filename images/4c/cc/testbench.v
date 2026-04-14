`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [22:0] wb16_adr_i;
    reg wb16_cyc_i;
    reg [15:0] wb16_dat_i;
    reg wb16_stb_i;
    reg wb16_we_i;
    reg wb_clk_i;
    reg wb_rst_i;
    reg wbm_ack_i;
    reg [31:0] wbm_dat_i;
    wire wb16_ack_o;
    wire [15:0] wb16_dat_o;
    wire [21:0] wbm_adr_o;
    wire wbm_cyc_o;
    wire [31:0] wbm_dat_o;
    wire [3:0] wbm_sel_o;
    wire wbm_stb_o;
    wire wbm_we_o;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .wb16_adr_i(wb16_adr_i),
        .wb16_cyc_i(wb16_cyc_i),
        .wb16_dat_i(wb16_dat_i),
        .wb16_stb_i(wb16_stb_i),
        .wb16_we_i(wb16_we_i),
        .wb_clk_i(wb_clk_i),
        .wb_rst_i(wb_rst_i),
        .wbm_ack_i(wbm_ack_i),
        .wbm_dat_i(wbm_dat_i),
        .wb16_ack_o(wb16_ack_o),
        .wb16_dat_o(wb16_dat_o),
        .wbm_adr_o(wbm_adr_o),
        .wbm_cyc_o(wbm_cyc_o),
        .wbm_dat_o(wbm_dat_o),
        .wbm_sel_o(wbm_sel_o),
        .wbm_stb_o(wbm_stb_o),
        .wbm_we_o(wbm_we_o)
    );

    // Clock generation (10ns period)
    initial begin
        wb_clk_i = 0;
        forever #5 wb_clk_i = ~wb_clk_i;
    end

        task reset_dut;

        begin
            wb_rst_i = 1;
            wb16_adr_i = 0;
            wb16_cyc_i = 0;
            wb16_dat_i = 0;
            wb16_stb_i = 0;
            wb16_we_i = 0;
            wbm_ack_i = 0;
            wbm_dat_i = 0;
            repeat (2) @(posedge wb_clk_i);
            wb_rst_i = 0;
            repeat (1) @(posedge wb_clk_i);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();


            wb16_adr_i = 23'h000000;
            wb16_cyc_i = 1;
            wb16_stb_i = 1;
            wb16_we_i  = 0;


            wbm_dat_i = 32'hDEADBEEF;
            wbm_ack_i = 1;

            @(posedge wb_clk_i);
            #1;







            #1;








            check_outputs(1, 16'hBEEF, 22'h0, 1, 32'h0, 4'b0011, 1, 0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();


            wb16_adr_i = 23'h000001;
            wb16_cyc_i = 1;
            wb16_stb_i = 1;
            wb16_we_i  = 0;


            wbm_dat_i = 32'h12345678;
            wbm_ack_i = 1;

            @(posedge wb_clk_i);
            #1;





            #1;






            check_outputs(1, 16'h1234, 22'h0, 1, 32'h0, 4'b1100, 1, 0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();


            wb16_adr_i = 23'h000002;
            wb16_dat_i = 16'hAAAA;
            wb16_cyc_i = 1;
            wb16_stb_i = 1;
            wb16_we_i  = 1;


            wbm_ack_i = 1;

            @(posedge wb_clk_i);
            #1;






            #1;







            check_outputs(1, 16'h0, 22'h1, 1, 32'h0000AAAA, 4'b0011, 1, 1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();


            wb16_adr_i = 23'h000003;
            wb16_dat_i = 16'hBBBB;
            wb16_cyc_i = 1;
            wb16_stb_i = 1;
            wb16_we_i  = 1;


            wbm_ack_i = 1;

            @(posedge wb_clk_i);
            #1;






            #1;







            check_outputs(1, 16'h0, 22'h1, 1, 32'hBBBB0000, 4'b1100, 1, 1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();


            wb16_cyc_i = 0;
            wb16_stb_i = 0;

            @(posedge wb_clk_i);
            #1;


            #1;



            check_outputs(0, 16'h0, 22'h0, 0, 32'h0, 4'b0, 0, 0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();


            wb16_adr_i = 23'h7FFFFF;
            wb16_cyc_i = 1;
            wb16_stb_i = 1;
            wb16_we_i  = 0;

            wbm_dat_i = 32'hF0F03333;
            wbm_ack_i = 1;

            @(posedge wb_clk_i);
            #1;



            #1;




            check_outputs(1, 16'hF0F0, 22'h3FFFFF, 1, 32'h0, 4'b1100, 1, 0);
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
        testcase006();
        
        
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
        input expected_wb16_ack_o;
        input [15:0] expected_wb16_dat_o;
        input [21:0] expected_wbm_adr_o;
        input expected_wbm_cyc_o;
        input [31:0] expected_wbm_dat_o;
        input [3:0] expected_wbm_sel_o;
        input expected_wbm_stb_o;
        input expected_wbm_we_o;
        begin
            if (expected_wb16_ack_o === (expected_wb16_ack_o ^ wb16_ack_o ^ expected_wb16_ack_o) &&
                expected_wb16_dat_o === (expected_wb16_dat_o ^ wb16_dat_o ^ expected_wb16_dat_o) &&
                expected_wbm_adr_o === (expected_wbm_adr_o ^ wbm_adr_o ^ expected_wbm_adr_o) &&
                expected_wbm_cyc_o === (expected_wbm_cyc_o ^ wbm_cyc_o ^ expected_wbm_cyc_o) &&
                expected_wbm_dat_o === (expected_wbm_dat_o ^ wbm_dat_o ^ expected_wbm_dat_o) &&
                expected_wbm_sel_o === (expected_wbm_sel_o ^ wbm_sel_o ^ expected_wbm_sel_o) &&
                expected_wbm_stb_o === (expected_wbm_stb_o ^ wbm_stb_o ^ expected_wbm_stb_o) &&
                expected_wbm_we_o === (expected_wbm_we_o ^ wbm_we_o ^ expected_wbm_we_o)) begin
                $display("PASS");
                $display("  Outputs: wb16_ack_o=%b, wb16_dat_o=%h, wbm_adr_o=%h, wbm_cyc_o=%b, wbm_dat_o=%h, wbm_sel_o=%h, wbm_stb_o=%b, wbm_we_o=%b",
                         wb16_ack_o, wb16_dat_o, wbm_adr_o, wbm_cyc_o, wbm_dat_o, wbm_sel_o, wbm_stb_o, wbm_we_o);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: wb16_ack_o=%b, wb16_dat_o=%h, wbm_adr_o=%h, wbm_cyc_o=%b, wbm_dat_o=%h, wbm_sel_o=%h, wbm_stb_o=%b, wbm_we_o=%b",
                         expected_wb16_ack_o, expected_wb16_dat_o, expected_wbm_adr_o, expected_wbm_cyc_o, expected_wbm_dat_o, expected_wbm_sel_o, expected_wbm_stb_o, expected_wbm_we_o);
                $display("  Got:      wb16_ack_o=%b, wb16_dat_o=%h, wbm_adr_o=%h, wbm_cyc_o=%b, wbm_dat_o=%h, wbm_sel_o=%h, wbm_stb_o=%b, wbm_we_o=%b",
                         wb16_ack_o, wb16_dat_o, wbm_adr_o, wbm_cyc_o, wbm_dat_o, wbm_sel_o, wbm_stb_o, wbm_we_o);
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
        $dumpvars(0,wb16_adr_i, wb16_cyc_i, wb16_dat_i, wb16_stb_i, wb16_we_i, wb_clk_i, wb_rst_i, wbm_ack_i, wbm_dat_i, wb16_ack_o, wb16_dat_o, wbm_adr_o, wbm_cyc_o, wbm_dat_o, wbm_sel_o, wbm_stb_o, wbm_we_o);
    end

endmodule
