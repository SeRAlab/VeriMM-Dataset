`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [15:0] a;
    reg [15:0] b;
    reg clk;
    reg reset;
    wire [15:0] diff;
    wire [16:0] sum;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .clk(clk),
        .reset(reset),
        .diff(diff),
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
            a = 0;
            b = 0;
            @(posedge clk);
            #1;
            reset = 0;
        end
        endtask
    task testcase001;

        begin
            reset = 1;
            a = 16'sd100;
            b = 16'sd50;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'sd0, 17'sd0);
            reset = 0;
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            a = 16'sd500;
            b = 16'sd200;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'sd300, 17'sd700);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            a = 16'sd150;
            b = 16'sd400;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'sd250, 17'sd550);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            a = -16'sd100;
            b = -16'sd200;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'sd100, -17'sd300);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            a = 16'sd1000;
            b = -16'sd400;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'sd1400, 17'sd600);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            a = -16'sd2000;
            b = 16'sd500;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'sd2500, -17'sd1500);
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            a = 16'sd0;
            b = 16'sd0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'sd0, 17'sd0);
        end
        endtask

    task testcase008;

        begin
            reset_dut();
            a = 16'sd32767;
            b = 16'sd32767;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'sd0, 17'sd65534);
        end
        endtask

    task testcase009;

        begin
            reset_dut();
            a = -16'sd32768;
            b = -16'sd32768;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'sd0, -17'sd65536);
        end
        endtask

    task testcase010;

        begin
            reset_dut();
            a = 16'sd16000;
            b = -16'sd16000;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'sd32000, 17'sd0);
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
        testcase009();
        testcase010();
        
        
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
        input [15:0] expected_diff;
        input [16:0] expected_sum;
        begin
            if (expected_diff === (expected_diff ^ diff ^ expected_diff) &&
                expected_sum === (expected_sum ^ sum ^ expected_sum)) begin
                $display("PASS");
                $display("  Outputs: diff=%h, sum=%h",
                         diff, sum);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: diff=%h, sum=%h",
                         expected_diff, expected_sum);
                $display("  Got:      diff=%h, sum=%h",
                         diff, sum);
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
        $dumpvars(0,a, b, clk, reset, diff, sum);
    end

endmodule
