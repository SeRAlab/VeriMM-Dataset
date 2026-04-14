`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg clk;
    reg [3:0] num1;
    reg [3:0] num2;
    reg [1:0] op;
    reg rst;
    wire overflow;
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
        .overflow(overflow),
        .result(result)
    );
    task pulse_clk;

        begin
            #5 clk = 1;
            #5 clk = 0;
        end
        endtask

    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Addition (5 + 3 = 8)", test_num);

        rst = 1; clk = 0; num1 = 0; num2 = 0; op = 0;
        pulse_clk();
        rst = 0;

        num1 = 4'd5; num2 = 4'd3; op = 2'b00;
        pulse_clk();
        #1;

        check_outputs(1'b0, 4'd8);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Addition Overflow (10 + 7 = 17 -> 1)", test_num);
        rst = 1;
        pulse_clk();
        rst = 0;

        num1 = 4'd10; num2 = 4'd7; op = 2'b00;
        pulse_clk();
        #1;

        check_outputs(1'b1, 4'd1);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Subtraction (12 - 4 = 8)", test_num);
        rst = 1;
        pulse_clk();
        rst = 0;
        num1 = 4'd12; num2 = 4'd4; op = 2'b01;
        pulse_clk();
        #1;

        check_outputs(1'b0, 4'd8);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Subtraction Underflow (3 - 5)", test_num);
        rst = 1;
        pulse_clk();
        rst = 0;

        num1 = 4'd3; num2 = 4'd5; op = 2'b01;
        pulse_clk();
        #1;

        check_outputs(1'b1, 4'd14);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Multiplication (3 * 4 = 12)", test_num);
        rst = 1;
        pulse_clk();
        rst = 0;
        num1 = 4'd3; num2 = 4'd4; op = 2'b10;
        pulse_clk();
        #1;

        check_outputs(1'b0, 4'd12);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Multiplication Overflow (8 * 3 = 24 -> 8)", test_num);
        rst = 1;
        pulse_clk();
        rst = 0;

        num1 = 4'd8; num2 = 4'd3; op = 2'b10;
        pulse_clk();
        #1;

        check_outputs(1'b1, 4'd8);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Division (15 / 3 = 5)", test_num);
        rst = 1;
        pulse_clk();
        rst = 0;
        num1 = 4'd15; num2 = 4'd3; op = 2'b11;
        pulse_clk();
        #1;

        check_outputs(1'b0, 4'd5);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Division (2 / 5 = 0)", test_num);
        rst = 1;
        pulse_clk();
        rst = 0;
        num1 = 4'd2; num2 = 4'd5; op = 2'b11;
        pulse_clk();
        #1;

        check_outputs(1'b0, 4'd0);
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
            #1; // Small delay for combinational logic to settle
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

endmodule
