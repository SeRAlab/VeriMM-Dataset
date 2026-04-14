`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] a;
    reg [5:0] b;
    reg clk;
    reg en;
    reg rst;
    wire [13:0] p;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .clk(clk),
        .en(en),
        .rst(rst),
        .p(p)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            en = 0;
            a = 0;
            b = 0;
            @(posedge clk);
            #2 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            $display("Testcase 001: 10 * 5");
            reset_dut();
            a = 8'sd10;
            b = 6'sd5;
            en = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(14'sd50);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: -10 * 5");
            reset_dut();
            a = -8'sd10;
            b = 6'sd5;
            en = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(-14'sd50);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: 10 * -5");
            reset_dut();
            a = 8'sd10;
            b = -6'sd5;
            en = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(-14'sd50);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: -10 * -5");
            reset_dut();
            a = -8'sd10;
            b = -6'sd5;
            en = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(14'sd50);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: 127 * 0");
            reset_dut();
            a = 8'sd127;
            b = 6'sd0;
            en = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(14'sd0);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: 127 * 31 (Max Positive)");
            reset_dut();
            a = 8'sd127;
            b = 6'sd31;
            en = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(14'sd3937);
        end
        endtask

    task testcase007;

        begin
            $display("Testcase 007: -128 * -32 (Max Negative)");
            reset_dut();
            a = -8'sd128;
            b = -6'sd32;
            en = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(14'sd4096);
        end
        endtask

    task testcase008;

        begin
            $display("Testcase 008: -128 * 31");
            reset_dut();
            a = -8'sd128;
            b = 6'sd31;
            en = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(-14'sd3968);
        end
        endtask

    task testcase009;

        begin
            $display("Testcase 009: Enable signal test (en=0)");
            reset_dut();

            a = 8'sd10; b = 6'sd2; en = 1;
            @(posedge clk);
            #1;

            a = 8'sd20; b = 6'sd3; en = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(14'sd20);
        end
        endtask

    task testcase010;

        begin
            $display("Testcase 010: Reset check");
            reset_dut();
            a = 8'sd15; b = 6'sd4; en = 1;
            @(posedge clk);
            #1;
            rst = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(14'sd0);
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
        input [13:0] expected_p;
        begin
            if (expected_p === (expected_p ^ p ^ expected_p)) begin
                $display("PASS");
                $display("  Outputs: p=%h",
                         p);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: p=%h",
                         expected_p);
                $display("  Got:      p=%h",
                         p);
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
        $dumpvars(0,a, b, clk, en, rst, p);
    end

endmodule
