`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg reset;
    reg select;
    wire [3:0] counter_out;
    wire [3:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .reset(reset),
        .select(select),
        .counter_out(counter_out),
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
        select = 0;
        #15;
        reset = 0;
        #2;
    end
        endtask
    task testcase001;

    begin
        $display("Testcase 001: Reset and Select Mode 0 (Default Zero)");
        reset_dut();
        select = 2'd0;
        @(posedge clk);
        #1;
        #1;

        check_outputs(4'd0, 4'd0);
    end
        endtask

    task testcase002;

    begin
        $display("Testcase 002: Counter Increment and Select Mode 1 (Counter)");
        reset_dut();
        select = 2'd1;

        repeat(5) @(posedge clk);
        #1;
        #1;

        check_outputs(4'd5, 4'd5);
    end
        endtask

    task testcase003;

    begin
        $display("Testcase 003: Select Mode 2 (Counter + 1)");
        reset_dut();

        repeat(3) @(posedge clk);
        select = 2'd2;
        #1;

        #1;


        check_outputs(4'd3, 4'd4);
    end
        endtask

    task testcase004;

    begin
        $display("Testcase 004: Select Mode 3 (Fixed 15)");
        reset_dut();

        repeat(8) @(posedge clk);
        select = 2'd3;
        #1;

        #1;


        check_outputs(4'd8, 4'd15);
    end
        endtask

    task testcase005;

    begin
        $display("Testcase 005: Counter Rollover and Mode 1");
        reset_dut();
        select = 2'd1;

        repeat(16) @(posedge clk);
        #1;
        #1;

        check_outputs(4'd0, 4'd0);
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
        input [3:0] expected_counter_out;
        input [3:0] expected_q;
        begin
            if (expected_counter_out === (expected_counter_out ^ counter_out ^ expected_counter_out) &&
                expected_q === (expected_q ^ q ^ expected_q)) begin
                $display("PASS");
                $display("  Outputs: counter_out=%h, q=%h",
                         counter_out, q);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: counter_out=%h, q=%h",
                         expected_counter_out, expected_q);
                $display("  Got:      counter_out=%h, q=%h",
                         counter_out, q);
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
        $dumpvars(0,clk, reset, select, counter_out, q);
    end

endmodule
