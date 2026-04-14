`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] operand1;
    reg [7:0] operand2;
    reg [1:0] operation;
    reg reset_n;
    wire [7:0] result;
    wire valid;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .operand1(operand1),
        .operand2(operand2),
        .operation(operation),
        .reset_n(reset_n),
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
            reset_n = 0;
            operand1 = 0;
            operand2 = 0;
            operation = 0;
            @(posedge clk);
            #1;
            reset_n = 1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case %0d: Basic Addition (15 + 25)", test_num);
            reset_dut();
            operand1 = 8'd15;
            operand2 = 8'd25;
            operation = 2'b00;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'd40, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case %0d: Basic Subtraction (50 - 20)", test_num);
            reset_dut();
            operand1 = 8'd50;
            operand2 = 8'd20;
            operation = 2'b01;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'd30, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case %0d: Basic Multiplication (12 * 5)", test_num);
            reset_dut();
            operand1 = 8'd12;
            operand2 = 8'd5;
            operation = 2'b10;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'd60, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case %0d: Basic Division (100 / 4)", test_num);
            reset_dut();
            operand1 = 8'd100;
            operand2 = 8'd4;
            operation = 2'b11;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'd25, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case %0d: Addition Overflow (250 + 10)", test_num);
            reset_dut();
            operand1 = 8'd250;
            operand2 = 8'd10;
            operation = 2'b00;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'd4, 1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test Case %0d: Subtraction Underflow (5 - 10)", test_num);
            reset_dut();
            operand1 = 8'd5;
            operand2 = 8'd10;
            operation = 2'b01;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'd251, 1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test Case %0d: Multiplication Truncation (40 * 10)", test_num);
            reset_dut();
            operand1 = 8'd40;
            operand2 = 8'd10;
            operation = 2'b10;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'd144, 1'b1);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Test Case %0d: Verify Reset Behavior", test_num);
            reset_n = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'h00, 1'b0);
            reset_n = 1;
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
        $dumpvars(0,clk, operand1, operand2, operation, reset_n, result, valid);
    end

endmodule
