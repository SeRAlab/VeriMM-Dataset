`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [9:0] data;
    reg reset;
    wire match;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .data(data),
        .reset(reset),
        .match(match)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            data = 10'b0;
            @(posedge clk);
            #1;
            reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase 001: Basic 1-1-1 detection");
            reset_dut();
            data = 10'h001; @(posedge clk); #1;
            data = 10'h001; @(posedge clk); #1;
            data = 10'h001; @(posedge clk); #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase 002: Interrupted sequence 1-1-0");
            reset_dut();
            data = 10'h001; @(posedge clk); #1;
            data = 10'h001; @(posedge clk); #1;
            data = 10'h000; @(posedge clk); #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase 003: Sequence 1-0-1-1-1");
            reset_dut();
            data = 10'h001; @(posedge clk); #1;
            data = 10'h000; @(posedge clk); #1;
            data = 10'h001; @(posedge clk); #1;
            data = 10'h001; @(posedge clk); #1;
            data = 10'h001; @(posedge clk); #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase 004: Noise on high bits, 1-1-1 on LSB");
            reset_dut();
            data = 10'h3FE; @(posedge clk); #1;
            data = 10'h3FE; @(posedge clk); #1;
            data = 10'h3FF; @(posedge clk); #1;
            data = 10'h101; @(posedge clk); #1;
            data = 10'h001; @(posedge clk); #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase 005: Overlapping 1-1-1-1");
            reset_dut();
            data = 10'h001; @(posedge clk); #1;
            data = 10'h001; @(posedge clk); #1;
            data = 10'h001; @(posedge clk); #1;
            data = 10'h001; @(posedge clk); #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase 006: Reset mid-sequence");
            reset_dut();
            data = 10'h001; @(posedge clk); #1;
            data = 10'h001; @(posedge clk); #1;
            reset = 1; @(posedge clk); #1;
            reset = 0;
            data = 10'h001; @(posedge clk); #1;
            data = 10'h001; @(posedge clk); #1;
            #1;

            check_outputs(1'b0);
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
        input expected_match;
        begin
            if (expected_match === (expected_match ^ match ^ expected_match)) begin
                $display("PASS");
                $display("  Outputs: match=%b",
                         match);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: match=%b",
                         expected_match);
                $display("  Got:      match=%b",
                         match);
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
        $dumpvars(0,clk, data, reset, match);
    end

endmodule
