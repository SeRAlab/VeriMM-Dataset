`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [2:0] wb_adr_i;
    reg wb_cyc_i;
    reg [31:0] wb_dat32_o;
    reg [7:0] wb_dat8_o;
    reg [7:0] wb_dat_i;
    reg wb_rst_i;
    reg [3:0] wb_sel_i;
    reg wb_stb_i;
    reg wb_we_i;
    wire re_o;
    wire wb_ack_o;
    wire [2:0] wb_adr_int;
    wire [7:0] wb_dat8_i;
    wire [7:0] wb_dat_o;
    wire we_o;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .wb_adr_i(wb_adr_i),
        .wb_cyc_i(wb_cyc_i),
        .wb_dat32_o(wb_dat32_o),
        .wb_dat8_o(wb_dat8_o),
        .wb_dat_i(wb_dat_i),
        .wb_rst_i(wb_rst_i),
        .wb_sel_i(wb_sel_i),
        .wb_stb_i(wb_stb_i),
        .wb_we_i(wb_we_i),
        .re_o(re_o),
        .wb_ack_o(wb_ack_o),
        .wb_adr_int(wb_adr_int),
        .wb_dat8_i(wb_dat8_i),
        .wb_dat_o(wb_dat_o),
        .we_o(we_o)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            wb_rst_i = 1;
            wb_adr_i = 0;
            wb_cyc_i = 0;
            wb_dat32_o = 0;
            wb_dat8_o = 0;
            wb_dat_i = 0;
            wb_sel_i = 0;
            wb_stb_i = 0;
            wb_we_i = 0;
            @(posedge clk);
            #2;
            wb_rst_i = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %03d: Initial Reset State", test_num);
            reset_dut();

            #1;


            check_outputs(1'b0, 1'b0, 3'h0, 8'h0, 8'h0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %03d: Simple Write Operation", test_num);
            reset_dut();
            @(negedge clk);
            wb_adr_i = 3'h2;
            wb_dat_i = 8'hA5;
            wb_we_i = 1'b1;
            wb_cyc_i = 1'b1;
            wb_stb_i = 1'b1;
            wb_sel_i = 4'b0001;

            @(posedge clk);
            #2;


            #1;



            check_outputs(1'b0, 1'b1, 3'h2, 8'hA5, 8'h0, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %03d: Simple Read Operation", test_num);
            reset_dut();
            @(negedge clk);
            wb_adr_i = 3'h5;
            wb_dat8_o = 8'h5A;
            wb_we_i = 1'b0;
            wb_cyc_i = 1'b1;
            wb_stb_i = 1'b1;
            wb_sel_i = 4'b0001;

            @(posedge clk);
            #2;

            #1;


            check_outputs(1'b1, 1'b1, 3'h5, 8'h0, 8'h5A, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %03d: Inactive Bus Cycle", test_num);
            reset_dut();
            @(negedge clk);
            wb_adr_i = 3'h1;
            wb_dat_i = 8'hFF;
            wb_we_i = 1'b1;
            wb_cyc_i = 1'b0;
            wb_stb_i = 1'b1;

            @(posedge clk);
            #2;

            #1;


            check_outputs(1'b0, 1'b0, 3'h1, 8'hFF, 8'h0, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %03d: Address Mapping Verification", test_num);
            reset_dut();
            @(negedge clk);
            wb_adr_i = 3'h7;
            wb_dat_i = 8'h12;
            wb_we_i = 1'b1;
            wb_cyc_i = 1'b1;
            wb_stb_i = 1'b1;

            @(posedge clk);
            #2;

            #1;


            check_outputs(1'b0, 1'b1, 3'h7, 8'h12, 8'h0, 1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %03d: Strobe De-assertion", test_num);
            reset_dut();
            @(negedge clk);
            wb_cyc_i = 1'b1;
            wb_stb_i = 1'b0;
            wb_we_i = 1'b1;

            @(posedge clk);
            #2;

            #1;


            check_outputs(1'b0, 1'b0, 3'h0, 8'h0, 8'h0, 1'b0);
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
        input expected_re_o;
        input expected_wb_ack_o;
        input [2:0] expected_wb_adr_int;
        input [7:0] expected_wb_dat8_i;
        input [7:0] expected_wb_dat_o;
        input expected_we_o;
        begin
            if (expected_re_o === (expected_re_o ^ re_o ^ expected_re_o) &&
                expected_wb_ack_o === (expected_wb_ack_o ^ wb_ack_o ^ expected_wb_ack_o) &&
                expected_wb_adr_int === (expected_wb_adr_int ^ wb_adr_int ^ expected_wb_adr_int) &&
                expected_wb_dat8_i === (expected_wb_dat8_i ^ wb_dat8_i ^ expected_wb_dat8_i) &&
                expected_wb_dat_o === (expected_wb_dat_o ^ wb_dat_o ^ expected_wb_dat_o) &&
                expected_we_o === (expected_we_o ^ we_o ^ expected_we_o)) begin
                $display("PASS");
                $display("  Outputs: re_o=%b, wb_ack_o=%b, wb_adr_int=%h, wb_dat8_i=%h, wb_dat_o=%h, we_o=%b",
                         re_o, wb_ack_o, wb_adr_int, wb_dat8_i, wb_dat_o, we_o);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: re_o=%b, wb_ack_o=%b, wb_adr_int=%h, wb_dat8_i=%h, wb_dat_o=%h, we_o=%b",
                         expected_re_o, expected_wb_ack_o, expected_wb_adr_int, expected_wb_dat8_i, expected_wb_dat_o, expected_we_o);
                $display("  Got:      re_o=%b, wb_ack_o=%b, wb_adr_int=%h, wb_dat8_i=%h, wb_dat_o=%h, we_o=%b",
                         re_o, wb_ack_o, wb_adr_int, wb_dat8_i, wb_dat_o, we_o);
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
        $dumpvars(0,clk, wb_adr_i, wb_cyc_i, wb_dat32_o, wb_dat8_o, wb_dat_i, wb_rst_i, wb_sel_i, wb_stb_i, wb_we_i, re_o, wb_ack_o, wb_adr_int, wb_dat8_i, wb_dat_o, we_o);
    end

endmodule
