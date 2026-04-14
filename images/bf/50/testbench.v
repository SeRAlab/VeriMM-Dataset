`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clock;
    reg io_dec;
    reg io_inc;
    reg [9:0] io_strideDec;
    reg [9:0] io_strideInc;
    reg reset;
    wire [9:0] io_nextDec;
    wire [9:0] io_nextInc;
    wire [9:0] io_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clock(clock),
        .io_dec(io_dec),
        .io_inc(io_inc),
        .io_strideDec(io_strideDec),
        .io_strideInc(io_strideInc),
        .reset(reset),
        .io_nextDec(io_nextDec),
        .io_nextInc(io_nextInc),
        .io_out(io_out)
    );

    // Clock generation (10ns period)
    initial begin
        clock = 0;
        forever #5 clock = ~clock;
    end

        task reset_dut;

        begin
            reset = 1;
            io_inc = 0;
            io_dec = 0;
            io_strideInc = 0;
            io_strideDec = 0;
            @(posedge clock);
            #2 reset = 0;
            @(posedge clock);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("Testcase 001: Reset State");
            reset_dut();
            #1;

            check_outputs(10'd0, 10'd0, 10'd0);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Simple Increment");
            reset_dut();
            io_strideInc = 10'd10;
            io_inc = 1;
            @(posedge clock);
            #1 io_inc = 0;

            #1;


            check_outputs(10'd10, 10'd20, 10'd10);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Simple Decrement");
            reset_dut();

            io_strideInc = 10'd20;
            io_inc = 1;
            @(posedge clock);
            #1;

            io_strideDec = 10'd5;
            io_inc = 0;
            io_dec = 1;
            @(posedge clock);
            #1 io_dec = 0;

            #1;


            check_outputs(10'd10, 10'd35, 10'd15);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Sequential Increments");
            reset_dut();
            io_strideInc = 10'd5;
            io_inc = 1;
            repeat(3) @(posedge clock);
            #1 io_inc = 0;

            #1;


            check_outputs(10'd15, 10'd20, 10'd15);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Simultaneous Inc and Dec");
            reset_dut();
            io_strideInc = 10'd20;
            io_strideDec = 10'd7;
            io_inc = 1;
            io_dec = 1;
            @(posedge clock);
            #1 io_inc = 0; io_dec = 0;

            #1;


            check_outputs(10'd6, 10'd33, 10'd13);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: Max Boundary Wrap Around");
            reset_dut();

            io_strideInc = 10'd1020;
            io_inc = 1;
            @(posedge clock);
            #1;

            io_strideInc = 10'd10;
            @(posedge clock);
            #1 io_inc = 0;

            #1;


            check_outputs(10'd6, 10'd16, 10'd6);
        end
        endtask

    task testcase007;

        begin
            $display("Testcase 007: Min Boundary Underflow");
            reset_dut();

            io_strideInc = 10'd5;
            io_inc = 1;
            @(posedge clock);
            #1;

            io_strideDec = 10'd10;
            io_inc = 0;
            io_dec = 1;
            @(posedge clock);
            #1 io_dec = 0;

            #1;


            check_outputs(10'd1009, 10'd0, 10'd1019);
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
        input [9:0] expected_io_nextDec;
        input [9:0] expected_io_nextInc;
        input [9:0] expected_io_out;
        begin
            if (expected_io_nextDec === (expected_io_nextDec ^ io_nextDec ^ expected_io_nextDec) &&
                expected_io_nextInc === (expected_io_nextInc ^ io_nextInc ^ expected_io_nextInc) &&
                expected_io_out === (expected_io_out ^ io_out ^ expected_io_out)) begin
                $display("PASS");
                $display("  Outputs: io_nextDec=%h, io_nextInc=%h, io_out=%h",
                         io_nextDec, io_nextInc, io_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: io_nextDec=%h, io_nextInc=%h, io_out=%h",
                         expected_io_nextDec, expected_io_nextInc, expected_io_out);
                $display("  Got:      io_nextDec=%h, io_nextInc=%h, io_out=%h",
                         io_nextDec, io_nextInc, io_out);
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
        $dumpvars(0,clock, io_dec, io_inc, io_strideDec, io_strideInc, reset, io_nextDec, io_nextInc, io_out);
    end

endmodule
