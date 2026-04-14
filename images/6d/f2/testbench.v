`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg dir;
    reg pwm_in;
    reg rst;
    reg [7:0] speed;
    wire [1:0] motor_a_b;
    wire pwm_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .dir(dir),
        .pwm_in(pwm_in),
        .rst(rst),
        .speed(speed),
        .motor_a_b(motor_a_b),
        .pwm_out(pwm_out)
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
        pwm_in = 0;
        speed = 8'h00;
        repeat(2) @(posedge clk);
        #1 rst = 0;
        @(posedge clk);
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        reset_dut();

        $display("Testcase001: Checking Reset State...");
        #1;

        check_outputs(2'b01, 1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        reset_dut();
        dir = 1;
        pwm_in = 1;
        speed = 8'd5;

        repeat(5) @(posedge clk);
        #1;
        $display("Testcase002: Direction 1 and PWM Toggle High...");
        #1;

        check_outputs(2'b10, 1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        reset_dut();
        dir = 0;
        pwm_in = 1;
        speed = 8'd10;

        repeat(20) @(posedge clk);
        #1;
        $display("Testcase003: PWM Full Cycle (Low-High-Low)...");
        #1;

        check_outputs(2'b01, 1'b0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        reset_dut();
        dir = 1;
        pwm_in = 1;
        speed = 8'd1;

        repeat(3) @(posedge clk);
        #1;
        $display("Testcase004: Fast Toggling (Speed=1)...");
        #1;

        check_outputs(2'b10, 1'b1);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        reset_dut();
        dir = 0;
        pwm_in = 1;
        speed = 8'd100;

        repeat(50) @(posedge clk);
        #1;
        $display("Testcase005: High Speed Threshold (Mid-way check)...");
        #1;

        check_outputs(2'b01, 1'b0);
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
        input [1:0] expected_motor_a_b;
        input expected_pwm_out;
        begin
            if (expected_motor_a_b === (expected_motor_a_b ^ motor_a_b ^ expected_motor_a_b) &&
                expected_pwm_out === (expected_pwm_out ^ pwm_out ^ expected_pwm_out)) begin
                $display("PASS");
                $display("  Outputs: motor_a_b=%h, pwm_out=%b",
                         motor_a_b, pwm_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: motor_a_b=%h, pwm_out=%b",
                         expected_motor_a_b, expected_pwm_out);
                $display("  Got:      motor_a_b=%h, pwm_out=%b",
                         motor_a_b, pwm_out);
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
        $dumpvars(0,clk, dir, pwm_in, rst, speed, motor_a_b, pwm_out);
    end

endmodule
