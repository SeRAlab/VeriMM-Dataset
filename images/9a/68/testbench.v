`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] duty_cycle;
    reg [31:0] pwm_freq;
    reg rst;
    wire pwm_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .duty_cycle(duty_cycle),
        .pwm_freq(pwm_freq),
        .rst(rst),
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
            pwm_freq = 0;
            duty_cycle = 0;
            #20;
            rst = 0;
            #20;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            pwm_freq = 100;
            duty_cycle = 50;
            repeat(20) @(posedge clk);
            #1;
            $display("Testcase 001: Freq=100, Duty=50, check at cycle 20 (High phase)");
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            pwm_freq = 100;
            duty_cycle = 50;
            repeat(75) @(posedge clk);
            #1;
            $display("Testcase 002: Freq=100, Duty=50, check at cycle 75 (Low phase)");
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            pwm_freq = 200;
            duty_cycle = 20;
            repeat(10) @(posedge clk);
            #1;
            $display("Testcase 003: Freq=200, Duty=20, check at cycle 10 (High phase)");
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            pwm_freq = 200;
            duty_cycle = 20;
            repeat(100) @(posedge clk);
            #1;
            $display("Testcase 004: Freq=200, Duty=20, check at cycle 100 (Low phase)");
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            pwm_freq = 100;
            duty_cycle = 0;
            repeat(50) @(posedge clk);
            #1;
            $display("Testcase 005: Freq=100, Duty=0, check at cycle 50 (Always Low)");
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();
            pwm_freq = 100;
            duty_cycle = 100;
            repeat(50) @(posedge clk);
            #1;
            $display("Testcase 006: Freq=100, Duty=100, check at cycle 50 (Always High)");
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            reset_dut();
            pwm_freq = 10;
            duty_cycle = 50;
            repeat(2) @(posedge clk);
            #1;
            $display("Testcase 007: Freq=10, Duty=50, check at cycle 2 (High phase)");
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            reset_dut();
            pwm_freq = 10;
            duty_cycle = 50;
            repeat(8) @(posedge clk);
            #1;
            $display("Testcase 008: Freq=10, Duty=50, check at cycle 8 (Low phase)");
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;

            pwm_freq = 100;
            duty_cycle = 100;
            rst = 1;
            #50;
            $display("Testcase 009: Check output is Low during/immediately after reset");
            #1;

            check_outputs(1'b0);
            rst = 0;
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
        $dumpvars(0,clk, duty_cycle, pwm_freq, rst, pwm_out);
    end

endmodule
