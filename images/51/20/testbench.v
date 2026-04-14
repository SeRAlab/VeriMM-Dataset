`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg rst;
    reg temp_in;
    wire fan_pwm;
    wire overtemp;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .rst(rst),
        .temp_in(temp_in),
        .fan_pwm(fan_pwm),
        .overtemp(overtemp)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            temp_in = 0;
            #20;
            rst = 0;
            #10;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            #20;
            $display("Testcase 001: Checking Reset State");
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            temp_in = 0;
            #100;
            $display("Testcase 002: Checking Low Temperature Operation");
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            #10;
            temp_in = 1;
            #100;
            $display("Testcase 003: Checking Over-Temperature Triggering");
            #1;

            check_outputs(1'b1, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            temp_in = 1;
            #50;
            temp_in = 0;
            #40;
            $display("Testcase 004: Checking Alert Persistence after Temperature Drops");
            #1;

            check_outputs(1'b1, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            temp_in = 1;
            #50;
            temp_in = 0;
            #500;
            $display("Testcase 005: Checking System Recovery after Alert Duration");
            #1;

            check_outputs(1'b0, 1'b0);
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
        input expected_fan_pwm;
        input expected_overtemp;
        begin
            if (expected_fan_pwm === (expected_fan_pwm ^ fan_pwm ^ expected_fan_pwm) &&
                expected_overtemp === (expected_overtemp ^ overtemp ^ expected_overtemp)) begin
                $display("PASS");
                $display("  Outputs: fan_pwm=%b, overtemp=%b",
                         fan_pwm, overtemp);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: fan_pwm=%b, overtemp=%b",
                         expected_fan_pwm, expected_overtemp);
                $display("  Got:      fan_pwm=%b, overtemp=%b",
                         fan_pwm, overtemp);
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
        $dumpvars(0,clk, rst, temp_in, fan_pwm, overtemp);
    end

endmodule
