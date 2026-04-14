`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] max_val;
    reg reset;
    wire [3:0] count_val;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .max_val(max_val),
        .reset(reset),
        .count_val(count_val)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        reset = 1;
        #15;
        reset = 0;
        #5;
    end
        endtask
    task testcase002;

    begin
        test_num = 2;
        reset_dut();
        max_val = 10;
        repeat(5) @(posedge clk);
        #2;
        #1;

        check_outputs(4'd5);
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


        testcase002();
        
        
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
        input [3:0] expected_count_val;
        begin
            if (expected_count_val === (expected_count_val ^ count_val ^ expected_count_val)) begin
                $display("PASS");
                $display("  Outputs: count_val=%h",
                         count_val);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: count_val=%h",
                         expected_count_val);
                $display("  Got:      count_val=%h",
                         count_val);
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
        $dumpvars(0,clk, max_val, reset, count_val);
    end

endmodule
