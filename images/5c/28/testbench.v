`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] button;
    reg clock;
    reg reset;
    wire [3:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .button(button),
        .clock(clock),
        .reset(reset),
        .out(out)
    );

        task reset_dut;

        begin
            reset = 1;
            button = 4'b0000;
            repeat(10) @(posedge clock);
            reset = 0;
            repeat(10) @(posedge clock);
        end
        endtask
    task testcase001;

        begin
            $display("Running Testcase 001: Stable Press Propagation...");
            reset_dut();
            button = 4'b0001;
            repeat(100) @(posedge clock);
            #1;

            check_outputs(4'b0001);
        end
        endtask

    task testcase002;

        begin
            $display("Running Testcase 002: Glitch Suppression...");
            reset_dut();
            button = 4'b0010;
            repeat(2) @(posedge clock);
            button = 4'b0000;
            repeat(100) @(posedge clock);
            #1;

            check_outputs(4'b0000);
        end
        endtask

    task testcase003;

        begin
            $display("Running Testcase 003: Multiple Button Press...");
            reset_dut();
            button = 4'b1011;
            repeat(100) @(posedge clock);
            #1;

            check_outputs(4'b1011);
        end
        endtask

    task testcase004;

        begin
            $display("Running Testcase 004: Button Release Propagation...");
            reset_dut();
            button = 4'b1111;
            repeat(100) @(posedge clock);
            button = 4'b0110;
            repeat(100) @(posedge clock);
            #1;

            check_outputs(4'b0110);
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
        input [3:0] expected_out;
        begin
            if (expected_out === (expected_out ^ out ^ expected_out)) begin
                $display("PASS");
                $display("  Outputs: out=%h",
                         out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out=%h",
                         expected_out);
                $display("  Got:      out=%h",
                         out);
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
        $dumpvars(0,button, clock, reset, out);
    end

endmodule
