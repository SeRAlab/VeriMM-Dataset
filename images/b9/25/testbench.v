`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] A;
    reg [7:0] B;
    reg clk;
    reg [1:0] op;
    reg reset;
    wire [15:0] result;
    wire valid;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .clk(clk),
        .op(op),
        .reset(reset),
        .result(result),
        .valid(valid)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            A = 0;
            B = 0;
            op = 0;
            @(posedge clk);
            #1;
            reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("Test Case 001: Simple Addition (10 + 20)");
            reset_dut();
            A = 8'sd10;
            B = 8'sd20;
            op = 2'b00;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'sd30, 1'b1);
        end
        endtask

    task testcase002;

        begin
            $display("Test Case 002: Simple Subtraction (15 - 40)");
            reset_dut();
            A = 8'sd15;
            B = 8'sd40;
            op = 2'b01;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'sd(-25), 1'b1);
        end
        endtask

    task testcase003;

        begin
            $display("Test Case 003: Multiplication (12 * -5)");
            reset_dut();
            A = 8'sd12;
            B = -8'sd5;
            op = 2'b10;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'sd(-60), 1'b1);
        end
        endtask

    task testcase004;

        begin
            $display("Test Case 004: Division (100 / 4)");
            reset_dut();
            A = 8'sd100;
            B = 8'sd4;
            op = 2'b11;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'sd25, 1'b1);
        end
        endtask

    task testcase005;

        begin
            $display("Test Case 005: Maximum 8-bit Addition (127 + 127)");
            reset_dut();
            A = 8'sb01111111;
            B = 8'sb01111111;
            op = 2'b00;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'sd254, 1'b1);
        end
        endtask

    task testcase006;

        begin
            $display("Test Case 006: Multiplication (-128 * -2)");
            reset_dut();
            A = -8'sd128;
            B = -8'sd2;
            op = 2'b10;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'sd256, 1'b1);
        end
        endtask

    task testcase007;

        begin
            $display("Test Case 007: Subtraction (-50 - -20)");
            reset_dut();
            A = -8'sd50;
            B = -8'sd20;
            op = 2'b01;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'sd(-30), 1'b1);
        end
        endtask

    task testcase008;

        begin
            $display("Test Case 008: Division (-80 / 8)");
            reset_dut();
            A = -8'sd80;
            B = 8'sd8;
            op = 2'b11;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'sd(-10), 1'b1);
        end
        endtask

    task testcase009;

        begin
            $display("Test Case 009: Reset Verification");
            reset = 1;
            A = 8'sd50;
            B = 8'sd50;
            op = 2'b00;
            @(posedge clk);
            #1;

            #1;


            check_outputs(16'd0, 1'b0);
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
        input [15:0] expected_result;
        input expected_valid;
        begin
            if (expected_result === (expected_result ^ result ^ expected_result) &&
                expected_valid === (expected_valid ^ valid ^ expected_valid)) begin
                $display("PASS");
                $display("  Outputs: result=%h, valid=%b",
                         result, valid);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: result=%h, valid=%b",
                         expected_result, expected_valid);
                $display("  Got:      result=%h, valid=%b",
                         result, valid);
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
        $dumpvars(0,A, B, clk, op, reset, result, valid);
    end

endmodule
