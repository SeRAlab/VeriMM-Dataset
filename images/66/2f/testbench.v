`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clear;
    reg clk;
    reg [18:0] f19_data;
    reg f19_src_rdy_i;
    reg ll_dst_rdy_n;
    reg reset;
    wire f19_dst_rdy_o;
    wire [7:0] ll_data;
    wire ll_eof_n;
    wire ll_sof_n;
    wire ll_src_rdy_n;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clear(clear),
        .clk(clk),
        .f19_data(f19_data),
        .f19_src_rdy_i(f19_src_rdy_i),
        .ll_dst_rdy_n(ll_dst_rdy_n),
        .reset(reset),
        .f19_dst_rdy_o(f19_dst_rdy_o),
        .ll_data(ll_data),
        .ll_eof_n(ll_eof_n),
        .ll_sof_n(ll_sof_n),
        .ll_src_rdy_n(ll_src_rdy_n)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        reset = 1;
        clear = 0;
        f19_data = 0;
        f19_src_rdy_i = 0;
        ll_dst_rdy_n = 1;
        #20;
        @(posedge clk);
        #1;
        reset = 0;
        ll_dst_rdy_n = 0;
        @(posedge clk);
        #1;
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("\nTestcase %0d: Idle State after Reset", test_num);
        reset_dut();


        #1;



        check_outputs(1, 8'h00, 1, 1, 1);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("\nTestcase %0d: SOF - Check first byte out of two", test_num);
        reset_dut();


        f19_data = {1'b0, 1'b0, 1'b1, 8'hAA, 8'h55};
        f19_src_rdy_i = 1;

        @(posedge clk);
        while (!f19_dst_rdy_o) @(posedge clk);
        #1;
        f19_src_rdy_i = 0;


        @(posedge clk);
        #1;
        #1;

        check_outputs(0, 8'hAA, 1, 0, 0);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("\nTestcase %0d: EOF - Check second byte out of two", test_num);
        reset_dut();


        f19_data = {1'b0, 1'b1, 1'b0, 8'hCC, 8'h33};
        f19_src_rdy_i = 1;

        @(posedge clk);
        while (!f19_dst_rdy_o) @(posedge clk);
        #1;
        f19_src_rdy_i = 0;


        @(posedge clk);

        @(posedge clk);
        #1;
        #1;

        check_outputs(1, 8'h33, 0, 1, 0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("\nTestcase %0d: Backpressure (ll_dst_rdy_n = 1)", test_num);
        reset_dut();


        ll_dst_rdy_n = 1;


        f19_data = {3'b000, 8'h11, 8'h22};
        f19_src_rdy_i = 1;

        @(posedge clk);
        while (!f19_dst_rdy_o) @(posedge clk);
        #1;
        f19_src_rdy_i = 0;


        repeat(3) @(posedge clk);
        #1;


        #1;



        check_outputs(0, 8'h11, 1, 1, 0);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("\nTestcase %0d: Clear signal during operation", test_num);
        reset_dut();


        f19_data = {3'b000, 8'h88, 8'h99};
        f19_src_rdy_i = 1;
        @(posedge clk);
        #1;
        f19_src_rdy_i = 0;


        @(posedge clk);
        #1;
        clear = 1;
        @(posedge clk);
        #1;
        clear = 0;


        #1;



        check_outputs(1, 8'h00, 1, 1, 1);
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
        input expected_f19_dst_rdy_o;
        input [7:0] expected_ll_data;
        input expected_ll_eof_n;
        input expected_ll_sof_n;
        input expected_ll_src_rdy_n;
        begin
            if (expected_f19_dst_rdy_o === (expected_f19_dst_rdy_o ^ f19_dst_rdy_o ^ expected_f19_dst_rdy_o) &&
                expected_ll_data === (expected_ll_data ^ ll_data ^ expected_ll_data) &&
                expected_ll_eof_n === (expected_ll_eof_n ^ ll_eof_n ^ expected_ll_eof_n) &&
                expected_ll_sof_n === (expected_ll_sof_n ^ ll_sof_n ^ expected_ll_sof_n) &&
                expected_ll_src_rdy_n === (expected_ll_src_rdy_n ^ ll_src_rdy_n ^ expected_ll_src_rdy_n)) begin
                $display("PASS");
                $display("  Outputs: f19_dst_rdy_o=%b, ll_data=%h, ll_eof_n=%b, ll_sof_n=%b, ll_src_rdy_n=%b",
                         f19_dst_rdy_o, ll_data, ll_eof_n, ll_sof_n, ll_src_rdy_n);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: f19_dst_rdy_o=%b, ll_data=%h, ll_eof_n=%b, ll_sof_n=%b, ll_src_rdy_n=%b",
                         expected_f19_dst_rdy_o, expected_ll_data, expected_ll_eof_n, expected_ll_sof_n, expected_ll_src_rdy_n);
                $display("  Got:      f19_dst_rdy_o=%b, ll_data=%h, ll_eof_n=%b, ll_sof_n=%b, ll_src_rdy_n=%b",
                         f19_dst_rdy_o, ll_data, ll_eof_n, ll_sof_n, ll_src_rdy_n);
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
        $dumpvars(0,clear, clk, f19_data, f19_src_rdy_i, ll_dst_rdy_n, reset, f19_dst_rdy_o, ll_data, ll_eof_n, ll_sof_n, ll_src_rdy_n);
    end

endmodule
