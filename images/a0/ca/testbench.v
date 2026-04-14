`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg dir;
    reg rst;
    wire [8:0] count;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .dir(dir),
        .rst(rst),
        .count(count)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            dir = 0;
            @(posedge clk);
            #1;
            rst = 0;
        end
        endtask
    task wait_cycles;

        input integer n;
        begin
            repeat(n) @(posedge clk);
            #1;
        end
        endtask

    task testcase001;

        begin
            $display("Test Case 001: Checking Reset...");
            reset_dut();
            #1;

            check_outputs(9'h000);
        end
        endtask

    task testcase002;

        begin
            $display("Test Case 002: Incrementing up 10 times...");
            reset_dut();
            dir = 1;
            wait_cycles(10);
            #1;

            check_outputs(9'd10);
        end
        endtask

    task testcase003;

        begin
            $display("Test Case 003: Decrementing down from 0 (Underflow)...");
            reset_dut();
            dir = 0;
            wait_cycles(1);
            #1;

            check_outputs(9'h1FF);
        end
        endtask

    task testcase004;

        begin
            $display("Test Case 004: Count up 20, then down 5...");
            reset_dut();
            dir = 1;
            wait_cycles(20);
            dir = 0;
            wait_cycles(5);
            #1;

            check_outputs(9'd15);
        end
        endtask

    task testcase005;

        begin
            $display("Test Case 005: Counting up past max value (511 -> 0)...");
            reset_dut();
            dir = 1;
            wait_cycles(511);
            wait_cycles(1);
            #1;

            check_outputs(9'd0);
        end
        endtask

    task testcase006;

        begin
            $display("Test Case 006: Asserting reset while counting...");
            reset_dut();
            dir = 1;
            wait_cycles(50);
            rst = 1;
            @(posedge clk);
            #1;
            rst = 0;
            #1;

            check_outputs(9'd0);
        end
        endtask

    task testcase007;

        begin
            $display("Test Case 007: Decrementing multiple times...");
            reset_dut();
            dir = 0;
            wait_cycles(100);

            #1;


            check_outputs(9'd412);
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
        input [8:0] expected_count;
        begin
            if (expected_count === (expected_count ^ count ^ expected_count)) begin
                $display("PASS");
                $display("  Outputs: count=%h",
                         count);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: count=%h",
                         expected_count);
                $display("  Got:      count=%h",
                         count);
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
        $dumpvars(0,clk, dir, rst, count);
    end

endmodule
