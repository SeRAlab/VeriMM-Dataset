`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] a;
    reg [3:0] b;
    reg clk;
    reg [1:0] op;
    reg reset;
    wire [3:0] result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .clk(clk),
        .op(op),
        .reset(reset),
        .result(result)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            a = 0;
            b = 0;
            op = 0;
            @(posedge clk);
            #1 reset = 0;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            a = 4'd5;
            b = 4'd3;
            op = 2'b00;
            @(posedge clk);
            #2;
            $display("Test Case 001: Addition (5 + 3)");
            #1;

            check_outputs(4'd8);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            a = 4'd12;
            b = 4'd7;
            op = 2'b00;
            @(posedge clk);
            #2;
            $display("Test Case 002: Addition with Overflow (12 + 7 = 19, result should be 3)");
            #1;

            check_outputs(4'd3);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            a = 4'd10;
            b = 4'd4;
            op = 2'b01;
            @(posedge clk);
            #2;
            $display("Test Case 003: Subtraction (10 - 4)");
            #1;

            check_outputs(4'd6);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            a = 4'd2;
            b = 4'd5;
            op = 2'b01;
            @(posedge clk);
            #2;
            $display("Test Case 004: Subtraction Underflow (2 - 5 = -3, result should be 13)");
            #1;

            check_outputs(4'd13);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            a = 4'b1101;
            b = 4'b1011;
            op = 2'b10;
            @(posedge clk);
            #2;
            $display("Test Case 005: Bitwise AND (1101 & 1011)");
            #1;

            check_outputs(4'b1001);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            a = 4'hF;
            b = 4'hF;
            op = 2'b11;
            @(posedge clk);
            #2;
            $display("Test Case 006: Default Case (op = 11, result should be 0)");
            #1;

            check_outputs(4'd0);
        end
        endtask

    task testcase007;

        begin

            a = 4'hA; b = 4'h2; op = 2'b00;
            @(posedge clk);
            #2;

            reset = 1;
            @(posedge clk);
            #2;
            $display("Test Case 007: Reset Verification");
            #1;

            check_outputs(4'd0);
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
        input [3:0] expected_result;
        begin
            if (expected_result === (expected_result ^ result ^ expected_result)) begin
                $display("PASS");
                $display("  Outputs: result=%h",
                         result);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: result=%h",
                         expected_result);
                $display("  Got:      result=%h",
                         result);
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
        $dumpvars(0,a, b, clk, op, reset, result);
    end

endmodule
