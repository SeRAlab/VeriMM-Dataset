`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] operand1;
    reg [3:0] operand2;
    reg operation;
    reg reset;
    wire overflow;
    wire [3:0] result;

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
        .reset(reset),
        .overflow(overflow),
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
        operand1 = 0;
        operand2 = 0;
        operation = 0;
        @(posedge clk);
        #1 reset = 0;
        @(posedge clk);
    end
        endtask
    task testcase001;

    begin
        $display("Running testcase001: Basic Addition (5 + 3)");
        reset_dut();
        operand1 = 4'd5;
        operand2 = 4'd3;
        operation = 1'b0;
        @(posedge clk);
        #1 #1;
 check_outputs(1'b0, 4'd8);
    end
        endtask

    task testcase002;

    begin
        $display("Running testcase002: Addition with Overflow (12 + 5)");
        reset_dut();
        operand1 = 4'd12;
        operand2 = 4'd5;
        operation = 1'b0;
        @(posedge clk);
        #1 #1;
 check_outputs(1'b1, 4'd1);
    end
        endtask

    task testcase003;

    begin
        $display("Running testcase003: Boundary Addition (8 + 7)");
        reset_dut();
        operand1 = 4'd8;
        operand2 = 4'd7;
        operation = 1'b0;
        @(posedge clk);
        #1 #1;
 check_outputs(1'b0, 4'd15);
    end
        endtask

    task testcase004;

    begin
        $display("Running testcase004: Basic Subtraction (10 - 4)");
        reset_dut();
        operand1 = 4'd10;
        operand2 = 4'd4;
        operation = 1'b1;
        @(posedge clk);
        #1 #1;
 check_outputs(1'b0, 4'd6);
    end
        endtask

    task testcase005;

    begin
        $display("Running testcase005: Subtraction Underflow (3 - 5)");
        reset_dut();
        operand1 = 4'd3;
        operand2 = 4'd5;
        operation = 1'b1;
        @(posedge clk);
        #1 #1;
 check_outputs(1'b1, 4'd14);
    end
        endtask

    task testcase006;

    begin
        $display("Running testcase006: Subtraction Boundary (7 - 7)");
        reset_dut();
        operand1 = 4'd7;
        operand2 = 4'd7;
        operation = 1'b1;
        @(posedge clk);
        #1 #1;
 check_outputs(1'b0, 4'd0);
    end
        endtask

    task testcase007;

    begin
        $display("Running testcase007: Max Addition (15 + 15)");
        reset_dut();
        operand1 = 4'd15;
        operand2 = 4'd15;
        operation = 1'b0;
        @(posedge clk);
        #1 #1;
 check_outputs(1'b1, 4'd14);
    end
        endtask

    task testcase008;

    begin
        $display("Running testcase008: Subtraction from Zero (0 - 1)");
        reset_dut();
        operand1 = 4'd0;
        operand2 = 4'd1;
        operation = 1'b1;
        @(posedge clk);
        #1 #1;
 check_outputs(1'b1, 4'd15);
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
        input expected_overflow;
        input [3:0] expected_result;
        begin
            if (expected_overflow === (expected_overflow ^ overflow ^ expected_overflow) &&
                expected_result === (expected_result ^ result ^ expected_result)) begin
                $display("PASS");
                $display("  Outputs: overflow=%b, result=%h",
                         overflow, result);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: overflow=%b, result=%h",
                         expected_overflow, expected_result);
                $display("  Got:      overflow=%b, result=%h",
                         overflow, result);
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
        $dumpvars(0,clk, operand1, operand2, operation, reset, overflow, result);
    end

endmodule
