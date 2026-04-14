`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [15:0] d_in;
    reg rst_n;
    wire [27:0] d_out;
    wire d_out_valid;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .d_in(d_in),
        .rst_n(rst_n),
        .d_out(d_out),
        .d_out_valid(d_out_valid)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst_n = 0;
            d_in = 0;
            repeat(5) @(posedge clk);
            #1 rst_n = 1;
            repeat(5) @(posedge clk);
        end
        endtask
    task wait_for_settling;

        input integer num_valids;
        integer i;
        begin
            for (i = 0; i < num_valids; i = i + 1) begin
                @(posedge clk);
                while (!d_out_valid) @(posedge clk);
            end
        end
        endtask

    task testcase001;

        begin
            test_num = 1;
            $display("Testcase 001: Constant Input 1 (Expected Gain 1024)");
            reset_dut();
            d_in = 16'sd1;
            wait_for_settling(8);
            #1 #1;
 check_outputs(28'sd1024, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase 002: Constant Input -1 (Expected -1024)");
            reset_dut();
            d_in = -16'sd1;
            wait_for_settling(8);
            #1 #1;
 check_outputs(-28'sd1024, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase 003: Zero Input (Expected 0)");
            reset_dut();
            d_in = 16'sd0;
            wait_for_settling(4);
            #1 #1;
 check_outputs(28'sd0, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase 004: Max Positive Input 32767");
            reset_dut();
            d_in = 16'sd32767;
            wait_for_settling(8);
            #1 #1;
 check_outputs(28'sd33553408, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase 005: Max Negative Input -32768");
            reset_dut();
            d_in = -16'sd32768;
            wait_for_settling(8);
            #1 #1;
 check_outputs(-28'sd33554432, 1'b1);
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
        input [27:0] expected_d_out;
        input expected_d_out_valid;
        begin
            if (expected_d_out === (expected_d_out ^ d_out ^ expected_d_out) &&
                expected_d_out_valid === (expected_d_out_valid ^ d_out_valid ^ expected_d_out_valid)) begin
                $display("PASS");
                $display("  Outputs: d_out=%h, d_out_valid=%b",
                         d_out, d_out_valid);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: d_out=%h, d_out_valid=%b",
                         expected_d_out, expected_d_out_valid);
                $display("  Got:      d_out=%h, d_out_valid=%b",
                         d_out, d_out_valid);
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
        $dumpvars(0,clk, d_in, rst_n, d_out, d_out_valid);
    end

endmodule
