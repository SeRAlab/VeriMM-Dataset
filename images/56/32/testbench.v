`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg io_clear;
    reg [15:0] io_limit;
    reg io_mainClk;
    reg resetCtrl_systemReset;
    wire io_overflow;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .io_clear(io_clear),
        .io_limit(io_limit),
        .io_mainClk(io_mainClk),
        .resetCtrl_systemReset(resetCtrl_systemReset),
        .io_overflow(io_overflow)
    );

    // Clock generation (10ns period)
    initial begin
        io_mainClk = 0;
        forever #5 io_mainClk = ~io_mainClk;
    end

        task reset_dut;

        begin
            io_clear = 0;
            io_limit = 16'h0000;
            resetCtrl_systemReset = 1;
            repeat(2) @(posedge io_mainClk);
            resetCtrl_systemReset = 0;
            @(posedge io_mainClk);
        end
        endtask
    task testcase001;

        begin
            $display("Running testcase001: Basic overflow at limit 5...");
            reset_dut();
            io_limit = 16'd5;
            io_clear = 0;

            repeat(5) @(posedge io_mainClk);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            $display("Running testcase002: Manual clear prevents overflow...");
            reset_dut();
            io_limit = 16'd10;
            io_clear = 0;

            repeat(5) @(posedge io_mainClk);

            io_clear = 1;
            @(posedge io_mainClk);
            io_clear = 0;

            repeat(4) @(posedge io_mainClk);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            $display("Running testcase003: Overflow occurs after a previous clear...");
            reset_dut();
            io_limit = 16'd3;
            io_clear = 0;
            repeat(2) @(posedge io_mainClk);
            io_clear = 1;
            @(posedge io_mainClk);
            io_clear = 0;

            repeat(3) @(posedge io_mainClk);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            $display("Running testcase004: Minimum limit of 1...");
            reset_dut();
            io_limit = 16'd1;
            io_clear = 0;
            @(posedge io_mainClk);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            $display("Running testcase005: Consecutive overflows...");
            reset_dut();
            io_limit = 16'd2;
            io_clear = 0;

            repeat(2) @(posedge io_mainClk);

            repeat(2) @(posedge io_mainClk);
            #1;

            check_outputs(1'b1);
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
        input expected_io_overflow;
        begin
            if (expected_io_overflow === (expected_io_overflow ^ io_overflow ^ expected_io_overflow)) begin
                $display("PASS");
                $display("  Outputs: io_overflow=%b",
                         io_overflow);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: io_overflow=%b",
                         expected_io_overflow);
                $display("  Got:      io_overflow=%b",
                         io_overflow);
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
        $dumpvars(0,io_clear, io_limit, io_mainClk, resetCtrl_systemReset, io_overflow);
    end

endmodule
