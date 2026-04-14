`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] a;
    reg [7:0] b;
    reg clk;
    reg en;
    reg op;
    reg rst;
    wire overflow;
    wire [7:0] result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .clk(clk),
        .en(en),
        .op(op),
        .rst(rst),
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
        rst = 1;
        en = 0;
        op = 0;
        a = 0;
        b = 0;
        @(posedge clk);
        #1 rst = 0;
        @(posedge clk);
    end
        endtask
    task testcase001;

    begin
        reset_dut();
        test_num = 1;
        $display("Test %0d: Simple Addition (10 + 20)", test_num);
        en = 1;
        op = 0;
        a = 8'd10;
        b = 8'd20;
        @(posedge clk);
        #1 #1;
 check_outputs(1'b0, 8'd30);
    end
        endtask

    task testcase002;

    begin
        reset_dut();
        test_num = 2;
        $display("Test %0d: Addition with Overflow (200 + 100)", test_num);
        en = 1;
        op = 0;
        a = 8'd200;
        b = 8'd100;
        @(posedge clk);
        #1 #1;
 check_outputs(1'b1, 8'd44);
    end
        endtask

    task testcase003;

    begin
        reset_dut();
        test_num = 3;
        $display("Test %0d: Simple Subtraction (50 - 20)", test_num);
        en = 1;
        op = 1;
        a = 8'd50;
        b = 8'd20;
        @(posedge clk);
        #1 #1;
 check_outputs(1'b0, 8'd30);
    end
        endtask

    task testcase004;

    begin
        reset_dut();
        test_num = 4;
        $display("Test %0d: Subtraction with Borrow (10 - 20)", test_num);
        en = 1;
        op = 1;
        a = 8'd10;
        b = 8'd20;
        @(posedge clk);
        #1 #1;
 check_outputs(1'b1, 8'd246);
    end
        endtask

    task testcase005;

    begin
        reset_dut();
        test_num = 5;
        $display("Test %0d: Enable functionality (en=0)", test_num);
        en = 0;
        op = 0;
        a = 8'd50;
        b = 8'd50;
        @(posedge clk);
        #1 #1;
 check_outputs(1'b0, 8'd0);
    end
        endtask

    task testcase006;

    begin
        reset_dut();
        test_num = 6;
        $display("Test %0d: Boundary Addition (255 + 1)", test_num);
        en = 1;
        op = 0;
        a = 8'hFF;
        b = 8'h01;
        @(posedge clk);
        #1 #1;
 check_outputs(1'b1, 8'h00);
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
        $dumpvars(0,a, b, clk, en, op, rst, overflow, result);
    end

endmodule
