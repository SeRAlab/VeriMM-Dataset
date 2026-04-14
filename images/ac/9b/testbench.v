`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg reset;
    wire reset_release;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .reset(reset),
        .reset_release(reset_release)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            @(posedge clk);
            reset = 1;
            repeat (2) @(posedge clk);
            reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            $display("Testcase 001: Checking full delay release...");
            reset_dut();

            repeat (20) @(posedge clk);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Checking output remains LOW during delay...");
            reset_dut();

            repeat (5) @(posedge clk);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Checking immediate asynchronous reset assertion...");

            reset = 0;
            repeat (20) @(posedge clk);

            reset = 1;
            #1;
            #1;

            check_outputs(1'b0);
            reset = 0;
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Checking stability after release...");
            reset_dut();
            repeat (40) @(posedge clk);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Checking release when reset is held active...");
            reset = 1;

            repeat (25) @(posedge clk);
            #1;

            check_outputs(1'b1);
            reset = 0;
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
        input expected_reset_release;
        begin
            if (expected_reset_release === (expected_reset_release ^ reset_release ^ expected_reset_release)) begin
                $display("PASS");
                $display("  Outputs: reset_release=%b",
                         reset_release);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: reset_release=%b",
                         expected_reset_release);
                $display("  Got:      reset_release=%b",
                         reset_release);
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
        $dumpvars(0,clk, reset, reset_release);
    end

endmodule
