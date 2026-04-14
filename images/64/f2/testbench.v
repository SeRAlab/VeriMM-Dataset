`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] a;
    reg [3:0] b;
    reg clk;
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
        .a(a),
        .b(b),
        .clk(clk),
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
        a = 0;
        b = 0;
        op = 0;
        @(posedge clk);
        #1 rst = 0;
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Initial Reset Check", test_num);
        reset_dut();

        #1;


        check_outputs(1'b0, 4'b0000);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Simple Addition (3 + 4)", test_num);
        reset_dut();
        a = 4'sd3;
        b = 4'sd4;
        op = 2'b00;
        @(posedge clk);
        #1 #1;
 check_outputs(1'b0, 4'sd7);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Addition Positive Overflow (4 + 4)", test_num);
        reset_dut();
        a = 4'sd4;
        b = 4'sd4;
        op = 2'b00;
        @(posedge clk);
        #1 #1;
 check_outputs(1'b1, 4'b1000);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Simple Subtraction (5 - 2)", test_num);
        reset_dut();
        a = 4'sd5;
        b = 4'sd2;
        op = 2'b01;
        @(posedge clk);
        #1 #1;
 check_outputs(1'b0, 4'sd3);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Subtraction Negative Overflow (-5 - 4)", test_num);
        reset_dut();
        a = -4'sd5;
        b = 4'sd4;
        op = 2'b01;
        @(posedge clk);
        #1 #1;
 check_outputs(1'b1, 4'sd7);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Addition Negative Overflow (-5 + -4)", test_num);
        reset_dut();
        a = -4'sd5;
        b = -4'sd4;
        op = 2'b00;
        @(posedge clk);
        #1 #1;
 check_outputs(1'b1, 4'sd7);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Subtraction Positive Overflow (7 - -1)", test_num);
        reset_dut();
        a = 4'sd7;
        b = -4'sd1;
        op = 2'b01;
        @(posedge clk);
        #1 #1;
 check_outputs(1'b1, 4'b1000);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Boundary Addition (-8 + 7)", test_num);
        reset_dut();
        a = -4'sd8;
        b = 4'sd7;
        op = 2'b00;
        @(posedge clk);
        #1 #1;
 check_outputs(1'b0, -4'sd1);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Boundary Subtraction (-8 - 0)", test_num);
        reset_dut();
        a = -4'sd8;
        b = 4'sd0;
        op = 2'b01;
        @(posedge clk);
        #1 #1;
 check_outputs(1'b0, -4'sd8);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Zero Operation", test_num);
        reset_dut();
        a = 4'sd0;
        b = 4'sd0;
        op = 2'b00;
        @(posedge clk);
        #1 #1;
 check_outputs(1'b0, 4'sd0);
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
        testcase009();
        testcase010();
        
        
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
        $dumpvars(0,a, b, clk, op, rst, overflow, result);
    end

endmodule
