`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [1:0] op;
    reg [7:0] operand_a;
    reg [7:0] operand_b;
    reg rst;
    wire [7:0] result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .op(op),
        .operand_a(operand_a),
        .operand_b(operand_b),
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
            op = 0;
            operand_a = 0;
            operand_b = 0;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Basic Addition", test_num);
            op = 2'b00;
            operand_a = 8'd10;
            operand_b = 8'd20;
            @(posedge clk);
            #1 #1;
 check_outputs(8'd30);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Addition Overflow", test_num);
            op = 2'b00;
            operand_a = 8'd200;
            operand_b = 8'd100;
            @(posedge clk);
            #1 #1;
 check_outputs(8'd44);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Basic Subtraction", test_num);
            op = 2'b01;
            operand_a = 8'd50;
            operand_b = 8'd15;
            @(posedge clk);
            #1 #1;
 check_outputs(8'd35);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Subtraction Underflow", test_num);
            op = 2'b01;
            operand_a = 8'd10;
            operand_b = 8'd20;
            @(posedge clk);
            #1 #1;
 check_outputs(8'd246);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Basic Multiplication", test_num);
            op = 2'b10;
            operand_a = 8'd12;
            operand_b = 8'd10;
            @(posedge clk);
            #1 #1;
 check_outputs(8'd120);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Multiplication Overflow", test_num);
            op = 2'b10;
            operand_a = 8'd20;
            operand_b = 8'd20;
            @(posedge clk);
            #1 #1;
 check_outputs(8'd144);
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Basic Division", test_num);
            op = 2'b11;
            operand_a = 8'd100;
            operand_b = 8'd4;
            @(posedge clk);
            #1 #1;
 check_outputs(8'd25);
        end
        endtask

    task testcase008;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Division Truncation", test_num);
            op = 2'b11;
            operand_a = 8'd7;
            operand_b = 8'd2;
            @(posedge clk);
            #1 #1;
 check_outputs(8'd3);
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
        input [7:0] expected_result;
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
        $dumpvars(0,clk, op, operand_a, operand_b, rst, result);
    end

endmodule
