`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg d;
    reg reset_n;
    reg shift;
    wire [7:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .d(d),
        .reset_n(reset_n),
        .shift(shift),
        .q(q)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset_n = 0;
            shift = 0;
            d = 0;
            #15;
            reset_n = 1;
            #10;
        end
        endtask
    task testcase001;

        begin
            $display("Running Testcase 001: Reset Check");
            reset_dut();
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase002;

        begin
            $display("Running Testcase 002: Single Shift '1'");
            reset_dut();
            @(negedge clk);
            shift = 1;
            d = 1;
            @(negedge clk);
            shift = 0;
            #1;

            check_outputs(8'h01);
        end
        endtask

    task testcase003;

        begin
            $display("Running Testcase 003: Sequence Shift (1011)");
            reset_dut();
            @(negedge clk);
            shift = 1; d = 1; @(negedge clk);
            shift = 1; d = 0; @(negedge clk);
            shift = 1; d = 1; @(negedge clk);
            shift = 1; d = 1; @(negedge clk);
            shift = 0;
            #1;

            check_outputs(8'h0B);
        end
        endtask

    task testcase004;

        begin
            $display("Running Testcase 004: Shift Enable Check");
            reset_dut();
            @(negedge clk);
            shift = 1; d = 1; @(negedge clk);
            shift = 0; d = 1; @(negedge clk);
            shift = 0; d = 0; @(negedge clk);
            #1;

            check_outputs(8'h01);
        end
        endtask

    task testcase005;

        integer i;
        reg [7:0] pattern;
        begin
            $display("Running Testcase 005: Full Register Fill (AA)");
            reset_dut();
            pattern = 8'hAA;
            @(negedge clk);
            shift = 1;
            for (i = 0; i < 8; i = i + 1) begin
                d = pattern[7-i];


                d = (i % 2 == 0) ? 1 : 0;
                @(negedge clk);
            end
            shift = 0;
            #1;

            check_outputs(8'hAA);
        end
        endtask

    task testcase006;

        begin
            $display("Running Testcase 006: Asynchronous Reset Mid-Operation");
            reset_dut();
            @(negedge clk);
            shift = 1; d = 1; @(negedge clk);
            shift = 1; d = 1; @(negedge clk);
            #2;
            reset_n = 0;
            #5;
            #1;

            check_outputs(8'h00);
            reset_n = 1;
        end
        endtask

    task testcase007;

        begin
            $display("Running Testcase 007: Overflow Check");
            reset_dut();
            @(negedge clk);
            shift = 1; d = 1;
            repeat(10) @(negedge clk);
            shift = 0;
            #1;

            check_outputs(8'hFF);
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
        $dumpvars(0,clk, d, reset_n, shift, q);
    end

endmodule
