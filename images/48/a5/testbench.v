`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] a;
    reg [7:0] b;
    reg clk;
    reg [1:0] op;
    reg rst;
    reg start;
    wire done;
    wire [7:0] result;

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
        .rst(rst),
        .start(start),
        .done(done),
        .result(result)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            start = 0;
            a = 0;
            b = 0;
            op = 0;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            @(negedge clk);
            a = 8'd15;
            b = 8'd27;
            op = 2'b00;
            start = 1;
            @(posedge clk);
            #1 start = 0;
            $display("Testcase 001: Addition (15 + 27)");
            #1;

            check_outputs(1'b1, 8'd42);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            @(negedge clk);
            a = 8'd100;
            b = 8'd45;
            op = 2'b01;
            start = 1;
            @(posedge clk);
            #1 start = 0;
            $display("Testcase 002: Subtraction (100 - 45)");
            #1;

            check_outputs(1'b1, 8'd55);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            @(negedge clk);
            a = 8'd12;
            b = 8'd5;
            op = 2'b10;
            start = 1;
            @(posedge clk);
            #1 start = 0;
            $display("Testcase 003: Multiplication (12 * 5)");
            #1;

            check_outputs(1'b1, 8'd60);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            @(negedge clk);
            a = 8'd80;
            b = 8'd4;
            op = 2'b11;
            start = 1;
            @(posedge clk);
            #1 start = 0;
            $display("Testcase 004: Division (80 / 4)");
            #1;

            check_outputs(1'b1, 8'd20);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            @(negedge clk);
            a = 8'd200;
            b = 8'd100;
            op = 2'b00;
            start = 1;
            @(posedge clk);
            #1 start = 0;
            $display("Testcase 005: Addition Overflow (200 + 100)");
            #1;

            check_outputs(1'b1, 8'd44);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            @(negedge clk);
            a = 8'd10;
            b = 8'd20;
            op = 2'b01;
            start = 1;
            @(posedge clk);
            #1 start = 0;
            $display("Testcase 006: Subtraction Underflow (10 - 20)");
            #1;

            check_outputs(1'b1, 8'd246);
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            @(negedge clk);
            a = 8'd20;
            b = 8'd20;
            op = 2'b10;
            start = 1;
            @(posedge clk);
            #1 start = 0;
            $display("Testcase 007: Multiplication Overflow (20 * 20)");
            #1;

            check_outputs(1'b1, 8'd144);
        end
        endtask

    task testcase008;

        begin
            reset_dut();
            @(negedge clk);
            a = 8'd10;
            b = 8'd3;
            op = 2'b11;
            start = 1;
            @(posedge clk);
            #1 start = 0;
            $display("Testcase 008: Division Truncation (10 / 3)");
            #1;

            check_outputs(1'b1, 8'd3);
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
        input expected_done;
        input [7:0] expected_result;
        begin
            if (expected_done === (expected_done ^ done ^ expected_done) &&
                expected_result === (expected_result ^ result ^ expected_result)) begin
                $display("PASS");
                $display("  Outputs: done=%b, result=%h",
                         done, result);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: done=%b, result=%h",
                         expected_done, expected_result);
                $display("  Got:      done=%b, result=%h",
                         done, result);
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
        $dumpvars(0,a, b, clk, op, rst, start, done, result);
    end

endmodule
