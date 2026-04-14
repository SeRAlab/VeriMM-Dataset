`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data_in;
    reg ena;
    reg load;
    reg ready_b;
    reg rst_n;
    reg valid_a;
    wire [9:0] data_out;
    wire [3:0] q;
    wire ready_a;
    wire valid_b;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .data_in(data_in),
        .ena(ena),
        .load(load),
        .ready_b(ready_b),
        .rst_n(rst_n),
        .valid_a(valid_a),
        .data_out(data_out),
        .q(q),
        .ready_a(ready_a),
        .valid_b(valid_b)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        rst_n = 0;
        data_in = 0;
        ena = 0;
        load = 0;
        valid_a = 0;
        ready_b = 0;
        @(posedge clk);
        #2 rst_n = 1;
        @(posedge clk);
    end
        endtask
    task testcase001;

    begin
        $display("testcase001: Basic Accumulation");
        reset_dut();
        data_in = 8'd25;
        ena = 1;
        @(posedge clk);
        #1;
        #1;

        check_outputs(10'd25, 4'h0, 0, 0);
    end
        endtask

    task testcase002;

    begin
        $display("testcase002: Multi-step Accumulation");
        reset_dut();
        data_in = 8'd10;
        ena = 1;
        @(posedge clk);
        data_in = 8'd20;
        @(posedge clk);
        #1;
        #1;

        check_outputs(10'd30, 4'h0, 0, 0);
    end
        endtask

    task testcase003;

    begin
        $display("testcase003: Shift Register Load");
        reset_dut();
        data_in = 8'hA5;
        load = 1;
        @(posedge clk);
        #1;
        #1;

        check_outputs(10'h000, 4'h5, 0, 1);
    end
        endtask

    task testcase004;

    begin
        $display("testcase004: Shift Register Shifting");
        reset_dut();
        data_in = 8'h01;
        load = 1;
        @(posedge clk);
        load = 0;
        ena = 1;
        data_in = 8'h00;
        @(posedge clk);
        #1;
        #1;

        check_outputs(10'h000, 4'h2, 0, 1);
    end
        endtask

    task testcase005;

    begin
        $display("testcase005: Handshake Ready_a Signal");
        reset_dut();
        ready_b = 1;
        valid_a = 1;
        #1;

        #1;


        check_outputs(10'h000, 4'h0, 1, 1);
    end
        endtask

    task testcase006;

    begin
        $display("testcase006: Valid_b Readiness Check");
        reset_dut();

        ena = 1;
        data_in = 8'hFF;
        repeat(4) @(posedge clk);
        data_in = 8'h04;
        @(posedge clk);
        #1;
        #1;

        check_outputs(10'h000, 4'h0, 0, 1);
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
        input [9:0] expected_data_out;
        input [3:0] expected_q;
        input expected_ready_a;
        input expected_valid_b;
        begin
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out) &&
                expected_q === (expected_q ^ q ^ expected_q) &&
                expected_ready_a === (expected_ready_a ^ ready_a ^ expected_ready_a) &&
                expected_valid_b === (expected_valid_b ^ valid_b ^ expected_valid_b)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h, q=%h, ready_a=%b, valid_b=%b",
                         data_out, q, ready_a, valid_b);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h, q=%h, ready_a=%b, valid_b=%b",
                         expected_data_out, expected_q, expected_ready_a, expected_valid_b);
                $display("  Got:      data_out=%h, q=%h, ready_a=%b, valid_b=%b",
                         data_out, q, ready_a, valid_b);
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
        $dumpvars(0,clk, data_in, ena, load, ready_b, rst_n, valid_a, data_out, q, ready_a, valid_b);
    end

endmodule
