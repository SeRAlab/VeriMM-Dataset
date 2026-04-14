`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [15:0] operand1;
    reg [15:0] operand2;
    reg [3:0] operation;
    reg rst;
    wire [15:0] result;

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
        .rst(rst),
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
            operand1 = 0;
            operand2 = 0;
            operation = 0;
            @(posedge clk);
            #1 rst = 0;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Addition (10 + 20)", test_num);
            operand1 = 16'd10;
            operand2 = 16'd20;
            operation = 4'd0;
            @(posedge clk);
            #1 #1;
 check_outputs(16'd30);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Subtraction (50 - 15)", test_num);
            operand1 = 16'd50;
            operand2 = 16'd15;
            operation = 4'd1;
            @(posedge clk);
            #1 #1;
 check_outputs(16'd35);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Multiplication (12 * 12)", test_num);
            operand1 = 16'd12;
            operand2 = 16'd12;
            operation = 4'd2;
            @(posedge clk);
            #1 #1;
 check_outputs(16'd144);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Division (100 / 4)", test_num);
            operand1 = 16'd100;
            operand2 = 16'd4;
            operation = 4'd3;
            @(posedge clk);
            #1 #1;
 check_outputs(16'd25);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Addition Overflow (0xFFFF + 1)", test_num);
            operand1 = 16'hFFFF;
            operand2 = 16'h0001;
            operation = 4'd0;
            @(posedge clk);
            #1 #1;
 check_outputs(16'h0000);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Subtraction Underflow (5 - 10)", test_num);
            operand1 = 16'd5;
            operand2 = 16'd10;
            operation = 4'd1;
            @(posedge clk);
            #1 #1;
 check_outputs(16'hFFF0 + 16'h000B);
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
        input [15:0] expected_result;
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
        $dumpvars(0,clk, operand1, operand2, operation, rst, result);
    end

endmodule
