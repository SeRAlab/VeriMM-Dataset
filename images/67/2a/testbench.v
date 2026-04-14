`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] num1;
    reg [7:0] num2;
    reg [1:0] op;
    reg rst;
    wire [7:0] result;
    wire valid;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .num1(num1),
        .num2(num2),
        .op(op),
        .rst(rst),
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
            rst = 1;
            num1 = 0;
            num2 = 0;
            op = 0;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            $display("Testcase 001: Addition (15 + 25)");
            num1 = 8'd15;
            num2 = 8'd25;
            op = 2'b00;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'd40, 1'b1);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            $display("Testcase 002: Subtraction (100 - 30)");
            num1 = 8'd100;
            num2 = 8'd30;
            op = 2'b01;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'd70, 1'b1);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            $display("Testcase 003: Multiplication (12 * 10)");
            num1 = 8'd12;
            num2 = 8'd10;
            op = 2'b10;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'd120, 1'b1);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            $display("Testcase 004: Division (100 / 4)");
            num1 = 8'd100;
            num2 = 8'd4;
            op = 2'b11;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'd25, 1'b1);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            $display("Testcase 005: Addition Overflow (200 + 100)");
            num1 = 8'd200;
            num2 = 8'd100;
            op = 2'b00;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'd44, 1'b1);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = 6;
            $display("Testcase 006: Subtraction Underflow (10 - 20)");
            num1 = 8'd10;
            num2 = 8'd20;
            op = 2'b01;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'd246, 1'b1);
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            test_num = 7;
            $display("Testcase 007: Multiplication Overflow (50 * 10)");
            num1 = 8'd50;
            num2 = 8'd10;
            op = 2'b10;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'd244, 1'b1);
        end
        endtask

    task testcase008;

        begin
            reset_dut();
            test_num = 8;
            $display("Testcase 008: Division Truncation (10 / 3)");
            num1 = 8'd10;
            num2 = 8'd3;
            op = 2'b11;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'd3, 1'b1);
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
        input [7:0] expected_result;
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
        $dumpvars(0,clk, num1, num2, op, rst, result, valid);
    end

endmodule
