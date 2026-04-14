`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] shift;
    wire clk_shifted;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .shift(shift),
        .clk_shifted(clk_shifted)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            shift = 8'd0;
            #20;
        end
        endtask
    task testcase001;

        begin
            $display("\nTestcase 001: Zero Phase Shift (shift=0)");
            reset_dut();
            shift = 8'd0;
            @(posedge clk);
            #0.1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            $display("\nTestcase 002: 180 Degree Phase Shift (shift=128)");
            reset_dut();
            shift = 8'd128;
            @(posedge clk);
            #0.1;
            #1;

            check_outputs(1'b0);
            #5;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            $display("\nTestcase 003: 90 Degree Phase Shift (shift=64)");
            reset_dut();
            shift = 8'd64;
            @(posedge clk);
            #1.0;
            #1;

            check_outputs(1'b0);
            #2.0;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            $display("\nTestcase 004: 270 Degree Phase Shift (shift=192)");
            reset_dut();
            shift = 8'd192;
            @(posedge clk);
            #5.0;
            #1;

            check_outputs(1'b0);
            #3.0;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            $display("\nTestcase 005: Maximum Phase Shift (shift=255)");
            reset_dut();
            shift = 8'd255;
            @(posedge clk);
            #9.0;
            #1;

            check_outputs(1'b0);
            #1.5;
            #1;

            check_outputs(1'b1);
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
        input expected_clk_shifted;
        begin
            if (expected_clk_shifted === (expected_clk_shifted ^ clk_shifted ^ expected_clk_shifted)) begin
                $display("PASS");
                $display("  Outputs: clk_shifted=%b",
                         clk_shifted);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: clk_shifted=%b",
                         expected_clk_shifted);
                $display("  Got:      clk_shifted=%b",
                         clk_shifted);
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
        $dumpvars(0,clk, shift, clk_shifted);
    end

endmodule
