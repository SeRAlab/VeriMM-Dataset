`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [15:0] duration;
    reg in;
    wire [31:0] count;
    wire out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .duration(duration),
        .in(in),
        .count(count),
        .out(out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            in = 0;
            duration = 0;
            repeat(5) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            duration = 16'd5;
            @(posedge clk);
            in = 1;
            @(posedge clk);
            in = 0;

            repeat(10) @(posedge clk);
            expected_count_val = expected_count_val + 1;
            $display("Testcase 001: Basic pulse (duration 5)");
            #1;

            check_outputs(expected_count_val, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            duration = 16'd20;
            @(posedge clk);
            in = 1;
            @(posedge clk);
            in = 0;
            repeat(25) @(posedge clk);
            expected_count_val = expected_count_val + 1;
            $display("Testcase 002: Long pulse (duration 20)");
            #1;

            check_outputs(expected_count_val, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            duration = 16'd15;
            @(posedge clk);
            in = 1;
            @(posedge clk);
            in = 0;
            repeat(5) @(posedge clk);

            in = 1;
            @(posedge clk);
            in = 0;
            repeat(20) @(posedge clk);

            expected_count_val = expected_count_val + 1;
            $display("Testcase 003: Trigger during active pulse");
            #1;

            check_outputs(expected_count_val, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            duration = 16'd4;

            @(posedge clk); in = 1; @(posedge clk); in = 0;
            repeat(10) @(posedge clk);

            @(posedge clk); in = 1; @(posedge clk); in = 0;
            repeat(10) @(posedge clk);
            expected_count_val = expected_count_val + 2;
            $display("Testcase 004: Sequential pulses");
            #1;

            check_outputs(expected_count_val, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            duration = 16'd1;
            @(posedge clk);
            in = 1;
            @(posedge clk);
            in = 0;
            repeat(5) @(posedge clk);
            expected_count_val = expected_count_val + 1;
            $display("Testcase 005: Minimum duration (1 cycle)");
            #1;

            check_outputs(expected_count_val, 1'b0);
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
        input [31:0] expected_count;
        input expected_out;
        begin
            if (expected_count === (expected_count ^ count ^ expected_count) &&
                expected_out === (expected_out ^ out ^ expected_out)) begin
                $display("PASS");
                $display("  Outputs: count=%h, out=%b",
                         count, out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: count=%h, out=%b",
                         expected_count, expected_out);
                $display("  Got:      count=%h, out=%b",
                         count, out);
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
        $dumpvars(0,clk, duration, in, count, out);
    end

endmodule
