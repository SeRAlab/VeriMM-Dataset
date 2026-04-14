`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg ena;
    reg reset;
    reg up;
    wire [31:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .ena(ena),
        .reset(reset),
        .up(up),
        .q(q)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            ena = 0;
            up = 0;
            @(negedge clk);
            reset = 0;
            @(negedge clk);
        end
        endtask
    task testcase001;

        begin
            $display("Testcase 001: Checking reset state...");
            test_num = 1;
            reset_dut();
            #1;

            check_outputs(32'h0);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Counting up 10 times...");
            test_num = 2;
            reset_dut();
            ena = 1;
            up = 1;
            repeat (10) @(negedge clk);
            #1;

            check_outputs(32'd10);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Counting down from 0 (Underflow)...");
            test_num = 3;
            reset_dut();
            ena = 1;
            up = 0;
            @(negedge clk);
            #1;

            check_outputs(32'hFFFFFFFF);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Counting up while disabled (ena=0)...");
            test_num = 4;
            reset_dut();
            up = 1;
            ena = 0;
            repeat (5) @(negedge clk);
            #1;

            check_outputs(32'h0);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Up 10 steps, Down 4 steps...");
            test_num = 5;
            reset_dut();
            ena = 1;
            up = 1;
            repeat (10) @(negedge clk);
            up = 0;
            repeat (4) @(negedge clk);
            #1;

            check_outputs(32'd6);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: Enable toggling...");
            test_num = 6;
            reset_dut();
            up = 1;
            ena = 1;
            repeat (5) @(negedge clk);
            ena = 0;
            repeat (5) @(negedge clk);
            ena = 1;
            repeat (2) @(negedge clk);
            #1;

            check_outputs(32'd7);
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
        input [31:0] expected_q;
        begin
            if (expected_q === (expected_q ^ q ^ expected_q)) begin
                $display("PASS");
                $display("  Outputs: q=%h",
                         q);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: q=%h",
                         expected_q);
                $display("  Got:      q=%h",
                         q);
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
        $dumpvars(0,clk, ena, reset, up, q);
    end

endmodule
