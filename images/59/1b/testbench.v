`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [15:0] data_in_a;
    reg [15:0] data_in_b;
    reg enable;
    wire [31:0] result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .data_in_a(data_in_a),
        .data_in_b(data_in_b),
        .enable(enable),
        .result(result)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        data_in_a <= 0;
        data_in_b <= 0;
        enable <= 0;
        @(posedge clk);
        #1;
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("Test Case 001: Positive * Positive Accumulation");
        data_in_a = 16'sd10;
        data_in_b = 16'sd5;
        enable = 1;
        @(posedge clk);
        #1;
        expected_val = expected_val + (10 * 5);
        #1;

        check_outputs(expected_val);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test Case 002: Positive * Negative Accumulation");
        data_in_a = 16'sd7;
        data_in_b = 16'sd-3;
        enable = 1;
        @(posedge clk);
        #1;
        expected_val = expected_val + (7 * -3);
        #1;

        check_outputs(expected_val);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test Case 003: Negative * Negative Accumulation");
        data_in_a = 16'sd-4;
        data_in_b = 16'sd-6;
        enable = 1;
        @(posedge clk);
        #1;
        expected_val = expected_val + (-4 * -6);
        #1;

        check_outputs(expected_val);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test Case 004: Enable Signal Logic (Should not accumulate)");
        data_in_a = 16'sd100;
        data_in_b = 16'sd2;
        enable = 0;
        @(posedge clk);
        #1;

        #1;


        check_outputs(expected_val);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test Case 005: Zero Multiplication");
        data_in_a = 16'sd0;
        data_in_b = 16'sd999;
        enable = 1;
        @(posedge clk);
        #1;
        expected_val = expected_val + 0;
        #1;

        check_outputs(expected_val);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test Case 006: Max/Min Signed Multiplication");
        data_in_a = 16'sd32767;
        data_in_b = 16'sd2;
        enable = 1;
        @(posedge clk);
        #1;
        expected_val = expected_val + (32767 * 2);
        #1;

        check_outputs(expected_val);

        test_num = 7;
        data_in_a = 16'sd-32768;
        data_in_b = 16'sd2;
        enable = 1;
        @(posedge clk);
        #1;
        expected_val = expected_val + (-32768 * 2);
        #1;

        check_outputs(expected_val);
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
        input [31:0] expected_result;
        begin
            if (expected_result === (expected_result ^ result ^ expected_result)) begin
                $display("PASS");
                $display("  Outputs: result=%h",
                         result);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: result=%h",
                         expected_result);
                $display("  Got:      result=%h",
                         result);
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
        $dumpvars(0,clk, data_in_a, data_in_b, enable, result);
    end

endmodule
