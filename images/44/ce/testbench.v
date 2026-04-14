`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg reset;
    wire [3:0] counter_value;
    wire reached_9;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .reset(reset),
        .counter_value(counter_value),
        .reached_9(reached_9)
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
            $display("Running Testcase 001: Initial Reset");
            test_num = 1;
            reset_dut();
            #1;

            check_outputs(4'd0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            $display("Running Testcase 002: Increment to 5");
            test_num = 2;
            reset_dut();
            repeat(5) @(posedge clk);
            #1;
            #1;

            check_outputs(4'd5, 1'b0);
        end
        endtask

    task testcase003;

        begin
            $display("Running Testcase 003: Reach 9");
            test_num = 3;
            reset_dut();
            repeat(9) @(posedge clk);
            #1;
            #1;

            check_outputs(4'd9, 1'b1);
        end
        endtask

    task testcase004;

        begin
            $display("Running Testcase 004: Increment past 9 (to 10)");
            test_num = 4;
            reset_dut();
            repeat(10) @(posedge clk);
            #1;
            #1;

            check_outputs(4'd10, 1'b0);
        end
        endtask

    task testcase005;

        begin
            $display("Running Testcase 005: Full 4-bit wrap around (16 cycles)");
            test_num = 5;
            reset_dut();
            repeat(16) @(posedge clk);
            #1;
            #1;

            check_outputs(4'd0, 1'b0);
        end
        endtask

    task testcase006;

        begin
            $display("Running Testcase 006: Reset from value 12");
            test_num = 6;
            reset_dut();
            repeat(12) @(posedge clk);
            reset_dut();
            #1;

            check_outputs(4'd0, 1'b0);
        end
        endtask

    task testcase007;

        begin
            $display("Running Testcase 007: Reach 9 after one wrap around");
            test_num = 7;
            reset_dut();
            repeat(16 + 9) @(posedge clk);
            #1;
            #1;

            check_outputs(4'd9, 1'b1);
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
        input [3:0] expected_counter_value;
        input expected_reached_9;
        begin
            if (expected_counter_value === (expected_counter_value ^ counter_value ^ expected_counter_value) &&
                expected_reached_9 === (expected_reached_9 ^ reached_9 ^ expected_reached_9)) begin
                $display("PASS");
                $display("  Outputs: counter_value=%h, reached_9=%b",
                         counter_value, reached_9);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: counter_value=%h, reached_9=%b",
                         expected_counter_value, expected_reached_9);
                $display("  Got:      counter_value=%h, reached_9=%b",
                         counter_value, reached_9);
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
        $dumpvars(0,clk, reset, counter_value, reached_9);
    end

endmodule
