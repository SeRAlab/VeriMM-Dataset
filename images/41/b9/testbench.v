`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clock;
    reg enable_in;
    reg reset;
    wire enable_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clock(clock),
        .enable_in(enable_in),
        .reset(reset),
        .enable_out(enable_out)
    );

    // Clock generation (10ns period)
    initial begin
        clock = 0;
        forever #5 clock = ~clock;
    end

        task reset_dut;

    begin
        reset = 0;
        enable_in = 1;
        @(negedge clock);
        reset = 1;
        @(negedge clock);
    end
        endtask
    task testcase001;

    begin
        $display("Test Case 001: Normal Pulse Detection");
        reset_dut();
        enable_in = 0;
        @(negedge clock);
        enable_in = 1;
        @(negedge clock);

        #1;


        check_outputs(1);
    end
        endtask

    task testcase002;

    begin
        $display("Test Case 002: Idle Input (No Pulse)");
        reset_dut();
        enable_in = 1;
        repeat(5) @(negedge clock);

        #1;


        check_outputs(0);
    end
        endtask

    task testcase003;

    begin
        $display("Test Case 003: Long Press (No Pulse until Release)");
        reset_dut();
        enable_in = 0;
        repeat(5) @(negedge clock);

        #1;


        check_outputs(0);
    end
        endtask

    task testcase004;

    begin
        $display("Test Case 004: Verify output returns to 0 after pulse");
        reset_dut();
        enable_in = 0;
        @(negedge clock);
        enable_in = 1;
        @(negedge clock);
        @(negedge clock);
        #1;

        check_outputs(0);
    end
        endtask

    task testcase005;

    begin
        $display("Test Case 005: Reset mid-sequence");
        reset_dut();
        enable_in = 0;
        @(negedge clock);
        reset = 0;
        @(negedge clock);
        reset = 1;
        enable_in = 1;
        @(negedge clock);
        #1;

        check_outputs(0);
    end
        endtask

    task testcase006;

    begin
        $display("Test Case 006: Multiple consecutive pulses");
        reset_dut();

        enable_in = 0; @(negedge clock);
        enable_in = 1; @(negedge clock);

        enable_in = 0; @(negedge clock);
        enable_in = 1; @(negedge clock);
        #1;

        check_outputs(1);
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
        input expected_enable_out;
        begin
            if (expected_enable_out === (expected_enable_out ^ enable_out ^ expected_enable_out)) begin
                $display("PASS");
                $display("  Outputs: enable_out=%b",
                         enable_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: enable_out=%b",
                         expected_enable_out);
                $display("  Got:      enable_out=%b",
                         enable_out);
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
        $dumpvars(0,clock, enable_in, reset, enable_out);
    end

endmodule
