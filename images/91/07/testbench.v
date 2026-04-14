`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg dir;
    reg [1:0] motor_type;
    reg rst;
    reg [7:0] speed;
    reg step;
    wire [1:0] control;
    wire pwm;
    wire [3:0] step_signals;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .dir(dir),
        .motor_type(motor_type),
        .rst(rst),
        .speed(speed),
        .step(step),
        .control(control),
        .pwm(pwm),
        .step_signals(step_signals)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            dir = 0;
            motor_type = 0;
            speed = 0;
            step = 0;
            @(posedge clk);
            #1;
            rst = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case %0d: IDLE Mode", test_num);
            reset_dut();
            motor_type = 2'b00;
            @(posedge clk);
            #1;

            #1;


            check_outputs(2'b00, 1'b0, 4'b0000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case %0d: PWM Mode - FWD Max Speed", test_num);
            reset_dut();
            motor_type = 2'b01;
            dir = 1'b1;
            speed = 8'hFF;
            repeat(10) @(posedge clk);
            #1;

            #1;


            check_outputs(2'b10, 1'b1, 4'b0000);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case %0d: PWM Mode - REV Zero Speed", test_num);
            reset_dut();
            motor_type = 2'b01;
            dir = 1'b0;
            speed = 8'h00;
            repeat(10) @(posedge clk);
            #1;

            #1;


            check_outputs(2'b01, 1'b0, 4'b0000);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case %0d: H-BRIDGE Mode - FWD", test_num);
            reset_dut();
            motor_type = 2'b10;
            dir = 1'b1;
            repeat(5) @(posedge clk);
            #1;

            #1;


            check_outputs(2'b10, 1'b0, 4'b0000);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case %0d: H-BRIDGE Mode - REV", test_num);
            reset_dut();
            motor_type = 2'b10;
            dir = 1'b0;
            repeat(5) @(posedge clk);
            #1;
            #1;

            check_outputs(2'b01, 1'b0, 4'b0000);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test Case %0d: STEPPER Mode - Initial State", test_num);
            reset_dut();
            motor_type = 2'b11;
            @(posedge clk);
            #1;

            #1;


            check_outputs(2'b00, 1'b0, 4'b0001);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test Case %0d: STEPPER Mode - Step 1", test_num);
            reset_dut();
            motor_type = 2'b11;
            @(posedge clk);
            step = 1;
            @(posedge clk);
            step = 0;
            @(posedge clk);
            #1;

            #1;


            check_outputs(2'b00, 1'b0, 4'b0010);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Test Case %0d: STEPPER Mode - Step 3", test_num);
            reset_dut();
            motor_type = 2'b11;
            repeat(3) begin
                @(posedge clk);
                step = 1;
                @(posedge clk);
                step = 0;
            end
            repeat(2) @(posedge clk);
            #1;

            #1;


            check_outputs(2'b00, 1'b0, 4'b1000);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            $display("Test Case %0d: Mode Switch (PWM -> IDLE)", test_num);
            reset_dut();
            motor_type = 2'b01;
            speed = 8'hFF;
            repeat(5) @(posedge clk);
            motor_type = 2'b00;
            repeat(2) @(posedge clk);
            #1;
            #1;

            check_outputs(2'b00, 1'b0, 4'b0000);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            $display("Test Case %0d: Reset During Operation", test_num);
            reset_dut();
            motor_type = 2'b10;
            dir = 1'b1;
            repeat(5) @(posedge clk);
            rst = 1;
            repeat(2) @(posedge clk);
            #1;
            #1;

            check_outputs(2'b00, 1'b0, 4'b0000);
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
        testcase008();
        testcase009();
        testcase010();
        
        
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
        input [1:0] expected_control;
        input expected_pwm;
        input [3:0] expected_step_signals;
        begin
            if (expected_control === (expected_control ^ control ^ expected_control) &&
                expected_pwm === (expected_pwm ^ pwm ^ expected_pwm) &&
                expected_step_signals === (expected_step_signals ^ step_signals ^ expected_step_signals)) begin
                $display("PASS");
                $display("  Outputs: control=%h, pwm=%b, step_signals=%h",
                         control, pwm, step_signals);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: control=%h, pwm=%b, step_signals=%h",
                         expected_control, expected_pwm, expected_step_signals);
                $display("  Got:      control=%h, pwm=%b, step_signals=%h",
                         control, pwm, step_signals);
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
        $dumpvars(0,clk, dir, motor_type, rst, speed, step, control, pwm, step_signals);
    end

endmodule
