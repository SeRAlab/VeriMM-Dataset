`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clock;
    reg [3:0] offset;
    reg reset;
    wire [7:0] phase_counter_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clock(clock),
        .offset(offset),
        .reset(reset),
        .phase_counter_out(phase_counter_out)
    );

    // Clock generation (10ns period)
    initial begin
        clock = 0;
        forever #5 clock = ~clock;
    end

        task reset_dut;

    begin
        reset = 1;
        offset = 0;
        @(posedge clock);
        #1;
        reset = 0;
    end
        endtask
    task testcase001;

    begin
        $display("Testcase 001: Reset Verification");
        reset_dut();

        #1;


        check_outputs(8'h00);
    end
        endtask

    task testcase002;

    begin
        $display("Testcase 002: Small Offset (1) for 10 cycles");
        reset_dut();
        offset = 4'h1;
        repeat(10) @(posedge clock);
        #1;
        #1;

        check_outputs(8'h0A);
    end
        endtask

    task testcase003;

    begin
        $display("Testcase 003: Larger Offset (5) for 5 cycles");
        reset_dut();
        offset = 4'h5;
        repeat(5) @(posedge clock);
        #1;
        #1;

        check_outputs(8'h19);
    end
        endtask

    task testcase004;

    begin
        $display("Testcase 004: Maximum Offset (15) for 4 cycles");
        reset_dut();
        offset = 4'hF;
        repeat(4) @(posedge clock);
        #1;
        #1;

        check_outputs(8'h3C);
    end
        endtask

    task testcase005;

    begin
        $display("Testcase 005: Overflow Check (Wrap around)");
        reset_dut();
        offset = 4'hF;

        repeat(18) @(posedge clock);
        #1;
        #1;

        check_outputs(8'h0E);
    end
        endtask

    task testcase006;

    begin
        $display("Testcase 006: Zero Offset (Maintain state)");
        reset_dut();
        offset = 4'h4;
        repeat(2) @(posedge clock);
        offset = 4'h0;
        repeat(5) @(posedge clock);
        #1;
        #1;

        check_outputs(8'h08);
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
        input [7:0] expected_phase_counter_out;
        begin
            if (expected_phase_counter_out === (expected_phase_counter_out ^ phase_counter_out ^ expected_phase_counter_out)) begin
                $display("PASS");
                $display("  Outputs: phase_counter_out=%h",
                         phase_counter_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: phase_counter_out=%h",
                         expected_phase_counter_out);
                $display("  Got:      phase_counter_out=%h",
                         phase_counter_out);
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
        $dumpvars(0,clock, offset, reset, phase_counter_out);
    end

endmodule
