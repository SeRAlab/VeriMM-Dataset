`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg analog_in;
    reg duty_cycle;
    reg freq;
    wire pwm_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .analog_in(analog_in),
        .duty_cycle(duty_cycle),
        .freq(freq),
        .pwm_out(pwm_out)
    );

    // Clock generation (10ns period)
    initial begin
        freq = 0;
        forever #5 freq = ~freq;
    end

        task reset_dut;

        begin
            analog_in = 0;
            duty_cycle = 0;

            repeat(5) @(posedge freq);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nRunning Testcase %0d: All inputs low", test_num);
            reset_dut();

            analog_in = 0;
            duty_cycle = 0;


            repeat(100) @(posedge freq);


            #1;



            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nRunning Testcase %0d: Duty cycle high", test_num);
            reset_dut();

            analog_in = 0;
            duty_cycle = 1;


            repeat(150) @(posedge freq);


            #1;



            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nRunning Testcase %0d: Analog input high, duty low", test_num);
            reset_dut();

            analog_in = 1;
            duty_cycle = 0;

            repeat(100) @(posedge freq);


            #1;



            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nRunning Testcase %0d: All inputs high", test_num);
            reset_dut();

            analog_in = 1;
            duty_cycle = 1;


            repeat(250) @(posedge freq);


            #1;



            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nRunning Testcase %0d: Extended timing check", test_num);
            reset_dut();

            analog_in = 0;
            duty_cycle = 1;


            repeat(500) @(posedge freq);


            #1;



            check_outputs(1'b1);
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
        input expected_pwm_out;
        begin
            if (expected_pwm_out === (expected_pwm_out ^ pwm_out ^ expected_pwm_out)) begin
                $display("PASS");
                $display("  Outputs: pwm_out=%b",
                         pwm_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: pwm_out=%b",
                         expected_pwm_out);
                $display("  Got:      pwm_out=%b",
                         pwm_out);
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
        $dumpvars(0,analog_in, duty_cycle, freq, pwm_out);
    end

endmodule
