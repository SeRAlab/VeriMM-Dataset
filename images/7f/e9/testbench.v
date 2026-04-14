`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg rst_n;
    wire [15:0] pwm_angle;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .rst_n(rst_n),
        .pwm_angle(pwm_angle)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst_n = 0;
            #20;
            rst_n = 1;
            #10;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase 001: Checking reset state...");
            rst_n = 0;
            #100;

            #1;


            check_outputs(16'h0000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase 002: Checking initial value post-reset...");
            reset_dut();
            #10;

            #1;


            check_outputs(16'd500);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase 003: Checking value after 1000ns operational time...");
            reset_dut();
            #1000;


            #1;



            check_outputs(16'd600);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase 004: Checking value after 5000ns operational time...");
            reset_dut();
            #5000;

            #1;


            check_outputs(16'd1000);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase 005: Stability and timing check...");
            reset_dut();
            #2500;

            #1;


            check_outputs(16'd750);
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
        input [15:0] expected_pwm_angle;
        begin
            if (expected_pwm_angle === (expected_pwm_angle ^ pwm_angle ^ expected_pwm_angle)) begin
                $display("PASS");
                $display("  Outputs: pwm_angle=%h",
                         pwm_angle);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: pwm_angle=%h",
                         expected_pwm_angle);
                $display("  Got:      pwm_angle=%h",
                         pwm_angle);
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
        $dumpvars(0,clk, rst_n, pwm_angle);
    end

endmodule
