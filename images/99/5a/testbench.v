`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg hbridge_ctrl;
    reg pwm_in;
    reg stepper_ctrl;
    wire hbridge_out;
    wire pwm_out;
    wire stepper_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .hbridge_ctrl(hbridge_ctrl),
        .pwm_in(pwm_in),
        .stepper_ctrl(stepper_ctrl),
        .hbridge_out(hbridge_out),
        .pwm_out(pwm_out),
        .stepper_out(stepper_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            pwm_in = 0;
            hbridge_ctrl = 0;
            stepper_ctrl = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: All inputs Low", test_num);
            reset_dut();
            pwm_in = 0;
            hbridge_ctrl = 0;
            stepper_ctrl = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(0, 0, 0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: PWM High, others Low", test_num);
            reset_dut();
            pwm_in = 1;
            hbridge_ctrl = 0;
            stepper_ctrl = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(0, 1, 0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: H-Bridge Control High, others Low", test_num);
            reset_dut();
            pwm_in = 0;
            hbridge_ctrl = 1;
            stepper_ctrl = 0;
            @(posedge clk);
            #1;

            #1;


            check_outputs(1, 0, 0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Stepper Control High, others Low", test_num);
            reset_dut();
            pwm_in = 0;
            hbridge_ctrl = 0;
            stepper_ctrl = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(0, 0, 1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: All signals High", test_num);
            reset_dut();
            pwm_in = 1;
            hbridge_ctrl = 1;
            stepper_ctrl = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1, 1, 1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: PWM Low, Control Signals High", test_num);
            reset_dut();
            pwm_in = 0;
            hbridge_ctrl = 1;
            stepper_ctrl = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1, 0, 1);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %0d: Synchronous PWM update check", test_num);
            reset_dut();
            pwm_in = 1;
            @(posedge clk);
            pwm_in = 0;
            #1;

            #1;


            check_outputs(0, 1, 0);
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
        input expected_hbridge_out;
        input expected_pwm_out;
        input expected_stepper_out;
        begin
            if (expected_hbridge_out === (expected_hbridge_out ^ hbridge_out ^ expected_hbridge_out) &&
                expected_pwm_out === (expected_pwm_out ^ pwm_out ^ expected_pwm_out) &&
                expected_stepper_out === (expected_stepper_out ^ stepper_out ^ expected_stepper_out)) begin
                $display("PASS");
                $display("  Outputs: hbridge_out=%b, pwm_out=%b, stepper_out=%b",
                         hbridge_out, pwm_out, stepper_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: hbridge_out=%b, pwm_out=%b, stepper_out=%b",
                         expected_hbridge_out, expected_pwm_out, expected_stepper_out);
                $display("  Got:      hbridge_out=%b, pwm_out=%b, stepper_out=%b",
                         hbridge_out, pwm_out, stepper_out);
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
        $dumpvars(0,clk, hbridge_ctrl, pwm_in, stepper_ctrl, hbridge_out, pwm_out, stepper_out);
    end

endmodule
