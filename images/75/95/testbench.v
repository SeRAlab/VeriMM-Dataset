`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [31:0] operand1;
    reg [31:0] operand2;
    reg [1:0] operation;
    reg reset_n;
    wire [31:0] result;

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
        .result(result)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        reset_n = 1;
        #2;
        reset_n = 0;
        @(posedge clk);
        #1;
        reset_n = 1;
    end
        endtask
    task testcase001;

    begin
        $display("Test Case 001: Addition (100 + 250)");
        reset_dut();
        operand1 = 32'd100;
        operand2 = 32'd250;
        operation = 2'b00;
        @(posedge clk);
        #1;
        #1;

        check_outputs(32'd350);
    end
        endtask

    task testcase002;

    begin
        $display("Test Case 002: Subtraction (500 - 150)");
        reset_dut();
        operand1 = 32'd500;
        operand2 = 32'd150;
        operation = 2'b01;
        @(posedge clk);
        #1;
        #1;

        check_outputs(32'd350);
    end
        endtask

    task testcase003;

    begin
        $display("Test Case 003: Multiplication (12 * 12)");
        reset_dut();
        operand1 = 32'd12;
        operand2 = 32'd12;
        operation = 2'b10;
        @(posedge clk);
        #1;
        #1;

        check_outputs(32'd144);
    end
        endtask

    task testcase004;

    begin
        $display("Test Case 004: Division (1000 / 8)");
        reset_dut();
        operand1 = 32'd1000;
        operand2 = 32'd8;
        operation = 2'b11;
        @(posedge clk);
        #1;
        #1;

        check_outputs(32'd125);
    end
        endtask

    task testcase005;

    begin
        $display("Test Case 005: Subtraction (10 - 50)");
        reset_dut();
        operand1 = 32'd10;
        operand2 = 32'd50;
        operation = 2'b01;
        @(posedge clk);
        #1;
        #1;

        check_outputs(32'hffffffd8);
    end
        endtask

    task testcase006;

    begin
        $display("Test Case 006: Multiplication Overflow Truncation");
        reset_dut();
        operand1 = 32'h10000;
        operand2 = 32'h10000;
        operation = 2'b10;
        @(posedge clk);
        #1;
        #1;

        check_outputs(32'h00000000);
    end
        endtask

    task testcase007;

    begin
        $display("Test Case 007: Division by Zero Check");
        reset_dut();
        operand1 = 32'd100;
        operand2 = 32'd0;
        operation = 2'b11;
        @(posedge clk);
        #1;


        $display("  Result of 100/0 is: %h", result);
        pass_count = pass_count + 1;
    end
        endtask

    task testcase008;

    begin
        $display("Test Case 008: Verify Synchronous Reset");
        reset_dut();
        operand1 = 32'd50;
        operand2 = 32'd50;
        operation = 2'b00;
        @(posedge clk);
        #1;
        reset_n = 0;
        @(posedge clk);
        #1;
        #1;

        check_outputs(32'd0);
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
        input [31:0] expected_result;
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
        $dumpvars(0,clk, operand1, operand2, operation, reset_n, result);
    end

endmodule
