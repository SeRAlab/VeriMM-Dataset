`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg io_clear;
    reg [15:0] io_limit;
    reg io_mainClk;
    reg io_tick;
    reg resetCtrl_systemReset;
    wire io_full;
    wire [15:0] io_value;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .io_clear(io_clear),
        .io_limit(io_limit),
        .io_mainClk(io_mainClk),
        .io_tick(io_tick),
        .resetCtrl_systemReset(resetCtrl_systemReset),
        .io_full(io_full),
        .io_value(io_value)
    );

    // Clock generation (10ns period)
    initial begin
        io_mainClk = 0;
        forever #5 io_mainClk = ~io_mainClk;
    end

        task reset_dut;

        begin
            resetCtrl_systemReset = 1;
            io_tick = 0;
            io_clear = 0;
            io_limit = 16'hFFFF;
            @(posedge io_mainClk);
            #1;
            resetCtrl_systemReset = 0;
            @(posedge io_mainClk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            io_limit = 16'h0010;
            io_tick = 1;
            repeat(5) @(posedge io_mainClk);
            #1;
            #1;

            check_outputs(1'b0, 16'h0005);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            io_limit = 16'h0008;
            io_tick = 1;
            repeat(8) @(posedge io_mainClk);
            #1;

            #1;


            check_outputs(1'b1, 16'h0008);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            io_limit = 16'h0010;
            io_tick = 1;
            repeat(5) @(posedge io_mainClk);
            #1 io_clear = 1;
            @(posedge io_mainClk);
            #1 io_clear = 0;
            #1;

            check_outputs(1'b0, 16'h0000);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            io_limit = 16'h0010;
            io_tick = 1;
            repeat(3) @(posedge io_mainClk);
            #1 io_tick = 0;
            repeat(5) @(posedge io_mainClk);
            #1;
            #1;

            check_outputs(1'b0, 16'h0003);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            io_limit = 16'h0004;
            io_tick = 1;
            repeat(4) @(posedge io_mainClk);
            @(posedge io_mainClk);
            #1;
            #1;

            check_outputs(1'b0, 16'h0000);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();
            io_limit = 16'h000A;
            io_tick = 1;
            repeat(5) @(posedge io_mainClk);
            #1 resetCtrl_systemReset = 1;
            @(posedge io_mainClk);
            #1;
            #1;

            check_outputs(1'b0, 16'h0000);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            reset_dut();
            io_limit = 16'h0000;
            io_tick = 1;
            @(posedge io_mainClk);
            #1;

            #1;


            check_outputs(1'b1, 16'h0000);
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
        input expected_io_full;
        input [15:0] expected_io_value;
        begin
            if (expected_io_full === (expected_io_full ^ io_full ^ expected_io_full) &&
                expected_io_value === (expected_io_value ^ io_value ^ expected_io_value)) begin
                $display("PASS");
                $display("  Outputs: io_full=%b, io_value=%h",
                         io_full, io_value);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: io_full=%b, io_value=%h",
                         expected_io_full, expected_io_value);
                $display("  Got:      io_full=%b, io_value=%h",
                         io_full, io_value);
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
        $dumpvars(0,io_clear, io_limit, io_mainClk, io_tick, resetCtrl_systemReset, io_full, io_value);
    end

endmodule
