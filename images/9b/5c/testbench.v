`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg reset;
    wire [3:0] count;
    wire [3:0] leds;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .reset(reset),
        .count(count),
        .leds(leds)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            @(posedge clk);
            #1;
            reset = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case 001: Verify Reset to Zero");
            reset_dut();

            #1;


            check_outputs(4'd0, 4'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case 002: Increment to Mid-value (5)");
            reset_dut();
            repeat(5) @(posedge clk);
            #1;
            #1;

            check_outputs(4'd5, 4'd5);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case 003: Increment to Maximum Value (15)");
            reset_dut();
            repeat(15) @(posedge clk);
            #1;
            #1;

            check_outputs(4'd15, 4'd15);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case 004: Rollover Check (16 cycles)");
            reset_dut();
            repeat(16) @(posedge clk);
            #1;
            #1;

            check_outputs(4'd0, 4'd0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case 005: Multiple Rollovers (35 cycles)");
            reset_dut();
            repeat(35) @(posedge clk);
            #1;
            #1;

            check_outputs(4'd3, 4'd3);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case 006: Asynchronous-like reset timing check");
            reset_dut();
            repeat(8) @(posedge clk);
            reset = 1;
            @(posedge clk);
            #1;
            reset = 0;
            repeat(2) @(posedge clk);
            #1;
            #1;

            check_outputs(4'd2, 4'd2);
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
        input [3:0] expected_count;
        input [3:0] expected_leds;
        begin
            if (expected_count === (expected_count ^ count ^ expected_count) &&
                expected_leds === (expected_leds ^ leds ^ expected_leds)) begin
                $display("PASS");
                $display("  Outputs: count=%h, leds=%h",
                         count, leds);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: count=%h, leds=%h",
                         expected_count, expected_leds);
                $display("  Got:      count=%h, leds=%h",
                         count, leds);
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
        $dumpvars(0,clk, reset, count, leds);
    end

endmodule
