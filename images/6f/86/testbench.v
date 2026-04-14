`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg reset;
    wire [3:0] ring_counter;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .reset(reset),
        .ring_counter(ring_counter)
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
            $display("Running Testcase 001: Reset State Check...");
            test_num = 1;
            reset_dut();
            #1;

            check_outputs(4'b0001);
        end
        endtask

    task testcase002;

        begin
            $display("Running Testcase 002: Single Left Rotation...");
            test_num = 2;
            reset_dut();
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'b0010);
        end
        endtask

    task testcase003;

        begin
            $display("Running Testcase 003: Double Left Rotation...");
            test_num = 3;
            reset_dut();
            repeat(2) @(posedge clk);
            #1;
            #1;

            check_outputs(4'b0100);
        end
        endtask

    task testcase004;

        begin
            $display("Running Testcase 004: Triple Left Rotation...");
            test_num = 4;
            reset_dut();
            repeat(3) @(posedge clk);
            #1;
            #1;

            check_outputs(4'b1000);
        end
        endtask

    task testcase005;

        begin
            $display("Running Testcase 005: Full Cycle (4 steps) Rotation...");
            test_num = 5;
            reset_dut();
            repeat(4) @(posedge clk);
            #1;
            #1;

            check_outputs(4'b0001);
        end
        endtask

    task testcase006;

        begin
            $display("Running Testcase 006: Extended Rotation (10 steps)...");
            test_num = 6;
            reset_dut();
            repeat(10) @(posedge clk);
            #1;
            #1;

            check_outputs(4'b0100);
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
        input [3:0] expected_ring_counter;
        begin
            if (expected_ring_counter === (expected_ring_counter ^ ring_counter ^ expected_ring_counter)) begin
                $display("PASS");
                $display("  Outputs: ring_counter=%h",
                         ring_counter);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ring_counter=%h",
                         expected_ring_counter);
                $display("  Got:      ring_counter=%h",
                         ring_counter);
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
        $dumpvars(0,clk, reset, ring_counter);
    end

endmodule
