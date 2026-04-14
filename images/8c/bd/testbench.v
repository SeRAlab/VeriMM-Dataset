`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [16:0] amp;
    reg clksamp;
    reg [9:0] duty;
    reg [31:0] freq;
    reg [16:0] offset;
    wire [11:0] sq;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .amp(amp),
        .clksamp(clksamp),
        .duty(duty),
        .freq(freq),
        .offset(offset),
        .sq(sq)
    );

    // Clock generation (10ns period)
    initial begin
        clksamp = 0;
        forever #5 clksamp = ~clksamp;
    end

        task reset_dut;

        begin
            amp = 0;
            freq = 0;
            offset = 0;
            duty = 0;
            @(posedge clksamp);
            @(posedge clksamp);
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            freq = 0;
            amp = 500;
            offset = 1200;
            duty = 512;
            repeat(10) @(posedge clksamp);
            $display("Test Case 001: Zero Frequency");
            #1;

            check_outputs(1200);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            freq = 100;
            amp = 0;
            offset = 2500;
            duty = 512;
            repeat(10) @(posedge clksamp);
            $display("Test Case 002: Zero Amplitude");
            #1;

            check_outputs(2500);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            freq = 100;
            amp = 400;
            offset = 1000;
            duty = 512;
            @(posedge clksamp);
            repeat(5) @(posedge clksamp);
            $display("Test Case 003: Normal Square Wave High State");
            #1;

            check_outputs(1400);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            freq = 100;
            amp = 400;
            offset = 1000;
            duty = 512;
            @(posedge clksamp);
            repeat(70) @(posedge clksamp);
            $display("Test Case 004: Normal Square Wave Low State");
            #1;

            check_outputs(600);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            freq = 100;
            amp = 1000;
            offset = 3500;
            duty = 512;
            @(posedge clksamp);
            repeat(5) @(posedge clksamp);
            $display("Test Case 005: Clamping High (3500+1000=4500 -> 4095)");
            #1;

            check_outputs(4095);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = 6;
            freq = 100;
            amp = 2000;
            offset = 500;
            duty = 512;
            @(posedge clksamp);
            repeat(70) @(posedge clksamp);
            $display("Test Case 006: Clamping Low (500-2000=-1500 -> 0)");
            #1;

            check_outputs(0);
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            test_num = 7;
            freq = 100;
            amp = 500;
            offset = 1500;
            duty = 0;
            @(posedge clksamp);
            repeat(20) @(posedge clksamp);
            $display("Test Case 007: 0%% Duty Cycle");
            #1;

            check_outputs(1000);
        end
        endtask

    task testcase008;

        begin
            reset_dut();
            test_num = 8;
            freq = 100;
            amp = 500;
            offset = 1500;
            duty = 1023;
            @(posedge clksamp);
            repeat(90) @(posedge clksamp);
            $display("Test Case 008: 100%% Duty Cycle");
            #1;

            check_outputs(2000);
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
        input [11:0] expected_sq;
        begin
            if (expected_sq === (expected_sq ^ sq ^ expected_sq)) begin
                $display("PASS");
                $display("  Outputs: sq=%h",
                         sq);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: sq=%h",
                         expected_sq);
                $display("  Got:      sq=%h",
                         sq);
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
        $dumpvars(0,amp, clksamp, duty, freq, offset, sq);
    end

endmodule
