`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg brake;
    reg dir;
    reg pwm_duty;
    reg pwm_freq;
    reg speed;
    reg step;
    wire [3:0] hbridge_ctrl;
    wire pwm_out;
    wire [3:0] stepper_ctrl;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .brake(brake),
        .dir(dir),
        .pwm_duty(pwm_duty),
        .pwm_freq(pwm_freq),
        .speed(speed),
        .step(step),
        .hbridge_ctrl(hbridge_ctrl),
        .pwm_out(pwm_out),
        .stepper_ctrl(stepper_ctrl)
    );

    // Clock generation (10ns period)
    initial begin
        pwm_freq = 0;
        forever #5 pwm_freq = ~pwm_freq;
    end

        task reset_dut;

    begin
        brake = 1;
        dir = 0;
        pwm_duty = 0;
        speed = 0;
        step = 0;
        repeat(2) @(posedge pwm_freq);
    end
        endtask
    task testcase001;

    begin
        $display("\nRunning testcase001: Brake State");
        test_num = test_num + 1;
        reset_dut();

        brake = 1;
        pwm_duty = 1;
        repeat(2) @(posedge pwm_freq);


        #1;



        check_outputs(4'b1111, 1'b0, 4'b0000);
    end
        endtask

    task testcase002;

    begin
        $display("\nRunning testcase002: Forward Direction Drive");
        test_num = test_num + 1;
        reset_dut();

        brake = 0;
        dir = 0;
        pwm_duty = 1;
        repeat(2) @(posedge pwm_freq);


        #1;



        check_outputs(4'b1010, 1'b1, 4'b0000);
    end
        endtask

    task testcase003;

    begin
        $display("\nRunning testcase003: Reverse Direction Drive");
        test_num = test_num + 1;
        reset_dut();

        brake = 0;
        dir = 1;
        pwm_duty = 1;
        repeat(2) @(posedge pwm_freq);


        #1;



        check_outputs(4'b0101, 1'b1, 4'b0000);
    end
        endtask

    task testcase004;

    begin
        $display("\nRunning testcase004: Stepper Forward Sequence Step 1");
        test_num = test_num + 1;
        reset_dut();

        brake = 0;
        dir = 0;


        step = 1;
        @(posedge pwm_freq);
        step = 0;
        repeat(2) @(posedge pwm_freq);


        #1;



        check_outputs(4'b1010, 1'b0, 4'b1000);
    end
        endtask

    task testcase005;

    begin
        $display("\nRunning testcase005: Stepper Forward Sequence Step 2");
        test_num = test_num + 1;
        reset_dut();

        brake = 0;
        dir = 0;


        repeat(2) begin
            step = 1; @(posedge pwm_freq);
            step = 0; @(posedge pwm_freq);
        end


        #1;



        check_outputs(4'b1010, 1'b0, 4'b0100);
    end
        endtask

    task testcase006;

    begin
        $display("\nRunning testcase006: Stepper Reverse Sequence");
        test_num = test_num + 1;
        reset_dut();

        brake = 0;
        dir = 1;


        step = 1;
        @(posedge pwm_freq);
        step = 0;
        repeat(2) @(posedge pwm_freq);


        #1;



        check_outputs(4'b0101, 1'b0, 4'b0001);
    end
        endtask

    task testcase007;

    begin
        $display("\nRunning testcase007: PWM Duty Cycle Low");
        test_num = test_num + 1;
        reset_dut();

        brake = 0;
        pwm_duty = 0;
        repeat(2) @(posedge pwm_freq);


        #1;



        check_outputs(4'b1010, 1'b0, 4'b0000);
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
        input [3:0] expected_hbridge_ctrl;
        input expected_pwm_out;
        input [3:0] expected_stepper_ctrl;
        begin
            if (expected_hbridge_ctrl === (expected_hbridge_ctrl ^ hbridge_ctrl ^ expected_hbridge_ctrl) &&
                expected_pwm_out === (expected_pwm_out ^ pwm_out ^ expected_pwm_out) &&
                expected_stepper_ctrl === (expected_stepper_ctrl ^ stepper_ctrl ^ expected_stepper_ctrl)) begin
                $display("PASS");
                $display("  Outputs: hbridge_ctrl=%h, pwm_out=%b, stepper_ctrl=%h",
                         hbridge_ctrl, pwm_out, stepper_ctrl);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: hbridge_ctrl=%h, pwm_out=%b, stepper_ctrl=%h",
                         expected_hbridge_ctrl, expected_pwm_out, expected_stepper_ctrl);
                $display("  Got:      hbridge_ctrl=%h, pwm_out=%b, stepper_ctrl=%h",
                         hbridge_ctrl, pwm_out, stepper_ctrl);
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
        $dumpvars(0,brake, dir, pwm_duty, pwm_freq, speed, step, hbridge_ctrl, pwm_out, stepper_ctrl);
    end

endmodule
