`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg reset;
    wire [3:0] counter;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .reset(reset),
        .counter(counter)
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
        $display("Running testcase001: Reset Check");
        reset_dut();
        #1;

        check_outputs(4'd0);
    end
        endtask

    task testcase002;

    begin
        $display("Running testcase002: Increment to 1");
        reset_dut();
        @(posedge clk);
        #1;
        #1;

        check_outputs(4'd1);
    end
        endtask

    task testcase003;

    begin
        $display("Running testcase003: Increment to 7");
        reset_dut();
        repeat(7) @(posedge clk);
        #1;
        #1;

        check_outputs(4'd7);
    end
        endtask

    task testcase004;

    begin
        $display("Running testcase004: Increment to 15 (Max Value)");
        reset_dut();
        repeat(15) @(posedge clk);
        #1;
        #1;

        check_outputs(4'd15);
    end
        endtask

    task testcase005;

    begin
        $display("Running testcase005: Wrap around check (16 cycles)");
        reset_dut();
        repeat(16) @(posedge clk);
        #1;
        #1;

        check_outputs(4'd0);
    end
        endtask

    task testcase006;

    begin
        $display("Running testcase006: Multiple wraps (34 cycles)");

        reset_dut();
        repeat(34) @(posedge clk);
        #1;
        #1;

        check_outputs(4'd2);
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
        input [3:0] expected_counter;
        begin
            if (expected_counter === (expected_counter ^ counter ^ expected_counter)) begin
                $display("PASS");
                $display("  Outputs: counter=%h",
                         counter);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: counter=%h",
                         expected_counter);
                $display("  Got:      counter=%h",
                         counter);
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
        $dumpvars(0,clk, reset, counter);
    end

endmodule
