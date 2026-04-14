`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [2:0] data_in;
    reg load;
    reg rst;
    reg up_down;
    wire [2:0] count;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .data_in(data_in),
        .load(load),
        .rst(rst),
        .up_down(up_down),
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
            load = 0;
            up_down = 0;
            data_in = 0;
            @(posedge clk);
            #1 rst = 0;
        end
        endtask
    task testcase001;

        begin
            $display("Test Case 001: Basic Reset Verification");
            reset_dut();
            #1;

            check_outputs(3'd0);
        end
        endtask

    task testcase002;

        begin
            $display("Test Case 002: Up Counting (0 -> 1 -> 2 -> 3)");
            reset_dut();
            up_down = 1;
            repeat(3) @(posedge clk);
            #1 #1;
 check_outputs(3'd3);
        end
        endtask

    task testcase003;

        begin
            $display("Test Case 003: Down Counting from Zero (0 -> 7 -> 6)");
            reset_dut();
            up_down = 0;
            repeat(2) @(posedge clk);
            #1 #1;
 check_outputs(3'd6);
        end
        endtask

    task testcase004;

        begin
            $display("Test Case 004: Loading data_in=5");
            reset_dut();
            data_in = 3'd5;
            load = 1;
            @(posedge clk);
            #1 load = 0;
            #1;

            check_outputs(3'd5);
        end
        endtask

    task testcase005;

        begin
            $display("Test Case 005: Load 2 then Up 2 times (2 -> 3 -> 4)");
            reset_dut();
            data_in = 3'd2;
            load = 1;
            @(posedge clk);
            load = 0;
            up_down = 1;
            repeat(2) @(posedge clk);
            #1 #1;
 check_outputs(3'd4);
        end
        endtask

    task testcase006;

        begin
            $display("Test Case 006: Load 1 then Down 2 times (1 -> 0 -> 7)");
            reset_dut();
            data_in = 3'd1;
            load = 1;
            @(posedge clk);
            load = 0;
            up_down = 0;
            repeat(2) @(posedge clk);
            #1 #1;
 check_outputs(3'd7);
        end
        endtask

    task testcase007;

        begin
            $display("Test Case 007: Increment from 7 to 0");
            reset_dut();
            data_in = 3'd7;
            load = 1;
            @(posedge clk);
            load = 0;
            up_down = 1;
            @(posedge clk);
            #1 #1;
 check_outputs(3'd0);
        end
        endtask

    task testcase008;

        begin
            $display("Test Case 008: Load should override up_down counting");
            reset_dut();
            up_down = 1;
            data_in = 3'd4;
            load = 1;
            @(posedge clk);
            #1 #1;
 check_outputs(3'd4);
        end
        endtask

    task testcase009;

        begin
            $display("Test Case 009: Reset should override Load");
            reset_dut();
            load = 1;
            data_in = 3'd6;
            rst = 1;
            @(posedge clk);
            #1 #1;
 check_outputs(3'd0);
        end
        endtask

    task testcase010;

        begin
            $display("Test Case 010: Up count full cycle (8 pulses)");
            reset_dut();
            up_down = 1;
            repeat(8) @(posedge clk);
            #1 #1;
 check_outputs(3'd0);
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
        input [2:0] expected_count;
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
        $dumpvars(0,clk, data_in, load, rst, up_down, count);
    end

endmodule
