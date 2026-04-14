`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] binary_num;
    reg clk;
    reg reset;
    wire [2:0] count_ones;
    wire is_gt6;
    wire is_multiple_of_5;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .binary_num(binary_num),
        .clk(clk),
        .reset(reset),
        .count_ones(count_ones),
        .is_gt6(is_gt6),
        .is_multiple_of_5(is_multiple_of_5)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            binary_num = 0;
            @(posedge clk);
            #1 reset = 0;

            if (count_ones !== 3'b0 || is_gt6 !== 1'b0 || is_multiple_of_5 !== 1'b0) begin
                $display("Reset Failure: Outputs not cleared on reset");
            end
        end
        endtask
    task testcase001;

        begin
            $display("\nTestcase 001: binary_num = 0");
            reset_dut();
            binary_num = 4'd0;
            @(posedge clk);
            #2 #1;
 check_outputs(3'd0, 1'b0, 1'b1);
        end
        endtask

    task testcase002;

        begin
            $display("\nTestcase 002: binary_num = 1");
            reset_dut();
            binary_num = 4'd1;
            @(posedge clk);
            #2 #1;
 check_outputs(3'd1, 1'b0, 1'b0);
        end
        endtask

    task testcase003;

        begin
            $display("\nTestcase 003: binary_num = 5");
            reset_dut();
            binary_num = 4'd5;
            @(posedge clk);
            #2 #1;
 check_outputs(3'd2, 1'b0, 1'b1);
        end
        endtask

    task testcase004;

        begin
            $display("\nTestcase 004: binary_num = 6");
            reset_dut();
            binary_num = 4'd6;
            @(posedge clk);
            #2 #1;
 check_outputs(3'd2, 1'b0, 1'b0);
        end
        endtask

    task testcase005;

        begin
            $display("\nTestcase 005: binary_num = 7");
            reset_dut();
            binary_num = 4'd7;
            @(posedge clk);
            #2 #1;
 check_outputs(3'd3, 1'b1, 1'b0);
        end
        endtask

    task testcase006;

        begin
            $display("\nTestcase 006: binary_num = 10");
            reset_dut();
            binary_num = 4'd10;
            @(posedge clk);
            #2 #1;
 check_outputs(3'd2, 1'b1, 1'b1);
        end
        endtask

    task testcase007;

        begin
            $display("\nTestcase 007: binary_num = 13");
            reset_dut();
            binary_num = 4'd13;
            @(posedge clk);
            #2 #1;
 check_outputs(3'd3, 1'b1, 1'b0);
        end
        endtask

    task testcase008;

        begin
            $display("\nTestcase 008: binary_num = 15");
            reset_dut();
            binary_num = 4'd15;
            @(posedge clk);
            #2 #1;
 check_outputs(3'd4, 1'b1, 1'b1);
        end
        endtask

    task testcase009;

        begin
            $display("\nTestcase 009: Reset Verification");
            reset = 0;
            binary_num = 4'd15;
            @(posedge clk);
            #1 reset = 1;
            @(posedge clk);
            #1 #1;
 check_outputs(3'd0, 1'b0, 1'b0);
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
        testcase006();
        testcase007();
        testcase008();
        testcase009();
        
        
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
        input [2:0] expected_count_ones;
        input expected_is_gt6;
        input expected_is_multiple_of_5;
        begin
            if (expected_count_ones === (expected_count_ones ^ count_ones ^ expected_count_ones) &&
                expected_is_gt6 === (expected_is_gt6 ^ is_gt6 ^ expected_is_gt6) &&
                expected_is_multiple_of_5 === (expected_is_multiple_of_5 ^ is_multiple_of_5 ^ expected_is_multiple_of_5)) begin
                $display("PASS");
                $display("  Outputs: count_ones=%h, is_gt6=%b, is_multiple_of_5=%b",
                         count_ones, is_gt6, is_multiple_of_5);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: count_ones=%h, is_gt6=%b, is_multiple_of_5=%b",
                         expected_count_ones, expected_is_gt6, expected_is_multiple_of_5);
                $display("  Got:      count_ones=%h, is_gt6=%b, is_multiple_of_5=%b",
                         count_ones, is_gt6, is_multiple_of_5);
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
        $dumpvars(0,binary_num, clk, reset, count_ones, is_gt6, is_multiple_of_5);
    end

endmodule
