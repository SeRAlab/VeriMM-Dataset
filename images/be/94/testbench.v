`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] base_address;
    reg equation_enable;
    reg wb_ack_i;
    reg wb_clk;
    reg [31:0] wb_dat_i;
    reg wb_err_i;
    reg wb_rst;
    reg wb_rty_i;
    wire equation_done;
    wire [31:0] wb_adr_o;
    wire [1:0] wb_bte_o;
    wire [2:0] wb_cti_o;
    wire wb_cyc_o;
    wire [31:0] wb_dat_o;
    wire [3:0] wb_sel_o;
    wire wb_stb_o;
    wire wb_we_o;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .base_address(base_address),
        .equation_enable(equation_enable),
        .wb_ack_i(wb_ack_i),
        .wb_clk(wb_clk),
        .wb_dat_i(wb_dat_i),
        .wb_err_i(wb_err_i),
        .wb_rst(wb_rst),
        .wb_rty_i(wb_rty_i),
        .equation_done(equation_done),
        .wb_adr_o(wb_adr_o),
        .wb_bte_o(wb_bte_o),
        .wb_cti_o(wb_cti_o),
        .wb_cyc_o(wb_cyc_o),
        .wb_dat_o(wb_dat_o),
        .wb_sel_o(wb_sel_o),
        .wb_stb_o(wb_stb_o),
        .wb_we_o(wb_we_o)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("\nRunning Test Case 001: Disable state with zero inputs");


            base_address = 32'h0;
            equation_enable = 0;
            wb_dat_i = 32'h0;
            wb_ack_i = 0;
            wb_err_i = 0;
            wb_rty_i = 0;


            reset_dut();



            #1;




            check_outputs(1'b0, 32'h0, 2'h0, 3'h0, 1'b0, 32'h0, 4'h0, 1'b0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nRunning Test Case 002: Disable state with high base_address");


            base_address = 32'hA5A5A5A5;
            equation_enable = 0;
            wb_dat_i = 32'h0;
            wb_ack_i = 0;
            wb_err_i = 0;
            wb_rty_i = 0;


            reset_dut();


            #1;



            check_outputs(1'b0, 32'h0, 2'h0, 3'h0, 1'b0, 32'h0, 4'h0, 1'b0, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nRunning Test Case 003: Disable state with active Wishbone inputs");


            base_address = 32'h0;
            equation_enable = 0;
            wb_dat_i = 32'hDEADBEEF;
            wb_ack_i = 1;
            wb_err_i = 1;
            wb_rty_i = 1;


            reset_dut();


            #1;



            check_outputs(1'b0, 32'h0, 2'h0, 3'h0, 1'b0, 32'h0, 4'h0, 1'b0, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nRunning Test Case 004: Persistence of zero state over time");


            base_address = 32'h12345678;
            equation_enable = 0;
            wb_dat_i = 32'h0;
            wb_ack_i = 0;
            wb_err_i = 0;
            wb_rty_i = 0;


            reset_dut();


            repeat(10) @(posedge wb_clk);


            #1;



            check_outputs(1'b0, 32'h0, 2'h0, 3'h0, 1'b0, 32'h0, 4'h0, 1'b0, 1'b0);
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
        input expected_equation_done;
        input [31:0] expected_wb_adr_o;
        input [1:0] expected_wb_bte_o;
        input [2:0] expected_wb_cti_o;
        input expected_wb_cyc_o;
        input [31:0] expected_wb_dat_o;
        input [3:0] expected_wb_sel_o;
        input expected_wb_stb_o;
        input expected_wb_we_o;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_equation_done === (expected_equation_done ^ equation_done ^ expected_equation_done) &&
                expected_wb_adr_o === (expected_wb_adr_o ^ wb_adr_o ^ expected_wb_adr_o) &&
                expected_wb_bte_o === (expected_wb_bte_o ^ wb_bte_o ^ expected_wb_bte_o) &&
                expected_wb_cti_o === (expected_wb_cti_o ^ wb_cti_o ^ expected_wb_cti_o) &&
                expected_wb_cyc_o === (expected_wb_cyc_o ^ wb_cyc_o ^ expected_wb_cyc_o) &&
                expected_wb_dat_o === (expected_wb_dat_o ^ wb_dat_o ^ expected_wb_dat_o) &&
                expected_wb_sel_o === (expected_wb_sel_o ^ wb_sel_o ^ expected_wb_sel_o) &&
                expected_wb_stb_o === (expected_wb_stb_o ^ wb_stb_o ^ expected_wb_stb_o) &&
                expected_wb_we_o === (expected_wb_we_o ^ wb_we_o ^ expected_wb_we_o)) begin
                $display("PASS");
                $display("  Outputs: equation_done=%b, wb_adr_o=%h, wb_bte_o=%h, wb_cti_o=%h, wb_cyc_o=%b, wb_dat_o=%h, wb_sel_o=%h, wb_stb_o=%b, wb_we_o=%b",
                         equation_done, wb_adr_o, wb_bte_o, wb_cti_o, wb_cyc_o, wb_dat_o, wb_sel_o, wb_stb_o, wb_we_o);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: equation_done=%b, wb_adr_o=%h, wb_bte_o=%h, wb_cti_o=%h, wb_cyc_o=%b, wb_dat_o=%h, wb_sel_o=%h, wb_stb_o=%b, wb_we_o=%b",
                         expected_equation_done, expected_wb_adr_o, expected_wb_bte_o, expected_wb_cti_o, expected_wb_cyc_o, expected_wb_dat_o, expected_wb_sel_o, expected_wb_stb_o, expected_wb_we_o);
                $display("  Got:      equation_done=%b, wb_adr_o=%h, wb_bte_o=%h, wb_cti_o=%h, wb_cyc_o=%b, wb_dat_o=%h, wb_sel_o=%h, wb_stb_o=%b, wb_we_o=%b",
                         equation_done, wb_adr_o, wb_bte_o, wb_cti_o, wb_cyc_o, wb_dat_o, wb_sel_o, wb_stb_o, wb_we_o);
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
