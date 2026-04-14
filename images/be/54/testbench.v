`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] D;
    reg clock;
    reg reset_n;
    wire [3:0] Q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .D(D),
        .clock(clock),
        .reset_n(reset_n),
        .Q(Q)
    );

    // Clock generation (10ns period)
    initial begin
        clock = 0;
        forever #5 clock = ~clock;
    end

        task reset_dut;

    begin
        @(negedge clock);
        reset_n = 1;
        D = 0;
        @(negedge clock);
        reset_n = 0;
    end
        endtask
    task testcase001;

    begin
        $display("Testcase 001: Basic Reset Verification");
        reset_dut();
        @(negedge clock);
        #1;

        check_outputs(4'h0);
    end
        endtask

    task testcase002;

    begin
        $display("Testcase 002: Single Addition (0 + 5)");
        reset_dut();
        @(negedge clock);
        D = 4'h5;
        @(negedge clock);
        #1;

        check_outputs(4'h5);
    end
        endtask

    task testcase003;

    begin
        $display("Testcase 003: Sequential Accumulations (0 + 3 + 4 + 1)");
        reset_dut();
        @(negedge clock);
        D = 4'h3;
        @(negedge clock);
        D = 4'h4;
        @(negedge clock);
        D = 4'h1;
        @(negedge clock);
        #1;

        check_outputs(4'h8);
    end
        endtask

    task testcase004;

    begin
        $display("Testcase 004: 4-bit Overflow (10 + 10 = 20 -> 4)");
        reset_dut();
        @(negedge clock);
        D = 4'hA;
        @(negedge clock);
        D = 4'hA;
        @(negedge clock);
        #1;

        check_outputs(4'h4);
    end
        endtask

    task testcase005;

    begin
        $display("Testcase 005: Boundary Overflow (15 + 1 = 0)");
        reset_dut();
        @(negedge clock);
        D = 4'hF;
        @(negedge clock);
        D = 4'h1;
        @(negedge clock);
        #1;

        check_outputs(4'h0);
    end
        endtask

    task testcase006;

    begin
        $display("Testcase 006: Adding Zero (7 + 0)");
        reset_dut();
        @(negedge clock);
        D = 4'h7;
        @(negedge clock);
        D = 4'h0;
        @(negedge clock);
        #1;

        check_outputs(4'h7);
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
        input [3:0] expected_Q;
        begin
            if (expected_Q === (expected_Q ^ Q ^ expected_Q)) begin
                $display("PASS");
                $display("  Outputs: Q=%h",
                         Q);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Q=%h",
                         expected_Q);
                $display("  Got:      Q=%h",
                         Q);
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
        $dumpvars(0,D, clock, reset_n, Q);
    end

endmodule
