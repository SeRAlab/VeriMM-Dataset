`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clock;
    reg [15:0] dividend;
    reg [15:0] divisor;
    reg reset;
    wire [15:0] quot_out;
    wire [15:0] rem_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clock(clock),
        .dividend(dividend),
        .divisor(divisor),
        .reset(reset),
        .quot_out(quot_out),
        .rem_out(rem_out)
    );

    // Clock generation (10ns period)
    initial begin
        clock = 0;
        forever #5 clock = ~clock;
    end

        task reset_dut;

        begin
            reset = 1;
            dividend = 0;
            divisor = 1;
            @(posedge clock);
            #1;
            reset = 0;
            @(posedge clock);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: 20 / 3", test_num);
            reset_dut();
            dividend = 16'sd20;
            divisor = 16'sd3;

            repeat(40) @(posedge clock);
            #1;

            check_outputs(16'sd6, 16'sd2);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: 20 / -3", test_num);
            reset_dut();
            dividend = 16'sd20;
            divisor = 16'sd-3;
            repeat(40) @(posedge clock);
            #1;

            check_outputs(16'sd-6, 16'sd2);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: -20 / 3", test_num);
            reset_dut();
            dividend = 16'sd-20;
            divisor = 16'sd3;
            repeat(40) @(posedge clock);
            #1;

            check_outputs(16'sd-6, 16'sd-2);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: -20 / -3", test_num);
            reset_dut();
            dividend = 16'sd-20;
            divisor = 16'sd-3;
            repeat(40) @(posedge clock);
            #1;

            check_outputs(16'sd6, 16'sd-2);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: 0 / 15", test_num);
            reset_dut();
            dividend = 16'sd0;
            divisor = 16'sd15;
            repeat(40) @(posedge clock);
            #1;

            check_outputs(16'sd0, 16'sd0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: 1000 / 1", test_num);
            reset_dut();
            dividend = 16'sd1000;
            divisor = 16'sd1;
            repeat(40) @(posedge clock);
            #1;

            check_outputs(16'sd1000, 16'sd0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: 5 / 10", test_num);
            reset_dut();
            dividend = 16'sd5;
            divisor = 16'sd10;
            repeat(40) @(posedge clock);
            #1;

            check_outputs(16'sd0, 16'sd5);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: -5 / 10", test_num);
            reset_dut();
            dividend = 16'sd-5;
            divisor = 16'sd10;
            repeat(40) @(posedge clock);
            #1;

            check_outputs(16'sd0, 16'sd-5);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: -32768 / 1024", test_num);
            reset_dut();
            dividend = 16'sd-32768;
            divisor = 16'sd1024;
            repeat(40) @(posedge clock);
            #1;

            check_outputs(16'sd-32, 16'sd0);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: 12345 / 123", test_num);
            reset_dut();
            dividend = 16'sd12345;
            divisor = 16'sd123;
            repeat(40) @(posedge clock);
            #1;

            check_outputs(16'sd100, 16'sd45);
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
        input [15:0] expected_quot_out;
        input [15:0] expected_rem_out;
        begin
            if (expected_quot_out === (expected_quot_out ^ quot_out ^ expected_quot_out) &&
                expected_rem_out === (expected_rem_out ^ rem_out ^ expected_rem_out)) begin
                $display("PASS");
                $display("  Outputs: quot_out=%h, rem_out=%h",
                         quot_out, rem_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: quot_out=%h, rem_out=%h",
                         expected_quot_out, expected_rem_out);
                $display("  Got:      quot_out=%h, rem_out=%h",
                         quot_out, rem_out);
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
        $dumpvars(0,clock, dividend, divisor, reset, quot_out, rem_out);
    end

endmodule
