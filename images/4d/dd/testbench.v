`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [15:0] a;
    reg [15:0] b;
    reg clk;
    reg rst;
    wire [15:0] sum;

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
        .sum(sum)
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
        @(posedge clk);
        #1 rst = 0;
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        reset_dut();
        a = 16'sd100;
        b = 16'sd250;
        @(posedge clk);
        #1;
        $display("Test Case 001: Simple Positive Addition (100 + 250)");
        #1;

        check_outputs(16'sd350);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        reset_dut();
        a = -16'sd50;
        b = -16'sd75;
        @(posedge clk);
        #1;
        $display("Test Case 002: Simple Negative Addition (-50 + -75)");
        #1;

        check_outputs(-16'sd125);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        reset_dut();
        a = 16'sd1000;
        b = -16'sd400;
        @(posedge clk);
        #1;
        $display("Test Case 003: Mixed Signs (1000 + -400)");
        #1;

        check_outputs(16'sd600);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        reset_dut();
        a = -16'sd1000;
        b = 16'sd400;
        @(posedge clk);
        #1;
        $display("Test Case 004: Mixed Signs (-1000 + 400)");
        #1;

        check_outputs(-16'sd600);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        reset_dut();
        a = 16'h7FFF;
        b = 16'sd0;
        @(posedge clk);
        #1;
        $display("Test Case 005: Max Positive + 0");
        #1;

        check_outputs(16'h7FFF);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        reset_dut();
        a = 16'h8000;
        b = 16'sd0;
        @(posedge clk);
        #1;
        $display("Test Case 006: Min Negative + 0");
        #1;

        check_outputs(16'h8000);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        reset_dut();
        a = 16'h7FFF;
        b = 16'sd1;
        @(posedge clk);
        #1;
        $display("Test Case 007: Signed Overflow (32767 + 1)");
        #1;

        check_outputs(16'h8000);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;

        rst = 1;
        a = 16'sd500;
        b = 16'sd500;
        @(posedge clk);
        #1;
        $display("Test Case 008: Reset Priority (Inputs active while rst=1)");
        #1;

        check_outputs(16'sd0);
        rst = 0;
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
        testcase008();
        
        
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
        input [15:0] expected_sum;
        begin
            if (expected_sum === (expected_sum ^ sum ^ expected_sum)) begin
                $display("PASS");
                $display("  Outputs: sum=%h",
                         sum);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: sum=%h",
                         expected_sum);
                $display("  Got:      sum=%h",
                         sum);
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
        $dumpvars(0,a, b, clk, rst, sum);
    end

endmodule
