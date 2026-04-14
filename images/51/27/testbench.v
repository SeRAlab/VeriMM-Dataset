`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [1:0] control_signals;
    reg duty_cycle;
    reg [1:0] power_supply;
    reg step_size;
    wire [1:0] direction_signals;
    wire pwm_signal;
    wire stepper_signals;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .control_signals(control_signals),
        .duty_cycle(duty_cycle),
        .power_supply(power_supply),
        .step_size(step_size),
        .direction_signals(direction_signals),
        .pwm_signal(pwm_signal),
        .stepper_signals(stepper_signals)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            control_signals = 2'b00;
            duty_cycle = 0;
            power_supply = 2'b00;
            step_size = 0;
            #20;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            control_signals = 2'b00;
            duty_cycle = 0;
            power_supply = 2'b11;
            #50;
            #1;

            check_outputs(2'b00, 1'b0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            control_signals = 2'b01;
            duty_cycle = 1'b1;
            power_supply = 2'b11;
            #100;
            #1;

            check_outputs(2'b01, 1'b1, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            control_signals = 2'b10;
            duty_cycle = 1'b1;
            power_supply = 2'b11;
            #100;
            #1;

            check_outputs(2'b10, 1'b1, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            control_signals = 2'b11;
            duty_cycle = 1'b0;
            power_supply = 2'b11;
            #50;
            #1;

            check_outputs(2'b11, 1'b0, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            control_signals = 2'b00;
            step_size = 1'b0;
            #200;

            #1;


            check_outputs(2'b00, 1'b0, stepper_signals);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();
            step_size = 1'b1;
            #150;
            #1;

            check_outputs(2'b00, 1'b0, stepper_signals);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            reset_dut();
            power_supply = 2'b01;
            control_signals = 2'b01;
            duty_cycle = 1'b1;
            #100;
            #1;

            check_outputs(2'b01, 1'b1, stepper_signals);
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
        input [1:0] expected_direction_signals;
        input expected_pwm_signal;
        input expected_stepper_signals;
        begin
            if (expected_direction_signals === (expected_direction_signals ^ direction_signals ^ expected_direction_signals) &&
                expected_pwm_signal === (expected_pwm_signal ^ pwm_signal ^ expected_pwm_signal) &&
                expected_stepper_signals === (expected_stepper_signals ^ stepper_signals ^ expected_stepper_signals)) begin
                $display("PASS");
                $display("  Outputs: direction_signals=%h, pwm_signal=%b, stepper_signals=%b",
                         direction_signals, pwm_signal, stepper_signals);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: direction_signals=%h, pwm_signal=%b, stepper_signals=%b",
                         expected_direction_signals, expected_pwm_signal, expected_stepper_signals);
                $display("  Got:      direction_signals=%h, pwm_signal=%b, stepper_signals=%b",
                         direction_signals, pwm_signal, stepper_signals);
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
        $dumpvars(0,clk, control_signals, duty_cycle, power_supply, step_size, direction_signals, pwm_signal, stepper_signals);
    end

endmodule
