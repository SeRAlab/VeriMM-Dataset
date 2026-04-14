`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg key;
    wire [31:0] ms;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .key(key),
        .ms(ms)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        key = 0;


        repeat(4) press_key();
        $display("DUT Reset: Returned to State 1 with count cleared.");
    end
        endtask
    task press_key;

    begin
        key = 1;
        repeat(2) @(posedge clk);
        #1;
        key = 0;

        state_tracker = (state_tracker == 4) ? 1 : state_tracker + 1;
        repeat(2) @(posedge clk);
        #1;
    end
        endtask

    task testcase001;

    begin
        $display("\nTestcase 001: State 1 Counting");
        reset_dut();
        repeat(10 * TICKS_PER_MS) @(posedge clk);
        #1;

        check_outputs(32'd10);
    end
        endtask

    task testcase002;

    begin
        $display("\nTestcase 002: State 1 + State 2 Counting");
        reset_dut();
        repeat(5 * TICKS_PER_MS) @(posedge clk);
        press_key();
        repeat(5 * TICKS_PER_MS) @(posedge clk);
        #1;

        check_outputs(32'd10);
    end
        endtask

    task testcase003;

    begin
        $display("\nTestcase 003: State 3 Pause Behavior");
        reset_dut();
        repeat(5 * TICKS_PER_MS) @(posedge clk);
        press_key();
        repeat(5 * TICKS_PER_MS) @(posedge clk);
        press_key();
        repeat(20 * TICKS_PER_MS) @(posedge clk);
        #1;

        check_outputs(32'd10);
    end
        endtask

    task testcase004;

    begin
        $display("\nTestcase 004: State 4 Reset to First Key Press Count");
        reset_dut();
        repeat(7 * TICKS_PER_MS) @(posedge clk);
        press_key();
        repeat(10 * TICKS_PER_MS) @(posedge clk);
        press_key();
        repeat(5 * TICKS_PER_MS) @(posedge clk);
        press_key();
        #1;
        #1;

        check_outputs(32'd7);
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
        input [31:0] expected_ms;
        begin
            if (expected_ms === (expected_ms ^ ms ^ expected_ms)) begin
                $display("PASS");
                $display("  Outputs: ms=%h",
                         ms);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ms=%h",
                         expected_ms);
                $display("  Got:      ms=%h",
                         ms);
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
        $dumpvars(0,clk, key, ms);
    end

endmodule
