`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg direction;
    reg reset;
    wire [15:0] count;
    wire [3:0] overflows;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .direction(direction),
        .reset(reset),
        .count(count),
        .overflows(overflows)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            direction = 1;
            @(posedge clk);
            #1;
            reset = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase 001: Checking Reset State");
            reset_dut();
            #1;

            check_outputs(16'd0, 4'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase 002: Counting Up 500 steps");
            reset_dut();
            direction = 1;
            repeat(500) @(posedge clk);
            #1;
            #1;

            check_outputs(16'd500, 4'd0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase 003: Counting Up Wrap-around (10,000 steps)");
            reset_dut();
            direction = 1;
            repeat(10000) @(posedge clk);
            #1;
            #1;

            check_outputs(16'd0, 4'd1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase 004: Counting Down Wrap-around (1 step from 0)");
            reset_dut();
            direction = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'd9999, 4'd1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase 005: Multiple Up Wrap-arounds (30,000 steps)");
            reset_dut();
            direction = 1;
            repeat(30000) @(posedge clk);
            #1;
            #1;

            check_outputs(16'd0, 4'd3);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase 006: Multiple Down Wrap-arounds (20,001 steps)");
            reset_dut();
            direction = 0;
            repeat(20001) @(posedge clk);
            #1;





            #1;






            check_outputs(16'd9999, 4'd3);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase 007: Direction Switching");
            reset_dut();
            direction = 1;
            repeat(5000) @(posedge clk);
            direction = 0;
            repeat(2000) @(posedge clk);
            #1;
            #1;

            check_outputs(16'd3000, 4'd0);
        end
        endtask

    task testcase008;

        integer i;
        begin
            test_num = 8;
            $display("Testcase 008: Testing Overflow Rollover (16 total overflows)");
            reset_dut();
            direction = 1;

            repeat(160000) @(posedge clk);
            #1;

            #1;


            check_outputs(16'd0, 4'd0);
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
        input [15:0] expected_count;
        input [3:0] expected_overflows;
        begin
            if (expected_count === (expected_count ^ count ^ expected_count) &&
                expected_overflows === (expected_overflows ^ overflows ^ expected_overflows)) begin
                $display("PASS");
                $display("  Outputs: count=%h, overflows=%h",
                         count, overflows);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: count=%h, overflows=%h",
                         expected_count, expected_overflows);
                $display("  Got:      count=%h, overflows=%h",
                         count, overflows);
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
        $dumpvars(0,clk, direction, reset, count, overflows);
    end

endmodule
