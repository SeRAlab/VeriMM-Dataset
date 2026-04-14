`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg d;
    reg ena;
    reg reset;
    wire [7:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .d(d),
        .ena(ena),
        .reset(reset),
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
            #1 reset = 1;
            ena = 0;
            d = 0;
            @(posedge clk);
            #1 reset = 0;
        end
        endtask
    task testcase001;

        begin
            $display("Running Testcase 001: Synchronous Reset Check...");
            reset_dut();
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase002;

        integer i;
        begin
            $display("Running Testcase 002: Shift in 0xFF...");
            reset_dut();
            @(posedge clk);
            #1 ena = 1; d = 1;
            for (i = 0; i < 7; i = i + 1) begin
                @(posedge clk);
            end

            @(posedge clk);
            #1 ena = 0;
            #1;

            check_outputs(8'hFF);
        end
        endtask

    task testcase003;

        reg [7:0] pattern;
        integer i;
        begin
            $display("Running Testcase 003: Shift in pattern 0xA5...");
            pattern = 8'hA5;
            reset_dut();
            for (i = 0; i < 8; i = i + 1) begin
                @(posedge clk);
                #1 ena = 1; d = pattern[7-i];
            end
            @(posedge clk);
            #1 ena = 0;

            #1;


            check_outputs(8'hA5);
        end
        endtask

    task testcase004;

        begin
            $display("Running Testcase 004: Enable (ena) Signal Check...");
            reset_dut();
            @(posedge clk);
            #1 ena = 1; d = 1;
            @(posedge clk);
            #1 ena = 0; d = 0;
            @(posedge clk);
            #1 ena = 0; d = 1;
            @(posedge clk);
            #1 ena = 1; d = 1;
            @(posedge clk);
            #1 ena = 0;
            #1;

            check_outputs(8'h03);
        end
        endtask

    task testcase005;

        begin
            $display("Running Testcase 005: Reset Priority Check...");
            reset_dut();
            @(posedge clk);
            #1 ena = 1; d = 1;
            @(posedge clk);
            #1 ena = 1; d = 1;
            @(posedge clk);
            #1 reset = 1; ena = 1; d = 1;
            @(posedge clk);
            #1 reset = 0; ena = 0;
            #1;

            check_outputs(8'h00);
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
        input [7:0] expected_q;
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
        $dumpvars(0,clk, d, ena, reset, q);
    end

endmodule
