`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [30:0] addend;
    reg clear;
    reg clock;
    reg enable_in;
    reg reset;
    wire enable_out;
    wire [33:0] sum;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .addend(addend),
        .clear(clear),
        .clock(clock),
        .enable_in(enable_in),
        .reset(reset),
        .enable_out(enable_out),
        .sum(sum)
    );

    // Clock generation (10ns period)
    initial begin
        clock = 0;
        forever #5 clock = ~clock;
    end

        task reset_dut;

        begin
            @(posedge clock);
            reset = 1;
            clear = 0;
            enable_in = 0;
            addend = 0;
            @(posedge clock);
            reset = 0;
            @(posedge clock);
        end
        endtask
    task testcase001;

        begin
            $display("Testcase 001: Reset Check");
            reset_dut();

            #1;


            check_outputs(1'b0, 34'sd0);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Simple Addition");
            reset_dut();
            @(posedge clock);
            enable_in = 1;
            addend = 31'sd100;
            @(posedge clock);
            enable_in = 0;
            @(posedge clock);
            #1;

            check_outputs(1'b0, 34'sd100);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Multiple Accumulations");
            reset_dut();
            @(posedge clock);
            enable_in = 1;
            addend = 31'sd50;
            @(posedge clock);
            addend = 31'sd25;
            @(posedge clock);
            addend = 31'sd25;
            @(posedge clock);
            enable_in = 0;
            @(posedge clock);
            #1;

            check_outputs(1'b0, 34'sd100);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Signed Negative Addition");
            reset_dut();
            @(posedge clock);
            enable_in = 1;
            addend = 31'sd1000;
            @(posedge clock);
            addend = -31'sd400;
            @(posedge clock);
            enable_in = 0;
            @(posedge clock);
            #1;

            check_outputs(1'b0, 34'sd600);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Clear Functionality");
            reset_dut();
            @(posedge clock);
            enable_in = 1;
            addend = 31'sd500;
            @(posedge clock);
            clear = 1;
            enable_in = 0;
            @(posedge clock);
            clear = 0;
            @(posedge clock);
            #1;

            check_outputs(1'b0, 34'sd0);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: Enable Inactive Check");
            reset_dut();
            @(posedge clock);
            enable_in = 1;
            addend = 31'sd10;
            @(posedge clock);
            enable_in = 0;
            addend = 31'sd99;
            @(posedge clock);
            @(posedge clock);
            #1;

            check_outputs(1'b0, 34'sd10);
        end
        endtask

    task testcase007;

        begin
            $display("Testcase 007: Large Value Accumulation");
            reset_dut();
            @(posedge clock);
            enable_in = 1;
            addend = 31'sh3FFFFFFF;
            @(posedge clock);
            addend = 31'sh3FFFFFFF;
            @(posedge clock);
            addend = 31'sh3FFFFFFF;
            @(posedge clock);
            enable_in = 0;
            @(posedge clock);

            #1;


            check_outputs(1'b0, (34'sh3FFFFFFF * 3));
        end
        endtask

    task testcase008;

        begin
            $display("Testcase 008: Enable Out Tracking");
            reset_dut();
            @(posedge clock);
            enable_in = 1;
            addend = 31'sd1;
            @(posedge clock);

            #1;


            check_outputs(1'b1, 34'sd1);
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
        input expected_enable_out;
        input [33:0] expected_sum;
        begin
            if (expected_enable_out === (expected_enable_out ^ enable_out ^ expected_enable_out) &&
                expected_sum === (expected_sum ^ sum ^ expected_sum)) begin
                $display("PASS");
                $display("  Outputs: enable_out=%b, sum=%h",
                         enable_out, sum);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: enable_out=%b, sum=%h",
                         expected_enable_out, expected_sum);
                $display("  Got:      enable_out=%b, sum=%h",
                         enable_out, sum);
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
        $dumpvars(0,addend, clear, clock, enable_in, reset, enable_out, sum);
    end

endmodule
