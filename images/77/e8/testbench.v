`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] duty_cycle;
    wire pwm_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .duty_cycle(duty_cycle),
        .pwm_out(pwm_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            duty_cycle = 4'd0;


            repeat(16) @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("Running Testcase 001: Duty Cycle 0 (Always Low)");
            test_num = test_num + 1;
            reset_dut();
            duty_cycle = 4'd0;
            repeat(5) @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            $display("Running Testcase 002: Duty Cycle 8 - High Phase Check");
            test_num = test_num + 1;
            reset_dut();
            duty_cycle = 4'd8;

            repeat(4) @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            $display("Running Testcase 003: Duty Cycle 8 - Low Phase Check");
            test_num = test_num + 1;
            reset_dut();
            duty_cycle = 4'd8;

            repeat(12) @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            $display("Running Testcase 004: Duty Cycle 1 - Start High Tick");
            test_num = test_num + 1;
            reset_dut();
            duty_cycle = 4'd1;

            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            $display("Running Testcase 005: Duty Cycle 1 - Low Tick Check");
            test_num = test_num + 1;
            reset_dut();
            duty_cycle = 4'd1;

            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase006;

        begin
            $display("Running Testcase 006: Duty Cycle 15 - High Phase 14/15");
            test_num = test_num + 1;
            reset_dut();
            duty_cycle = 4'd15;

            repeat(14) @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase007;

        begin
            $display("Running Testcase 007: Duty Cycle 15 - Single Low Tick at 15");
            test_num = test_num + 1;
            reset_dut();
            duty_cycle = 4'd15;

            repeat(15) @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase008;

        begin
            $display("Running Testcase 008: Rollover and Stability Check");
            test_num = test_num + 1;
            reset_dut();
            duty_cycle = 4'd4;

            repeat(18) @(posedge clk);
            #1;
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
        testcase006();
        testcase007();
        testcase008();
        
        
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
        $dumpvars(0,clk, duty_cycle, pwm_out);
    end

endmodule
