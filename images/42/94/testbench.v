`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [18:0] wb1_adr_i;
    reg wb1_clk_i;
    reg wb1_cyc_i;
    reg [15:0] wb1_dat_i;
    reg wb1_rst_i;
    reg [1:0] wb1_sel_i;
    reg wb1_stb_i;
    reg wb1_we_i;
    reg [18:0] wb2_adr_i;
    reg wb2_clk_i;
    reg wb2_cyc_i;
    reg [15:0] wb2_dat_i;
    reg wb2_rst_i;
    reg [1:0] wb2_sel_i;
    reg wb2_stb_i;
    reg wb2_we_i;
    wire wb1_ack_o;
    wire [15:0] wb1_dat_o;
    wire wb2_ack_o;
    wire [15:0] wb2_dat_o;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .wb1_adr_i(wb1_adr_i),
        .wb1_clk_i(wb1_clk_i),
        .wb1_cyc_i(wb1_cyc_i),
        .wb1_dat_i(wb1_dat_i),
        .wb1_rst_i(wb1_rst_i),
        .wb1_sel_i(wb1_sel_i),
        .wb1_stb_i(wb1_stb_i),
        .wb1_we_i(wb1_we_i),
        .wb2_adr_i(wb2_adr_i),
        .wb2_clk_i(wb2_clk_i),
        .wb2_cyc_i(wb2_cyc_i),
        .wb2_dat_i(wb2_dat_i),
        .wb2_rst_i(wb2_rst_i),
        .wb2_sel_i(wb2_sel_i),
        .wb2_stb_i(wb2_stb_i),
        .wb2_we_i(wb2_we_i),
        .wb1_ack_o(wb1_ack_o),
        .wb1_dat_o(wb1_dat_o),
        .wb2_ack_o(wb2_ack_o),
        .wb2_dat_o(wb2_dat_o)
    );

    // Clock generation (10ns period)
    initial begin
        wb1_clk_i = 0;
        forever #5 wb1_clk_i = ~wb1_clk_i;
    end

        task reset_dut;

        begin
            wb1_rst_i = 1;
            wb2_rst_i = 1;
            wb1_adr_i = 0;
            wb1_dat_i = 0;
            wb1_we_i = 0;
            wb1_sel_i = 0;
            wb1_stb_i = 0;
            wb1_cyc_i = 0;
            wb2_adr_i = 0;
            wb2_dat_i = 0;
            wb2_we_i = 0;
            wb2_sel_i = 0;
            wb2_stb_i = 0;
            wb2_cyc_i = 0;
            #20;
            wb1_rst_i = 0;
            wb2_rst_i = 0;
            #10;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            $display("Testcase 001: WB1 Basic Write and Read");


            @(posedge wb1_clk_i);
            wb1_adr_i = 19'h00001;
            wb1_dat_i = 16'hABCD;
            wb1_we_i  = 1;
            wb1_sel_i = 2'b11;
            wb1_stb_i = 1;
            wb1_cyc_i = 1;
            wait(wb1_ack_o);
            @(posedge wb1_clk_i);
            wb1_stb_i = 0;
            wb1_cyc_i = 0;


            @(posedge wb1_clk_i);
            wb1_adr_i = 19'h00001;
            wb1_we_i  = 0;
            wb1_stb_i = 1;
            wb1_cyc_i = 1;
            wait(wb1_ack_o);
            #1;
            #1;

            check_outputs(1, 16'hABCD, 0, 16'h0000);
            @(posedge wb1_clk_i);
            wb1_stb_i = 0;
            wb1_cyc_i = 0;
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            $display("Testcase 002: WB2 Basic Write and Read");


            @(posedge wb2_clk_i);
            wb2_adr_i = 19'h00002;
            wb2_dat_i = 16'h1234;
            wb2_we_i  = 1;
            wb2_sel_i = 2'b11;
            wb2_stb_i = 1;
            wb2_cyc_i = 1;
            wait(wb2_ack_o);
            @(posedge wb2_clk_i);
            wb2_stb_i = 0;
            wb2_cyc_i = 0;


            @(posedge wb2_clk_i);
            wb2_adr_i = 19'h00002;
            wb2_we_i  = 0;
            wb2_stb_i = 1;
            wb2_cyc_i = 1;
            wait(wb2_ack_o);
            #1;
            #1;

            check_outputs(0, 16'h0000, 1, 16'h1234);
            @(posedge wb2_clk_i);
            wb2_stb_i = 0;
            wb2_cyc_i = 0;
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            $display("Testcase 003: Memory Sharing - Write WB1, Read WB2");


            @(posedge wb1_clk_i);
            wb1_adr_i = 19'h00005;
            wb1_dat_i = 16'h55AA;
            wb1_we_i  = 1;
            wb1_sel_i = 2'b11;
            wb1_stb_i = 1;
            wb1_cyc_i = 1;
            wait(wb1_ack_o);
            @(posedge wb1_clk_i);
            wb1_stb_i = 0;
            wb1_cyc_i = 0;


            @(posedge wb2_clk_i);
            wb2_adr_i = 19'h00005;
            wb2_we_i  = 0;
            wb2_sel_i = 2'b11;
            wb2_stb_i = 1;
            wb2_cyc_i = 1;
            wait(wb2_ack_o);
            #1;
            #1;

            check_outputs(0, 16'h0000, 1, 16'h55AA);
            @(posedge wb2_clk_i);
            wb2_stb_i = 0;
            wb2_cyc_i = 0;
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            $display("Testcase 004: Byte Select Write Check");


            @(posedge wb1_clk_i);
            wb1_adr_i = 19'h0000A;
            wb1_dat_i = 16'hFF11;
            wb1_we_i  = 1;
            wb1_sel_i = 2'b01;
            wb1_stb_i = 1;
            wb1_cyc_i = 1;
            wait(wb1_ack_o);
            @(posedge wb1_clk_i);
            wb1_stb_i = 0;
            wb1_cyc_i = 0;


            @(posedge wb1_clk_i);
            wb1_adr_i = 19'h0000A;
            wb1_we_i  = 0;
            wb1_stb_i = 1;
            wb1_cyc_i = 1;
            wait(wb1_ack_o);
            #1;


            if (wb1_dat_o[7:0] == 8'h11) begin
                 #1;

                 check_outputs(1, wb1_dat_o, 0, 16'h0000);
            end else begin
                 fail_count = fail_count + 1;
                 $display("FAIL: Byte Select Low mismatch");
            end
            @(posedge wb1_clk_i);
            wb1_stb_i = 0;
            wb1_cyc_i = 0;
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            $display("Testcase 005: Address Independence Check");


            @(posedge wb1_clk_i);
            wb1_adr_i = 19'h00010;
            wb1_dat_i = 16'hAAAA;
            wb1_we_i  = 1;
            wb1_stb_i = 1; wb1_cyc_i = 1; wb1_sel_i = 2'b11;
            wait(wb1_ack_o);
            @(posedge wb1_clk_i);
            wb1_stb_i = 0; wb1_cyc_i = 0;


            @(posedge wb1_clk_i);
            wb1_adr_i = 19'h00011;
            wb1_dat_i = 16'hBBBB;
            wb1_we_i  = 1;
            wb1_stb_i = 1; wb1_cyc_i = 1;
            wait(wb1_ack_o);
            @(posedge wb1_clk_i);
            wb1_stb_i = 0; wb1_cyc_i = 0;


            @(posedge wb2_clk_i);
            wb2_adr_i = 19'h00010;
            wb2_we_i  = 0;
            wb2_stb_i = 1; wb2_cyc_i = 1; wb2_sel_i = 2'b11;
            wait(wb2_ack_o);
            #1;
            #1;

            check_outputs(0, 16'h0000, 1, 16'hAAAA);
            @(posedge wb2_clk_i);
            wb2_stb_i = 0; wb2_cyc_i = 0;
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
        input expected_wb1_ack_o;
        input [15:0] expected_wb1_dat_o;
        input expected_wb2_ack_o;
        input [15:0] expected_wb2_dat_o;
        begin
            if (expected_wb1_ack_o === (expected_wb1_ack_o ^ wb1_ack_o ^ expected_wb1_ack_o) &&
                expected_wb1_dat_o === (expected_wb1_dat_o ^ wb1_dat_o ^ expected_wb1_dat_o) &&
                expected_wb2_ack_o === (expected_wb2_ack_o ^ wb2_ack_o ^ expected_wb2_ack_o) &&
                expected_wb2_dat_o === (expected_wb2_dat_o ^ wb2_dat_o ^ expected_wb2_dat_o)) begin
                $display("PASS");
                $display("  Outputs: wb1_ack_o=%b, wb1_dat_o=%h, wb2_ack_o=%b, wb2_dat_o=%h",
                         wb1_ack_o, wb1_dat_o, wb2_ack_o, wb2_dat_o);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: wb1_ack_o=%b, wb1_dat_o=%h, wb2_ack_o=%b, wb2_dat_o=%h",
                         expected_wb1_ack_o, expected_wb1_dat_o, expected_wb2_ack_o, expected_wb2_dat_o);
                $display("  Got:      wb1_ack_o=%b, wb1_dat_o=%h, wb2_ack_o=%b, wb2_dat_o=%h",
                         wb1_ack_o, wb1_dat_o, wb2_ack_o, wb2_dat_o);
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
        $dumpvars(0,wb1_adr_i, wb1_clk_i, wb1_cyc_i, wb1_dat_i, wb1_rst_i, wb1_sel_i, wb1_stb_i, wb1_we_i, wb2_adr_i, wb2_clk_i, wb2_cyc_i, wb2_dat_i, wb2_rst_i, wb2_sel_i, wb2_stb_i, wb2_we_i, wb1_ack_o, wb1_dat_o, wb2_ack_o, wb2_dat_o);
    end

endmodule
