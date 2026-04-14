`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] d_in;
    reg rxf_n_in;
    wire [7:0] d_out;
    wire [3:0] led;
    wire rd_n_buf;
    wire rd_n_out;
    wire rxf_n_out;
    wire wr_n_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .d_in(d_in),
        .rxf_n_in(rxf_n_in),
        .d_out(d_out),
        .led(led),
        .rd_n_buf(rd_n_buf),
        .rd_n_out(rd_n_out),
        .rxf_n_out(rxf_n_out),
        .wr_n_out(wr_n_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        rxf_n_in = 1'b1;
        d_in = 8'h00;
        @(posedge clk);
        #1;
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("Test Case 001: Initial Idle State");
        reset_dut();
        repeat(2) @(posedge clk);

        #1;


        check_outputs(8'h00, 4'h0, 1'b1, 1'b1, 1'b1, 1'b1);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test Case 002: Data Transfer 0xA5");
        reset_dut();

        rxf_n_in = 1'b0;
        d_in = 8'hA5;


        repeat(5) @(posedge clk);


        #1;



        check_outputs(8'hA5, 4'h5, 1'b0, 1'b0, 1'b0, 1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test Case 003: Data Transfer 0x3C");
        reset_dut();

        rxf_n_in = 1'b0;
        d_in = 8'h3C;

        repeat(5) @(posedge clk);


        #1;



        check_outputs(8'h3C, 4'hC, 1'b0, 1'b0, 1'b0, 1'b1);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test Case 004: Hold Last Value");
        reset_dut();


        rxf_n_in = 1'b0;
        d_in = 8'hFF;
        repeat(5) @(posedge clk);


        rxf_n_in = 1'b1;
        d_in = 8'h00;
        repeat(3) @(posedge clk);


        #1;



        check_outputs(8'hFF, 4'hF, 1'b1, 1'b1, 1'b1, 1'b1);
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
        input [7:0] expected_d_out;
        input [3:0] expected_led;
        input expected_rd_n_buf;
        input expected_rd_n_out;
        input expected_rxf_n_out;
        input expected_wr_n_out;
        begin
            if (expected_d_out === (expected_d_out ^ d_out ^ expected_d_out) &&
                expected_led === (expected_led ^ led ^ expected_led) &&
                expected_rd_n_buf === (expected_rd_n_buf ^ rd_n_buf ^ expected_rd_n_buf) &&
                expected_rd_n_out === (expected_rd_n_out ^ rd_n_out ^ expected_rd_n_out) &&
                expected_rxf_n_out === (expected_rxf_n_out ^ rxf_n_out ^ expected_rxf_n_out) &&
                expected_wr_n_out === (expected_wr_n_out ^ wr_n_out ^ expected_wr_n_out)) begin
                $display("PASS");
                $display("  Outputs: d_out=%h, led=%h, rd_n_buf=%b, rd_n_out=%b, rxf_n_out=%b, wr_n_out=%b",
                         d_out, led, rd_n_buf, rd_n_out, rxf_n_out, wr_n_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: d_out=%h, led=%h, rd_n_buf=%b, rd_n_out=%b, rxf_n_out=%b, wr_n_out=%b",
                         expected_d_out, expected_led, expected_rd_n_buf, expected_rd_n_out, expected_rxf_n_out, expected_wr_n_out);
                $display("  Got:      d_out=%h, led=%h, rd_n_buf=%b, rd_n_out=%b, rxf_n_out=%b, wr_n_out=%b",
                         d_out, led, rd_n_buf, rd_n_out, rxf_n_out, wr_n_out);
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
        $dumpvars(0,clk, d_in, rxf_n_in, d_out, led, rd_n_buf, rd_n_out, rxf_n_out, wr_n_out);
    end

endmodule
