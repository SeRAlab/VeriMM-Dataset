`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg en;
    reg rst;
    reg up;
    reg [31:0] width;
    wire [31:0] count;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .en(en),
        .rst(rst),
        .up(up),
        .width(width),
        .count(count)
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
            up = 0;
            width = 0;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case 001: Reset Check");
            reset_dut();
            #1;

            check_outputs(32'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case 002: Basic Up Counting");
            reset_dut();
            width = 32'd100;
            en = 1;
            up = 1;
            repeat(10) @(posedge clk);
            en = 0;
            #1 #1;
 check_outputs(32'd10);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case 003: Upward Wrap-around");
            reset_dut();
            width = 32'd2;
            en = 1;
            up = 1;
            repeat(4) @(posedge clk);
            en = 0;
            #1 #1;
 check_outputs(32'd1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case 004: Basic Down Counting");
            reset_dut();
            width = 32'd50;
            en = 1;
            up = 1;
            repeat(10) @(posedge clk);
            up = 0;
            repeat(4) @(posedge clk);
            en = 0;
            #1 #1;
 check_outputs(32'd6);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case 005: Downward Wrap-around from 0");
            reset_dut();
            width = 32'd15;
            en = 1;
            up = 0;
            repeat(2) @(posedge clk);
            en = 0;
            #1 #1;
 check_outputs(32'd14);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test Case 006: Enable Signal Inhibition");
            reset_dut();
            width = 32'd100;
            en = 1;
            up = 1;
            repeat(5) @(posedge clk);
            en = 0;
            repeat(5) @(posedge clk);
            #1 #1;
 check_outputs(32'd5);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test Case 007: Max 32-bit Width Wrap");
            reset_dut();
            width = 32'hFFFFFFFF;
            en = 1;
            up = 0;
            @(posedge clk);
            en = 0;
            #1 #1;
 check_outputs(32'hFFFFFFFF);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Test Case 008: Mid-operation Reset");
            reset_dut();
            width = 32'd100;
            en = 1;
            up = 1;
            repeat(20) @(posedge clk);
            rst = 1;
            @(posedge clk);
            rst = 0;
            #1 #1;
 check_outputs(32'd0);
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
        input [31:0] expected_count;
        begin
            if (expected_count === (expected_count ^ count ^ expected_count)) begin
                $display("PASS");
                $display("  Outputs: count=%h",
                         count);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: count=%h",
                         expected_count);
                $display("  Got:      count=%h",
                         count);
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
        $dumpvars(0,clk, en, rst, up, width, count);
    end

endmodule
