`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg dir1;
    reg dir2;
    reg [7:0] pwm_duty_cycle;
    reg [3:0] step_sequence;
    wire h_bridge_out;
    wire pwm_out;
    wire [3:0] step_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .dir1(dir1),
        .dir2(dir2),
        .pwm_duty_cycle(pwm_duty_cycle),
        .step_sequence(step_sequence),
        .h_bridge_out(h_bridge_out),
        .pwm_out(pwm_out),
        .step_out(step_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            dir1 = 0;
            dir2 = 0;
            pwm_duty_cycle = 8'h00;
            step_sequence = 4'h0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %03d: PWM 0%% Duty Cycle, Idle Direction", test_num);
            reset_dut();

            pwm_duty_cycle = 8'd0;
            dir1 = 0;
            dir2 = 0;
            step_sequence = 4'b0000;

            repeat(256) @(posedge clk);
            #2;

            #1;


            check_outputs(1'b0, 1'b0, 4'b0000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %03d: PWM 100%% Duty Cycle, Forward Direction", test_num);
            reset_dut();

            pwm_duty_cycle = 8'd255;
            dir1 = 1;
            dir2 = 0;
            step_sequence = 4'b1010;


            repeat(10) @(posedge clk);
            #2;

            #1;


            check_outputs(1'b1, 1'b1, 4'b1010);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %03d: Mid PWM (50%%), Reverse Direction", test_num);
            reset_dut();

            pwm_duty_cycle = 8'd128;
            dir1 = 0;
            dir2 = 1;
            step_sequence = 4'b0101;


            repeat(64) @(posedge clk);
            #2;


            #1;



            check_outputs(1'b0, 1'b1, 4'b0101);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %03d: Stepper Motor Pattern Change", test_num);
            reset_dut();

            pwm_duty_cycle = 8'd64;
            dir1 = 1;
            dir2 = 1;
            step_sequence = 4'b1100;

            repeat(20) @(posedge clk);
            #2;

            #1;


            check_outputs(1'b0, 1'b1, 4'b1100);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %03d: Low PWM Duty Cycle, Step Sequence Walk", test_num);
            reset_dut();

            pwm_duty_cycle = 8'd10;
            dir1 = 1;
            dir2 = 0;
            step_sequence = 4'b0001;


            repeat(250) @(posedge clk);
            #2;

            #1;


            check_outputs(1'b1, 1'b0, 4'b0001);
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
        input expected_h_bridge_out;
        input expected_pwm_out;
        input [3:0] expected_step_out;
        begin
            if (expected_h_bridge_out === (expected_h_bridge_out ^ h_bridge_out ^ expected_h_bridge_out) &&
                expected_pwm_out === (expected_pwm_out ^ pwm_out ^ expected_pwm_out) &&
                expected_step_out === (expected_step_out ^ step_out ^ expected_step_out)) begin
                $display("PASS");
                $display("  Outputs: h_bridge_out=%b, pwm_out=%b, step_out=%h",
                         h_bridge_out, pwm_out, step_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: h_bridge_out=%b, pwm_out=%b, step_out=%h",
                         expected_h_bridge_out, expected_pwm_out, expected_step_out);
                $display("  Got:      h_bridge_out=%b, pwm_out=%b, step_out=%h",
                         h_bridge_out, pwm_out, step_out);
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
        $dumpvars(0,clk, dir1, dir2, pwm_duty_cycle, step_sequence, h_bridge_out, pwm_out, step_out);
    end

endmodule
