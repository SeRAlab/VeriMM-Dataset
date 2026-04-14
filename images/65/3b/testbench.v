`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [30:0] a;
    reg [30:0] b;
    reg clk;
    reg rst;
    wire [96:0] _97bit_round;
    wire [31:0] adder_result;
    wire clk_echo;
    wire [15:0] counter;
    wire counter_rdy;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .clk(clk),
        .rst(rst),
        ._97bit_round(_97bit_round),
        .adder_result(adder_result),
        .clk_echo(clk_echo),
        .counter(counter),
        .counter_rdy(counter_rdy)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            a = 0;
            b = 0;
            repeat(2) @(posedge clk);
            #1 rst = 0;
            $display("DUT Reset Complete");
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            a = 31'd100;
            b = 31'd200;

            @(posedge clk);
            #2;


            #1;



            check_outputs(97'h0, 32'd300, 1'b1, 16'd1, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            a = 31'h7FFFFFFF;
            b = 31'h7FFFFFFF;
            repeat(5) @(posedge clk);
            #2;

            #1;


            check_outputs(97'h0, 32'hFFFFFFFE, 1'b1, 16'd5, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            a = 31'h0;
            b = 31'h0;
            repeat(10) @(posedge clk);
            #2;

            #1;


            check_outputs(97'h0, 32'h0, 1'b1, 16'd10, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            a = 31'h40000000;
            b = 31'h40000000;
            repeat(2) @(posedge clk);
            #2;

            #1;


            check_outputs(97'h0, 32'h80000000, 1'b1, 16'd2, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            a = 31'd5;
            b = 31'd5;

            repeat(100) @(posedge clk);
            #2;
            #1;

            check_outputs(97'h0, 32'd10, 1'b1, 16'd100, 1'b1);
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
        input [96:0] expected__97bit_round;
        input [31:0] expected_adder_result;
        input expected_clk_echo;
        input [15:0] expected_counter;
        input expected_counter_rdy;
        begin
            if (expected__97bit_round === (expected__97bit_round ^ _97bit_round ^ expected__97bit_round) &&
                expected_adder_result === (expected_adder_result ^ adder_result ^ expected_adder_result) &&
                expected_clk_echo === (expected_clk_echo ^ clk_echo ^ expected_clk_echo) &&
                expected_counter === (expected_counter ^ counter ^ expected_counter) &&
                expected_counter_rdy === (expected_counter_rdy ^ counter_rdy ^ expected_counter_rdy)) begin
                $display("PASS");
                $display("  Outputs: _97bit_round=%h, adder_result=%h, clk_echo=%b, counter=%h, counter_rdy=%b",
                         _97bit_round, adder_result, clk_echo, counter, counter_rdy);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: _97bit_round=%h, adder_result=%h, clk_echo=%b, counter=%h, counter_rdy=%b",
                         expected__97bit_round, expected_adder_result, expected_clk_echo, expected_counter, expected_counter_rdy);
                $display("  Got:      _97bit_round=%h, adder_result=%h, clk_echo=%b, counter=%h, counter_rdy=%b",
                         _97bit_round, adder_result, clk_echo, counter, counter_rdy);
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
        $dumpvars(0,a, b, clk, rst, _97bit_round, adder_result, clk_echo, counter, counter_rdy);
    end

endmodule
