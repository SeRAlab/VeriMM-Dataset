`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg d;
    reg pause;
    reg reset;
    reg resume;
    wire [3:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .d(d),
        .pause(pause),
        .reset(reset),
        .resume(resume),
        .q(q)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            @(posedge clk);
            reset = 1;
            d = 0;
            pause = 0;
            resume = 0;
            @(posedge clk);
            #1 reset = 0;
        end
        endtask
    task testcase001;

        begin
            $display("Running Testcase 001: Basic Counting...");
            reset_dut();
            resume = 1;
            @(posedge clk);
            resume = 0;
            repeat(4) @(posedge clk);
            #1;
            #1;

            check_outputs(4'd5);
        end
        endtask

    task testcase002;

        begin
            $display("Running Testcase 002: Pause and Resume...");
            reset_dut();
            resume = 1; @(posedge clk);
            resume = 0; @(posedge clk);
            pause = 1;  @(posedge clk);
            pause = 0;
            repeat(3) @(posedge clk);
            resume = 1; @(posedge clk);
            resume = 0; @(posedge clk);
            #1;
            #1;

            check_outputs(4'd4);
        end
        endtask

    task testcase003;

        begin
            $display("Running Testcase 003: Threshold Blocking (q + SR > 12)...");
            reset_dut();
            resume = 1;
            d = 1;






            repeat(10) @(posedge clk);
            #1;
            #1;

            check_outputs(4'd5);
        end
        endtask

    task testcase004;

        begin
            $display("Running Testcase 004: Decade Wrap-around (9 -> 0)...");
            reset_dut();
            resume = 1;
            d = 0;
            repeat(12) @(posedge clk);
            #1;
            #1;

            check_outputs(4'd2);
        end
        endtask

    task testcase005;

        begin
            $display("Running Testcase 005: Recovery from Threshold Block...");
            reset_dut();
            resume = 1;
            d = 1;
            repeat(6) @(posedge clk);
            d = 0; @(posedge clk);
            d = 0; @(posedge clk);
            #1;
            #1;

            check_outputs(4'd7);
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
        input [3:0] expected_q;
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
        $dumpvars(0,clk, d, pause, reset, resume, q);
    end

endmodule
