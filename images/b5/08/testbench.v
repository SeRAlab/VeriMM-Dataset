`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [31:0] op1;
    reg [31:0] op2;
    wire carry_out;
    wire [31:0] result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .op1(op1),
        .op2(op2),
        .carry_out(carry_out),
        .result(result)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        op1 = 32'h0;
        op2 = 32'h0;
        @(posedge clk);
        #1;
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Basic Addition", test_num);
        reset_dut();
        op1 = 32'd15;
        op2 = 32'd30;
        @(posedge clk);
        #1;
        #1;

        check_outputs(1'b0, 32'd45);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Maximum Carry-Out (FF...F + 1)", test_num);
        reset_dut();
        op1 = 32'hFFFF_FFFF;
        op2 = 32'h0000_0001;
        @(posedge clk);
        #1;
        #1;

        check_outputs(1'b1, 32'h0000_0000);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Zero + Zero", test_num);
        reset_dut();
        op1 = 32'h0;
        op2 = 32'h0;
        @(posedge clk);
        #1;
        #1;

        check_outputs(1'b0, 32'h0);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Carry-Out from MSB Addition", test_num);
        reset_dut();
        op1 = 32'h8000_0000;
        op2 = 32'h8000_0000;
        @(posedge clk);
        #1;
        #1;

        check_outputs(1'b1, 32'h0000_0000);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: No Carry-Out with Large Sum", test_num);
        reset_dut();
        op1 = 32'h7FFF_FFFF;
        op2 = 32'h0000_0001;
        @(posedge clk);
        #1;
        #1;

        check_outputs(1'b0, 32'h8000_0000);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Alternating Bits", test_num);
        reset_dut();
        op1 = 32'hAAAA_AAAA;
        op2 = 32'h5555_5555;
        @(posedge clk);
        #1;
        #1;

        check_outputs(1'b0, 32'hFFFF_FFFF);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Max Input Addition (FFFF... + FFFF...)", test_num);
        reset_dut();
        op1 = 32'hFFFF_FFFF;
        op2 = 32'hFFFF_FFFF;
        @(posedge clk);
        #1;
        #1;

        check_outputs(1'b1, 32'hFFFF_FFFE);
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
        input expected_carry_out;
        input [31:0] expected_result;
        begin
            if (expected_carry_out === (expected_carry_out ^ carry_out ^ expected_carry_out) &&
                expected_result === (expected_result ^ result ^ expected_result)) begin
                $display("PASS");
                $display("  Outputs: carry_out=%b, result=%h",
                         carry_out, result);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: carry_out=%b, result=%h",
                         expected_carry_out, expected_result);
                $display("  Got:      carry_out=%b, result=%h",
                         carry_out, result);
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
        $dumpvars(0,clk, op1, op2, carry_out, result);
    end

endmodule
