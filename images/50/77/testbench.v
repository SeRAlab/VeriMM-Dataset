`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg ack_i;
    reg clk_i;
    reg err_i;
    reg [29:0] render_addr_i;
    reg [31:0] render_dat_i;
    reg [3:0] render_sel_i;
    reg rst_i;
    reg write_i;
    wire ack_o;
    wire [31:0] adr_o;
    wire [1:0] bte_o;
    wire [2:0] cti_o;
    wire cyc_o;
    wire [31:0] dat_o;
    wire [3:0] sel_o;
    wire sint_o;
    wire stb_o;
    wire we_o;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ack_i(ack_i),
        .clk_i(clk_i),
        .err_i(err_i),
        .render_addr_i(render_addr_i),
        .render_dat_i(render_dat_i),
        .render_sel_i(render_sel_i),
        .rst_i(rst_i),
        .write_i(write_i),
        .ack_o(ack_o),
        .adr_o(adr_o),
        .bte_o(bte_o),
        .cti_o(cti_o),
        .cyc_o(cyc_o),
        .dat_o(dat_o),
        .sel_o(sel_o),
        .sint_o(sint_o),
        .stb_o(stb_o),
        .we_o(we_o)
    );

    // Clock generation (10ns period)
    initial begin
        clk_i = 0;
        forever #5 clk_i = ~clk_i;
    end

        task reset_dut;

        begin
            rst_i = 1;
            ack_i = 0;
            err_i = 0;
            render_addr_i = 0;
            render_dat_i = 0;
            render_sel_i = 0;
            write_i = 0;
            repeat (2) @(posedge clk_i);
            rst_i = 0;
            @(posedge clk_i);
        end
        endtask
    task testcase001;

        begin
            reset_dut();

            #1;


            check_outputs(0, 32'h0, 2'b00, 3'b000, 0, 32'h0, 4'h0, 0, 0, 0);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            render_addr_i = 30'h12345678;
            render_dat_i = 32'hDEADBEEF;
            render_sel_i = 4'hF;
            write_i = 1;
            @(posedge clk_i);
            write_i = 0;


            wait (cyc_o == 1);


            repeat (2) @(posedge clk_i);
            ack_i = 1;
            @(posedge clk_i);
            ack_i = 0;



            @(posedge clk_i);
            #1;

            check_outputs(1, {30'h12345678, 2'b00}, 2'b00, 3'b000, 0, 32'hDEADBEEF, 4'hF, 0, 0, 1);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            render_addr_i = 30'h0AAAAAAA;
            render_dat_i = 32'h11223344;
            render_sel_i = 4'h9;
            write_i = 1;
            @(posedge clk_i);
            write_i = 0;

            wait (cyc_o == 1);
            ack_i = 1;
            @(posedge clk_i);
            ack_i = 0;

            @(posedge clk_i);
            #1;

            check_outputs(1, {30'h0AAAAAAA, 2'b00}, 2'b00, 3'b000, 0, 32'h11223344, 4'h9, 0, 0, 1);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            render_addr_i = 30'h0;
            render_dat_i = 32'h0;
            render_sel_i = 4'hF;
            write_i = 1;
            @(posedge clk_i);
            write_i = 0;

            wait (cyc_o == 1);
            err_i = 1;
            @(posedge clk_i);
            err_i = 0;

            @(posedge clk_i);


            #1;



            check_outputs(0, 32'h0, 2'b00, 3'b000, 0, 32'h0, 4'hF, 1, 0, 1);
        end
        endtask

    task testcase005;

        begin
            reset_dut();

            render_addr_i = 30'h1;
            render_dat_i = 32'hA;
            render_sel_i = 4'hF;
            write_i = 1;
            @(posedge clk_i);
            write_i = 0;
            wait (cyc_o == 1);
            ack_i = 1;
            @(posedge clk_i);
            ack_i = 0;
            @(posedge clk_i);


            render_addr_i = 30'h2;
            render_dat_i = 32'hB;
            write_i = 1;
            @(posedge clk_i);
            write_i = 0;
            wait (cyc_o == 1);
            ack_i = 1;
            @(posedge clk_i);
            ack_i = 0;
            @(posedge clk_i);

            #1;


            check_outputs(1, {30'h2, 2'b00}, 2'b00, 3'b000, 0, 32'hB, 4'hF, 0, 0, 1);
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
        input expected_ack_o;
        input [31:0] expected_adr_o;
        input [1:0] expected_bte_o;
        input [2:0] expected_cti_o;
        input expected_cyc_o;
        input [31:0] expected_dat_o;
        input [3:0] expected_sel_o;
        input expected_sint_o;
        input expected_stb_o;
        input expected_we_o;
        begin
            if (expected_ack_o === (expected_ack_o ^ ack_o ^ expected_ack_o) &&
                expected_adr_o === (expected_adr_o ^ adr_o ^ expected_adr_o) &&
                expected_bte_o === (expected_bte_o ^ bte_o ^ expected_bte_o) &&
                expected_cti_o === (expected_cti_o ^ cti_o ^ expected_cti_o) &&
                expected_cyc_o === (expected_cyc_o ^ cyc_o ^ expected_cyc_o) &&
                expected_dat_o === (expected_dat_o ^ dat_o ^ expected_dat_o) &&
                expected_sel_o === (expected_sel_o ^ sel_o ^ expected_sel_o) &&
                expected_sint_o === (expected_sint_o ^ sint_o ^ expected_sint_o) &&
                expected_stb_o === (expected_stb_o ^ stb_o ^ expected_stb_o) &&
                expected_we_o === (expected_we_o ^ we_o ^ expected_we_o)) begin
                $display("PASS");
                $display("  Outputs: ack_o=%b, adr_o=%h, bte_o=%h, cti_o=%h, cyc_o=%b, dat_o=%h, sel_o=%h, sint_o=%b, stb_o=%b, we_o=%b",
                         ack_o, adr_o, bte_o, cti_o, cyc_o, dat_o, sel_o, sint_o, stb_o, we_o);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ack_o=%b, adr_o=%h, bte_o=%h, cti_o=%h, cyc_o=%b, dat_o=%h, sel_o=%h, sint_o=%b, stb_o=%b, we_o=%b",
                         expected_ack_o, expected_adr_o, expected_bte_o, expected_cti_o, expected_cyc_o, expected_dat_o, expected_sel_o, expected_sint_o, expected_stb_o, expected_we_o);
                $display("  Got:      ack_o=%b, adr_o=%h, bte_o=%h, cti_o=%h, cyc_o=%b, dat_o=%h, sel_o=%h, sint_o=%b, stb_o=%b, we_o=%b",
                         ack_o, adr_o, bte_o, cti_o, cyc_o, dat_o, sel_o, sint_o, stb_o, we_o);
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
        $dumpvars(0,ack_i, clk_i, err_i, render_addr_i, render_dat_i, render_sel_i, rst_i, write_i, ack_o, adr_o, bte_o, cti_o, cyc_o, dat_o, sel_o, sint_o, stb_o, we_o);
    end

endmodule
