`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] num1;
    reg [3:0] num2;
    reg [1:0] op;
    reg rst;
    wire [3:0] display;
    wire [3:0] result;

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
        .display(display),
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
            num1 = 0;
            num2 = 0;
            op = 0;
            @(posedge clk);
            #1 rst = 0;
            repeat(2) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            $display("Testcase %0d: Addition (5 + 3)", test_num);
            num1 = 4'd5;
            num2 = 4'd3;
            op   = 2'b00;
            repeat(5) @(posedge clk);
            #1;

            check_outputs(4'd8, 4'd8);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            $display("Testcase %0d: Subtraction (10 - 4)", test_num);
            num1 = 4'd10;
            num2 = 4'd4;
            op   = 2'b01;
            repeat(5) @(posedge clk);
            #1;

            check_outputs(4'd6, 4'd6);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            $display("Testcase %0d: Multiplication (3 * 4)", test_num);
            num1 = 4'd3;
            num2 = 4'd4;
            op   = 2'b10;
            repeat(5) @(posedge clk);
            #1;

            check_outputs(4'd12, 4'd12);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            $display("Testcase %0d: Division (12 / 3)", test_num);
            num1 = 4'd12;
            num2 = 4'd3;
            op   = 2'b11;
            repeat(5) @(posedge clk);
            #1;

            check_outputs(4'd4, 4'd4);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            $display("Testcase %0d: Addition Overflow (10 + 10)", test_num);
            num1 = 4'd10;
            num2 = 4'd10;
            op   = 2'b00;
            repeat(5) @(posedge clk);
            #1;

            check_outputs(4'd4, 4'd4);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = 6;
            $display("Testcase %0d: Subtraction Underflow (2 - 5)", test_num);
            num1 = 4'd2;
            num2 = 4'd5;
            op   = 2'b01;
            repeat(5) @(posedge clk);
            #1;

            check_outputs(4'd13, 4'd13);
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            test_num = 7;
            $display("Testcase %0d: Multiplication Truncation (5 * 4)", test_num);
            num1 = 4'd5;
            num2 = 4'd4;
            op   = 2'b10;
            repeat(5) @(posedge clk);
            #1;

            check_outputs(4'd4, 4'd4);
        end
        endtask

    task testcase008;

        begin
            reset_dut();
            test_num = 8;
            $display("Testcase %0d: Division Integer (7 / 2)", test_num);
            num1 = 4'd7;
            num2 = 4'd2;
            op   = 2'b11;
            repeat(5) @(posedge clk);
            #1;

            check_outputs(4'd3, 4'd3);
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
        input [3:0] expected_display;
        input [3:0] expected_result;
        begin
            if (expected_display === (expected_display ^ display ^ expected_display) &&
                expected_result === (expected_result ^ result ^ expected_result)) begin
                $display("PASS");
                $display("  Outputs: display=%h, result=%h",
                         display, result);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: display=%h, result=%h",
                         expected_display, expected_result);
                $display("  Got:      display=%h, result=%h",
                         display, result);
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
        $dumpvars(0,clk, num1, num2, op, rst, display, result);
    end

endmodule
