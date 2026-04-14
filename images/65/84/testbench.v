`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clock;
    reg [7:0] duty_cycle;
    wire pwm;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clock(clock),
        .duty_cycle(duty_cycle),
        .pwm(pwm)
    );

    // Clock generation (10ns period)
    initial begin
        clock = 0;
        forever #5 clock = ~clock;
    end

        task reset_dut;

        begin
            duty_cycle = 0;
            #10;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            duty_cycle = 8'd5;
            @(posedge clock);
            #1;
            $display("Testcase 001: DC=5, Counter=0. Expected PWM=1");
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            duty_cycle = 8'd5;
            repeat(6) @(posedge clock);
            #1;
            $display("Testcase 002: DC=5, Counter=5. Expected PWM=0");
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            duty_cycle = 8'd1;
            repeat(2) @(posedge clock);
            #1;
            $display("Testcase 003: DC=1, Counter=1. Expected PWM=0");
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            duty_cycle = 8'd10;
            repeat(6) @(posedge clock);
            #1;
            $display("Testcase 004: DC=10, Counter=5. Expected PWM=1");
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            duty_cycle = 8'd255;
            repeat(256) @(posedge clock);
            #1;
            $display("Testcase 005: DC=255, Counter=255. Expected PWM=0");
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
        input expected_pwm;
        begin
            if (expected_pwm === (expected_pwm ^ pwm ^ expected_pwm)) begin
                $display("PASS");
                $display("  Outputs: pwm=%b",
                         pwm);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: pwm=%b",
                         expected_pwm);
                $display("  Got:      pwm=%b",
                         pwm);
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
        $dumpvars(0,clock, duty_cycle, pwm);
    end

endmodule
