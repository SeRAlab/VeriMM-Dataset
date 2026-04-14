`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [1:0] op;
    reg [7:0] operand1;
    reg [7:0] operand2;
    reg reset;
    wire overflow;
    wire [7:0] result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .op(op),
        .operand1(operand1),
        .operand2(operand2),
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
            op = 0;
            operand1 = 0;
            operand2 = 0;
            @(posedge clk);
            #1;
            reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

    begin
        reset_dut();
        test_num = test_num + 1;
        op = 2'b00; operand1 = 8'd10; operand2 = 8'd20;
        @(posedge clk);
        #1;
        $display("Test %0d: Addition (10 + 20)", test_num);
        #1;

        check_outputs(1'b0, 8'd30);
    end
        endtask

    task testcase002;

    begin
        reset_dut();
        test_num = test_num + 1;
        op = 2'b00; operand1 = 8'd200; operand2 = 8'd100;
        @(posedge clk);
        #1;
        $display("Test %0d: Addition Overflow (200 + 100)", test_num);
        #1;

        check_outputs(1'b1, 8'd44);
    end
        endtask

    task testcase003;

    begin
        reset_dut();
        test_num = test_num + 1;
        op = 2'b01; operand1 = 8'd50; operand2 = 8'd20;
        @(posedge clk);
        #1;
        $display("Test %0d: Subtraction (50 - 20)", test_num);
        #1;

        check_outputs(1'b0, 8'd30);
    end
        endtask

    task testcase004;

    begin
        reset_dut();
        test_num = test_num + 1;
        op = 2'b01; operand1 = 8'd10; operand2 = 8'd20;
        @(posedge clk);
        #1;
        $display("Test %0d: Subtraction Underflow (10 - 20)", test_num);
        #1;

        check_outputs(1'b1, 8'd246);
    end
        endtask

    task testcase005;

    begin
        reset_dut();
        test_num = test_num + 1;
        op = 2'b10; operand1 = 8'd12; operand2 = 8'd5;
        @(posedge clk);
        #1;
        $display("Test %0d: Multiplication (12 * 5)", test_num);
        #1;

        check_outputs(1'b0, 8'd60);
    end
        endtask

    task testcase006;

    begin
        reset_dut();
        test_num = test_num + 1;
        op = 2'b10; operand1 = 8'd40; operand2 = 8'd10;
        @(posedge clk);
        #1;
        $display("Test %0d: Multiplication Overflow (40 * 10)", test_num);
        #1;

        check_outputs(1'b1, 8'd144);
    end
        endtask

    task testcase007;

    begin
        reset_dut();
        test_num = test_num + 1;
        op = 2'b11; operand1 = 8'd100; operand2 = 8'd4;
        @(posedge clk);
        #1;
        $display("Test %0d: Division (100 / 4)", test_num);
        #1;

        check_outputs(1'b0, 8'd25);
    end
        endtask

    task testcase008;

    begin
        reset_dut();
        test_num = test_num + 1;
        op = 2'b11; operand1 = 8'd50; operand2 = 8'd0;
        @(posedge clk);
        #1;
        $display("Test %0d: Division by Zero (50 / 0)", test_num);
        #1;

        check_outputs(1'b1, result);
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
        input [7:0] expected_result;
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
        $dumpvars(0,clk, op, operand1, operand2, reset, overflow, result);
    end

endmodule
