`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg count;
    reg rst;
    reg ud;
    wire [5:0] counter_value;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .count(count),
        .rst(rst),
        .ud(ud),
        .counter_value(counter_value)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            count = 0;
            ud = 0;
            @(posedge clk);
            #1;
            rst = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            count = 1; ud = 1;
            repeat(10) @(posedge clk);
            #1;
            $display("Testcase 001: Increment 10 times");
            #1;

            check_outputs(6'd10);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            count = 1; ud = 0;
            repeat(1) @(posedge clk);
            #1;
            $display("Testcase 002: Decrement from 0 (Underflow)");
            #1;

            check_outputs(6'h3F);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            count = 1; ud = 1;
            repeat(5) @(posedge clk);
            count = 0;
            repeat(5) @(posedge clk);
            #1;
            $display("Testcase 003: Increment to 5 then Hold");
            #1;

            check_outputs(6'd5);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            count = 1; ud = 1;
            repeat(20) @(posedge clk);
            ud = 0;
            repeat(7) @(posedge clk);
            #1;
            $display("Testcase 004: Increment 20 then Decrement 7");
            #1;

            check_outputs(6'd13);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            count = 1; ud = 1;
            repeat(64) @(posedge clk);
            #1;
            $display("Testcase 005: Overflow (64 increments)");
            #1;

            check_outputs(6'd0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();
            count = 1; ud = 0;
            repeat(10) @(posedge clk);
            count = 0;
            repeat(3) @(posedge clk);
            #1;
            $display("Testcase 006: Decrement 10 then Hold");
            #1;

            check_outputs(6'd54);
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
        input [5:0] expected_counter_value;
        begin
            if (expected_counter_value === (expected_counter_value ^ counter_value ^ expected_counter_value)) begin
                $display("PASS");
                $display("  Outputs: counter_value=%h",
                         counter_value);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: counter_value=%h",
                         expected_counter_value);
                $display("  Got:      counter_value=%h",
                         counter_value);
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
        $dumpvars(0,clk, count, rst, ud, counter_value);
    end

endmodule
