`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] input1;
    reg [3:0] input2;
    reg reset;
    wire [1:0] comparison_result;
    wire [3:0] sum;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .input1(input1),
        .input2(input2),
        .reset(reset),
        .comparison_result(comparison_result),
        .sum(sum)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        reset = 1;
        input1 = 0;
        input2 = 0;
        @(posedge clk);
        #1;
        reset = 0;
    end
        endtask
    task testcase001;

    begin
        reset_dut();
        test_num = 1;
        $display("Testcase 001: Reset Initialization");

        #1;


        check_outputs(2'b00, 4'b0000);
    end
        endtask

    task testcase002;

    begin
        reset_dut();
        test_num = 2;
        $display("Testcase 002: Sum bits 00 < 10");
        input1 = 4'd1;
        input2 = 4'd2;
        @(posedge clk);
        #1;
        #1;

        check_outputs(2'b00, 4'd3);
    end
        endtask

    task testcase003;

    begin
        reset_dut();
        test_num = 3;
        $display("Testcase 003: Sum bits 10 == 10");
        input1 = 4'd4;
        input2 = 4'd4;
        @(posedge clk);
        #1;
        #1;

        check_outputs(2'b01, 4'd8);
    end
        endtask

    task testcase004;

    begin
        reset_dut();
        test_num = 4;
        $display("Testcase 004: Sum bits 11 > 10");
        input1 = 4'd6;
        input2 = 4'd6;
        @(posedge clk);
        #1;
        #1;

        check_outputs(2'b10, 4'd12);
    end
        endtask

    task testcase005;

    begin
        reset_dut();
        test_num = 5;
        $display("Testcase 005: Boundary LT (Sum 7)");
        input1 = 4'd3;
        input2 = 4'd4;
        @(posedge clk);
        #1;
        #1;

        check_outputs(2'b00, 4'd7);
    end
        endtask

    task testcase006;

    begin
        reset_dut();
        test_num = 6;
        $display("Testcase 006: Boundary EQ (Sum 11)");
        input1 = 4'd5;
        input2 = 4'd6;
        @(posedge clk);
        #1;
        #1;

        check_outputs(2'b01, 4'd11);
    end
        endtask

    task testcase007;

    begin
        reset_dut();
        test_num = 7;
        $display("Testcase 007: Overflow Truncation");
        input1 = 4'd10;
        input2 = 4'd10;
        @(posedge clk);
        #1;
        #1;

        check_outputs(2'b00, 4'd4);
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
        testcase007();
        
        
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
        input [1:0] expected_comparison_result;
        input [3:0] expected_sum;
        begin
            if (expected_comparison_result === (expected_comparison_result ^ comparison_result ^ expected_comparison_result) &&
                expected_sum === (expected_sum ^ sum ^ expected_sum)) begin
                $display("PASS");
                $display("  Outputs: comparison_result=%h, sum=%h",
                         comparison_result, sum);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: comparison_result=%h, sum=%h",
                         expected_comparison_result, expected_sum);
                $display("  Got:      comparison_result=%h, sum=%h",
                         comparison_result, sum);
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
        $dumpvars(0,clk, input1, input2, reset, comparison_result, sum);
    end

endmodule
