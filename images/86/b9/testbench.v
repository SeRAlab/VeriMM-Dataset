`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg reset;
    reg trigger;
    wire pulse_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .reset(reset),
        .trigger(trigger),
        .pulse_out(pulse_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            @(negedge clk);
            reset = 1;
            trigger = 0;
            repeat (2) @(negedge clk);
            reset = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase 001: Initial state after reset");
            reset_dut();
            repeat (2) @(negedge clk);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase 002: Single trigger pulse-high check");
            reset_dut();
            @(negedge clk);
            trigger = 1;
            @(negedge clk);
            trigger = 0;
            @(negedge clk);
            @(negedge clk);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase 003: Single trigger pulse-low check");
            reset_dut();
            @(negedge clk) trigger = 1;
            @(negedge clk) trigger = 0;
            repeat (3) @(negedge clk);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase 004: Continuous trigger check (should be low at cycle 3)");
            reset_dut();
            @(negedge clk) trigger = 1;
            repeat (3) @(negedge clk);



            #1;




            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase 005: Reset during active pulse");
            reset_dut();
            @(negedge clk) trigger = 1;
            repeat (2) @(negedge clk);
            reset = 1;
            @(negedge clk);
            #1;

            check_outputs(1'b0);
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
        input expected_pulse_out;
        begin
            if (expected_pulse_out === (expected_pulse_out ^ pulse_out ^ expected_pulse_out)) begin
                $display("PASS");
                $display("  Outputs: pulse_out=%b",
                         pulse_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: pulse_out=%b",
                         expected_pulse_out);
                $display("  Got:      pulse_out=%b",
                         pulse_out);
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
        $dumpvars(0,clk, reset, trigger, pulse_out);
    end

endmodule
