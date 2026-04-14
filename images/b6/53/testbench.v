`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] A;
    reg [3:0] B;
    reg clk;
    reg [2:0] op;
    wire [3:0] result;
    wire valid;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .clk(clk),
        .op(op),
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
        A = 0;
        B = 0;
        op = 0;
        @(posedge clk);
        #1;
    end
        endtask
    task testcase001;

    begin
        reset_dut();
        test_num = 1;
        $display("Testcase %0d: Addition (3 + 5)", test_num);
        A = 4'd3;
        B = 4'd5;
        op = 3'b000;
        @(posedge clk);
        #1;
        #1;

        check_outputs(4'd8, 1'b1);
    end
        endtask

    task testcase002;

    begin
        reset_dut();
        test_num = 2;
        $display("Testcase %0d: Subtraction (10 - 4)", test_num);
        A = 4'd10;
        B = 4'd4;
        op = 3'b001;
        @(posedge clk);
        #1;
        #1;

        check_outputs(4'd6, 1'b1);
    end
        endtask

    task testcase003;

    begin
        reset_dut();
        test_num = 3;
        $display("Testcase %0d: Bitwise AND (4'b1100 & 4'b1010)", test_num);
        A = 4'b1100;
        B = 4'b1010;
        op = 3'b010;
        @(posedge clk);
        #1;
        #1;

        check_outputs(4'b1000, 1'b1);
    end
        endtask

    task testcase004;

    begin
        reset_dut();
        test_num = 4;
        $display("Testcase %0d: Bitwise OR (4'b1100 | 4'b1010)", test_num);
        A = 4'b1100;
        B = 4'b1010;
        op = 3'b011;
        @(posedge clk);
        #1;
        #1;

        check_outputs(4'b1110, 1'b1);
    end
        endtask

    task testcase005;

    begin
        reset_dut();
        test_num = 5;
        $display("Testcase %0d: Bitwise XOR (4'b1100 ^ 4'b1010)", test_num);
        A = 4'b1100;
        B = 4'b1010;
        op = 3'b100;
        @(posedge clk);
        #1;
        #1;

        check_outputs(4'b0110, 1'b1);
    end
        endtask

    task testcase006;

    begin
        reset_dut();
        test_num = 6;
        $display("Testcase %0d: Addition Overflow (15 + 1)", test_num);
        A = 4'd15;
        B = 4'd1;
        op = 3'b000;
        @(posedge clk);
        #1;
        #1;

        check_outputs(4'd0, 1'b1);
    end
        endtask

    task testcase007;

    begin
        reset_dut();
        test_num = 7;
        $display("Testcase %0d: Subtraction Underflow (0 - 1)", test_num);
        A = 4'd0;
        B = 4'd1;
        op = 3'b001;
        @(posedge clk);
        #1;
        #1;

        check_outputs(4'd15, 1'b1);
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
        $dumpvars(0,A, B, clk, op, result, valid);
    end

endmodule
