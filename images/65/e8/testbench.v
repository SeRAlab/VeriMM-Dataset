`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clock;
    reg reset;
    reg [3:0] switches;
    reg write_ready;
    wire [23:0] writedata_left;
    wire [23:0] writedata_right;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clock(clock),
        .reset(reset),
        .switches(switches),
        .write_ready(write_ready),
        .writedata_left(writedata_left),
        .writedata_right(writedata_right)
    );

    // Clock generation (10ns period)
    initial begin
        clock = 0;
        forever #5 clock = ~clock;
    end

        task reset_dut;

        begin
            reset = 1;
            write_ready = 0;
            switches = 4'b0000;
            @(posedge clock);
            #2 reset = 0;
            @(posedge clock);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase 001: Reset state check");
            reset_dut();

            #1;


            check_outputs(24'h000000, 24'h000000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase 002: Counter bit 0 selection");
            reset_dut();
            write_ready = 1;
            switches = 4'd0;
            @(posedge clock);
            #2;

            #1;


            check_outputs(24'hFFFFFF, 24'hFFFFFF);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase 003: Bit toggling and bit 1 selection");
            reset_dut();
            write_ready = 1;
            @(posedge clock);
            @(posedge clock);
            #2;
            switches = 4'd0;
            #1;
            #1;

            check_outputs(24'h000000, 24'h000000);

            switches = 4'd1;
            #1;
            #1;

            check_outputs(24'hFFFFFF, 24'hFFFFFF);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase 004: write_ready gating check");
            reset_dut();
            write_ready = 1;
            @(posedge clock);
            write_ready = 0;
            repeat (5) @(posedge clock);
            #2;
            switches = 4'd0;
            #1;

            check_outputs(24'hFFFFFF, 24'hFFFFFF);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase 005: High-order switch (bit 3)");
            reset_dut();
            write_ready = 1;
            repeat (8) @(posedge clock);
            #2;
            switches = 4'd3;
            #1;

            check_outputs(24'hFFFFFF, 24'hFFFFFF);

            switches = 4'd2;
            #1;
            #1;

            check_outputs(24'h000000, 24'h000000);
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
        input [23:0] expected_writedata_left;
        input [23:0] expected_writedata_right;
        begin
            if (expected_writedata_left === (expected_writedata_left ^ writedata_left ^ expected_writedata_left) &&
                expected_writedata_right === (expected_writedata_right ^ writedata_right ^ expected_writedata_right)) begin
                $display("PASS");
                $display("  Outputs: writedata_left=%h, writedata_right=%h",
                         writedata_left, writedata_right);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: writedata_left=%h, writedata_right=%h",
                         expected_writedata_left, expected_writedata_right);
                $display("  Got:      writedata_left=%h, writedata_right=%h",
                         writedata_left, writedata_right);
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
        $dumpvars(0,clock, reset, switches, write_ready, writedata_left, writedata_right);
    end

endmodule
