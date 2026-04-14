`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk_1hz;
    wire [3:0] hours;
    wire [3:0] minutes;
    wire [3:0] seconds;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk_1hz(clk_1hz),
        .hours(hours),
        .minutes(minutes),
        .seconds(seconds)
    );

    // Clock generation (10ns period)
    initial begin
        clk_1hz = 0;
        forever #5 clk_1hz = ~clk_1hz;
    end

        task reset_dut;

        begin
            force dut.hours = 0;
            force dut.minutes = 0;
            force dut.seconds = 0;
            #10;
            release dut.hours;
            release dut.minutes;
            release dut.seconds;
            $display("DUT Reset to 00:00:00");
        end
        endtask
    task testcase001;

        begin
            $display("\nTestcase 001: Increment 10 seconds");
            reset_dut();
            repeat(10) @(posedge clk_1hz);
            #2;
            #1;

            check_outputs(0, 0, 10);
        end
        endtask

    task testcase002;

        begin
            $display("\nTestcase 002: Minute rollover (60s -> 1m 0s)");
            reset_dut();
            repeat(60) @(posedge clk_1hz);
            #2;
            #1;

            check_outputs(0, 1, 0);
        end
        endtask

    task testcase003;

        begin
            $display("\nTestcase 003: Hour rollover (3600s -> 1h 0m 0s)");
            reset_dut();
            repeat(3600) @(posedge clk_1hz);
            #2;
            #1;

            check_outputs(1, 0, 0);
        end
        endtask

    task testcase004;

        begin
            $display("\nTestcase 004: Max day time (23:59:59)");
            reset_dut();
            repeat(86399) @(posedge clk_1hz);
            #2;
            #1;

            check_outputs(7, 11, 11);
        end
        endtask

    task testcase005;

        begin
            $display("\nTestcase 005: 24-hour wrap around (86400s -> 00:00:00)");
            reset_dut();
            repeat(86400) @(posedge clk_1hz);
            #2;
            #1;

            check_outputs(0, 0, 0);
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
        input [3:0] expected_hours;
        input [3:0] expected_minutes;
        input [3:0] expected_seconds;
        begin
            if (expected_hours === (expected_hours ^ hours ^ expected_hours) &&
                expected_minutes === (expected_minutes ^ minutes ^ expected_minutes) &&
                expected_seconds === (expected_seconds ^ seconds ^ expected_seconds)) begin
                $display("PASS");
                $display("  Outputs: hours=%h, minutes=%h, seconds=%h",
                         hours, minutes, seconds);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: hours=%h, minutes=%h, seconds=%h",
                         expected_hours, expected_minutes, expected_seconds);
                $display("  Got:      hours=%h, minutes=%h, seconds=%h",
                         hours, minutes, seconds);
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
        $dumpvars(0,clk_1hz, hours, minutes, seconds);
    end

endmodule
