`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] a;
    reg [3:0] b;
    reg clk;
    reg reset;
    wire carry;
    wire [2:0] count;
    wire [3:0] so;
    wire [3:0] sum;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .clk(clk),
        .reset(reset),
        .carry(carry),
        .count(count),
        .so(so),
        .sum(sum)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        reset = 1;
        a = 4'b0;
        b = 4'b0;
        @(posedge clk);
        #1;
        reset = 0;
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: 4'd3 + 4'd4 = 7 (Carry=0)", test_num);
        reset_dut();
        a = 4'd3;
        b = 4'd4;

        repeat(4) @(posedge clk);
        #1;

        #1;


        check_outputs(1'b0, 3'd4, 4'd7, 4'd7);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: 4'd8 + 4'd8 = 0 (Carry=1)", test_num);
        reset_dut();
        a = 4'd8;
        b = 4'd8;
        repeat(4) @(posedge clk);
        #1;

        #1;


        check_outputs(1'b1, 3'd4, 4'd0, 4'd0);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: 4'd15 + 4'd15 = 14 (Carry=1)", test_num);
        reset_dut();
        a = 4'd15;
        b = 4'd15;
        repeat(4) @(posedge clk);
        #1;

        #1;


        check_outputs(1'b1, 3'd4, 4'd14, 4'd14);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: 4'd0 + 4'd0 = 0 (Carry=0)", test_num);
        reset_dut();
        a = 4'd0;
        b = 4'd0;
        repeat(4) @(posedge clk);
        #1;
        #1;

        check_outputs(1'b0, 3'd4, 4'd0, 4'd0);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: 4'd7 + 4'd1 = 8 (Carry=0)", test_num);
        reset_dut();
        a = 4'd7;
        b = 4'd1;
        repeat(4) @(posedge clk);
        #1;

        #1;


        check_outputs(1'b0, 3'd4, 4'd8, 4'd8);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: 4'd10 + 4'd5 = 15 (Carry=0)", test_num);
        reset_dut();
        a = 4'd10;
        b = 4'd5;
        repeat(4) @(posedge clk);
        #1;
        #1;

        check_outputs(1'b0, 3'd4, 4'd15, 4'd15);
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
        input expected_carry;
        input [2:0] expected_count;
        input [3:0] expected_so;
        input [3:0] expected_sum;
        begin
            if (expected_carry === (expected_carry ^ carry ^ expected_carry) &&
                expected_count === (expected_count ^ count ^ expected_count) &&
                expected_so === (expected_so ^ so ^ expected_so) &&
                expected_sum === (expected_sum ^ sum ^ expected_sum)) begin
                $display("PASS");
                $display("  Outputs: carry=%b, count=%h, so=%h, sum=%h",
                         carry, count, so, sum);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: carry=%b, count=%h, so=%h, sum=%h",
                         expected_carry, expected_count, expected_so, expected_sum);
                $display("  Got:      carry=%b, count=%h, so=%h, sum=%h",
                         carry, count, so, sum);
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
        $dumpvars(0,a, b, clk, reset, carry, count, so, sum);
    end

endmodule
