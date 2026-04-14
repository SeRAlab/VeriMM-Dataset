`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] pwm_in;
    reg [7:0] pwm_max;
    reg [7:0] pwm_min;
    reg rst;
    wire [7:0] pwm_out;
    wire [7:0] servo_angle;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .pwm_in(pwm_in),
        .pwm_max(pwm_max),
        .pwm_min(pwm_min),
        .rst(rst),
        .pwm_out(pwm_out),
        .servo_angle(servo_angle)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            pwm_in = 8'h00;
            pwm_min = 8'h00;
            pwm_max = 8'hFF;
            repeat(2) @(posedge clk);
            #1 rst = 0;
            repeat(1) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            pwm_min = 8'd10;
            pwm_max = 8'd200;
            pwm_in  = 8'd50;

            repeat(60) @(posedge clk);
            $write("Testcase 001 (Move to 50): ");
            #1;

            check_outputs(8'd50, 8'd50);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            pwm_min = 8'd0;
            pwm_max = 8'd255;

            pwm_in = 8'd100;
            repeat(110) @(posedge clk);

            pwm_in = 8'd30;
            repeat(80) @(posedge clk);
            $write("Testcase 002 (Move 100 to 30): ");
            #1;

            check_outputs(8'd30, 8'd30);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            pwm_min = 8'd0;
            pwm_max = 8'd150;
            pwm_in  = 8'd200;
            repeat(200) @(posedge clk);
            $write("Testcase 003 (Clip at Max 150): ");
            #1;

            check_outputs(8'd150, 8'd150);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            pwm_min = 8'd40;
            pwm_max = 8'd255;
            pwm_in  = 8'd10;
            repeat(50) @(posedge clk);
            $write("Testcase 004 (Clip at Min 40): ");
            #1;

            check_outputs(8'd40, 8'd40);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            pwm_in = 8'd100;
            repeat(20) @(posedge clk);
            rst = 1;
            repeat(2) @(posedge clk);
            $write("Testcase 005 (Reset state): ");

            #1;


            check_outputs(8'h00, 8'h00);
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
        input [7:0] expected_pwm_out;
        input [7:0] expected_servo_angle;
        begin
            if (expected_pwm_out === (expected_pwm_out ^ pwm_out ^ expected_pwm_out) &&
                expected_servo_angle === (expected_servo_angle ^ servo_angle ^ expected_servo_angle)) begin
                $display("PASS");
                $display("  Outputs: pwm_out=%h, servo_angle=%h",
                         pwm_out, servo_angle);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: pwm_out=%h, servo_angle=%h",
                         expected_pwm_out, expected_servo_angle);
                $display("  Got:      pwm_out=%h, servo_angle=%h",
                         pwm_out, servo_angle);
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
        $dumpvars(0,clk, pwm_in, pwm_max, pwm_min, rst, pwm_out, servo_angle);
    end

endmodule
