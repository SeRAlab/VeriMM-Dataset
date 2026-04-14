`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg duty_cycle;
    reg frequency;
    reg reset;
    reg trigger;
    wire pulse;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .duty_cycle(duty_cycle),
        .frequency(frequency),
        .reset(reset),
        .trigger(trigger),
        .pulse(pulse)
    );

    // Clock generation (10ns period)
    initial begin
        reset = 0;
        forever #5 reset = ~reset;
    end

        task reset_dut;

    begin
        trigger = 0;
        frequency = 0;
        duty_cycle = 0;
        #20;
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        reset_dut();
        #50;
        $display("Testcase 001: Idle State");
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        reset_dut();
        @(posedge reset);
        trigger = 1;
        @(posedge reset);
        trigger = 0;
        #10;
        $display("Testcase 002: Monostable Trigger");
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        reset_dut();
        frequency = 1;
        duty_cycle = 1;
        #100;
        $display("Testcase 003: Astable Mode Activation");

        #1;


        check_outputs(1'b1);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        reset_dut();
        frequency = 1;
        duty_cycle = 1;
        #20;
        trigger = 1;
        #10;
        $display("Testcase 004: Combined Mode");
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        reset_dut();
        frequency = 0;
        duty_cycle = 1;
        #50;
        $display("Testcase 005: Astable Disabled");
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
        input expected_pulse;
        begin
            if (expected_pulse === (expected_pulse ^ pulse ^ expected_pulse)) begin
                $display("PASS");
                $display("  Outputs: pulse=%b",
                         pulse);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: pulse=%b",
                         expected_pulse);
                $display("  Got:      pulse=%b",
                         pulse);
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
        $dumpvars(0,duty_cycle, frequency, reset, trigger, pulse);
    end

endmodule
