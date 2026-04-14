`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg fifo_full;
    reg flush;
    reg load_cs_ip;
    reg [15:0] requested_cs;
    reg [15:0] requested_ip;
    reg rst;
    reg umi_ack_i;
    reg [15:0] umi_dat_i;
    wire [15:0] cs;
    wire [15:0] fifo_dat_o;
    wire [15:0] ip;
    wire [19:0] umi_adr_o;
    wire umi_by_o;
    wire umi_stb_o;
    wire wr_fifo;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .fifo_full(fifo_full),
        .flush(flush),
        .load_cs_ip(load_cs_ip),
        .requested_cs(requested_cs),
        .requested_ip(requested_ip),
        .rst(rst),
        .umi_ack_i(umi_ack_i),
        .umi_dat_i(umi_dat_i),
        .cs(cs),
        .fifo_dat_o(fifo_dat_o),
        .ip(ip),
        .umi_adr_o(umi_adr_o),
        .umi_by_o(umi_by_o),
        .umi_stb_o(umi_stb_o),
        .wr_fifo(wr_fifo)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            fifo_full = 0;
            flush = 0;
            load_cs_ip = 0;
            requested_cs = 0;
            requested_ip = 0;
            umi_ack_i = 0;
            umi_dat_i = 0;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case %0d: System Reset", test_num);
            reset_dut();

            #1;


            check_outputs(16'h0000, 16'h0000, 16'h0000, 20'h00000, 1'b0, 1'b0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case %0d: Load CS and IP", test_num);
            reset_dut();
            requested_cs = 16'h1000;
            requested_ip = 16'h0005;
            load_cs_ip = 1;
            @(posedge clk);
            #1 load_cs_ip = 0;
            @(posedge clk);


            #1;



            check_outputs(16'h1000, 16'h0000, 16'h0005, 20'h10005, 1'b0, 1'b1, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case %0d: Memory Transaction", test_num);
            reset_dut();
            requested_cs = 16'h2000;
            requested_ip = 16'h0100;
            load_cs_ip = 1;
            @(posedge clk);
            #1 load_cs_ip = 0;

            umi_ack_i = 1;
            umi_dat_i = 16'hABCD;
            @(posedge clk);
            #1 umi_ack_i = 0;

            #1;


            check_outputs(16'h2000, 16'hABCD, 16'h0102, 20'h20102, 1'b0, 1'b1, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case %0d: Flush Mechanism", test_num);
            reset_dut();
            requested_cs = 16'h3000;
            requested_ip = 16'h0200;
            load_cs_ip = 1;
            @(posedge clk);
            #1 load_cs_ip = 0;
            flush = 1;
            @(posedge clk);
            #1 flush = 0;

            #1;


            check_outputs(16'h3000, 16'h0000, 16'h0200, 20'h30200, 1'b0, 1'b0, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case %0d: FIFO Full Handling", test_num);
            reset_dut();
            requested_cs = 16'h4000;
            requested_ip = 16'h0300;
            load_cs_ip = 1;
            @(posedge clk);
            #1 load_cs_ip = 0;
            fifo_full = 1;
            umi_ack_i = 1;
            umi_dat_i = 16'h55AA;
            @(posedge clk);
            #1 umi_ack_i = 0;

            #1;


            check_outputs(16'h4000, 16'h55AA, 16'h0300, 20'h40300, 1'b0, 1'b0, 1'b0);
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
        input [15:0] expected_cs;
        input [15:0] expected_fifo_dat_o;
        input [15:0] expected_ip;
        input [19:0] expected_umi_adr_o;
        input expected_umi_by_o;
        input expected_umi_stb_o;
        input expected_wr_fifo;
        begin
            if (expected_cs === (expected_cs ^ cs ^ expected_cs) &&
                expected_fifo_dat_o === (expected_fifo_dat_o ^ fifo_dat_o ^ expected_fifo_dat_o) &&
                expected_ip === (expected_ip ^ ip ^ expected_ip) &&
                expected_umi_adr_o === (expected_umi_adr_o ^ umi_adr_o ^ expected_umi_adr_o) &&
                expected_umi_by_o === (expected_umi_by_o ^ umi_by_o ^ expected_umi_by_o) &&
                expected_umi_stb_o === (expected_umi_stb_o ^ umi_stb_o ^ expected_umi_stb_o) &&
                expected_wr_fifo === (expected_wr_fifo ^ wr_fifo ^ expected_wr_fifo)) begin
                $display("PASS");
                $display("  Outputs: cs=%h, fifo_dat_o=%h, ip=%h, umi_adr_o=%h, umi_by_o=%b, umi_stb_o=%b, wr_fifo=%b",
                         cs, fifo_dat_o, ip, umi_adr_o, umi_by_o, umi_stb_o, wr_fifo);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: cs=%h, fifo_dat_o=%h, ip=%h, umi_adr_o=%h, umi_by_o=%b, umi_stb_o=%b, wr_fifo=%b",
                         expected_cs, expected_fifo_dat_o, expected_ip, expected_umi_adr_o, expected_umi_by_o, expected_umi_stb_o, expected_wr_fifo);
                $display("  Got:      cs=%h, fifo_dat_o=%h, ip=%h, umi_adr_o=%h, umi_by_o=%b, umi_stb_o=%b, wr_fifo=%b",
                         cs, fifo_dat_o, ip, umi_adr_o, umi_by_o, umi_stb_o, wr_fifo);
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
        $dumpvars(0,clk, fifo_full, flush, load_cs_ip, requested_cs, requested_ip, rst, umi_ack_i, umi_dat_i, cs, fifo_dat_o, ip, umi_adr_o, umi_by_o, umi_stb_o, wr_fifo);
    end

endmodule
