`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [12:0] slow_rate;
    wire speaker_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .slow_rate(slow_rate),
        .speaker_out(speaker_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            slow_rate = 13'h1FFF;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            $display("Test Case 001: Slow rate = 0 (Disabled)");
            slow_rate = 13'd0;
            repeat (20) @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            $display("Test Case 002: Slow rate = 5, toggle High");
            slow_rate = 13'd5;
            repeat (5) @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            $display("Test Case 003: Slow rate = 5, toggle Low after full cycle");
            slow_rate = 13'd5;
            repeat (10) @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            $display("Test Case 004: Slow rate = 1, fast toggle");
            slow_rate = 13'd1;
            repeat (1) @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            $display("Test Case 005: Slow rate = 100, checking mid-count state");
            slow_rate = 13'd100;
            repeat (50) @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();
            $display("Test Case 006: Reset on slow_rate change");
            slow_rate = 13'd10;
            repeat (5) @(posedge clk);
            slow_rate = 13'd2;
            repeat (2) @(posedge clk);
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
        input expected_speaker_out;
        begin
            if (expected_speaker_out === (expected_speaker_out ^ speaker_out ^ expected_speaker_out)) begin
                $display("PASS");
                $display("  Outputs: speaker_out=%b",
                         speaker_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: speaker_out=%b",
                         expected_speaker_out);
                $display("  Got:      speaker_out=%b",
                         speaker_out);
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
        $dumpvars(0,clk, slow_rate, speaker_out);
    end

endmodule
