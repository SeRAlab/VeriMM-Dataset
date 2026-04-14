`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] A;
    reg [7:0] B;
    reg clk;
    reg [1:0] op_sel;
    reg rst;
    wire [7:0] diff;
    wire [7:0] prod;
    wire [7:0] quot;
    wire [7:0] sum;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .clk(clk),
        .op_sel(op_sel),
        .rst(rst),
        .diff(diff),
        .prod(prod),
        .quot(quot),
        .sum(sum)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            A = 0;
            B = 0;
            op_sel = 0;
            @(posedge clk);
            #1;
            rst = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Basic arithmetic operations (A=15, B=3)", test_num);
            reset_dut();
            A = 8'd15;
            B = 8'd3;
            op_sel = 2'b00;
            @(posedge clk);
            #1;

            #1;


            check_outputs(8'd12, 8'd45, 8'd5, 8'd18);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Multiplication Clamping (A=50, B=10)", test_num);
            reset_dut();
            A = 8'd50;
            B = 8'd10;
            op_sel = 2'b00;
            @(posedge clk);
            #1;

            #1;


            check_outputs(8'd40, 8'd255, 8'd5, 8'd60);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Division by zero (A=100, B=0)", test_num);
            reset_dut();
            A = 8'd100;
            B = 8'd0;
            op_sel = 2'b00;
            @(posedge clk);
            #1;

            #1;


            check_outputs(8'd100, 8'd0, 8'd0, 8'd100);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Subtraction Wrap-around (A=10, B=20)", test_num);
            reset_dut();
            A = 8'd10;
            B = 8'd20;
            op_sel = 2'b00;
            @(posedge clk);
            #1;

            #1;


            check_outputs(8'd246, 8'd200, 8'd0, 8'd30);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Addition Wrap-around (A=200, B=100)", test_num);
            reset_dut();
            A = 8'd200;
            B = 8'd100;
            op_sel = 2'b00;
            @(posedge clk);
            #1;

            #1;


            check_outputs(8'd100, 8'd255, 8'd2, 8'd44);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Verify Reset functionality", test_num);

            reset_dut();
            A = 8'd10; B = 8'd10;
            @(posedge clk);
            #1;

            rst = 1;
            @(posedge clk);
            #1;

            #1;


            check_outputs(8'd0, 8'd0, 8'd0, 8'd0);
            rst = 0;
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
        input [7:0] expected_diff;
        input [7:0] expected_prod;
        input [7:0] expected_quot;
        input [7:0] expected_sum;
        begin
            if (expected_diff === (expected_diff ^ diff ^ expected_diff) &&
                expected_prod === (expected_prod ^ prod ^ expected_prod) &&
                expected_quot === (expected_quot ^ quot ^ expected_quot) &&
                expected_sum === (expected_sum ^ sum ^ expected_sum)) begin
                $display("PASS");
                $display("  Outputs: diff=%h, prod=%h, quot=%h, sum=%h",
                         diff, prod, quot, sum);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: diff=%h, prod=%h, quot=%h, sum=%h",
                         expected_diff, expected_prod, expected_quot, expected_sum);
                $display("  Got:      diff=%h, prod=%h, quot=%h, sum=%h",
                         diff, prod, quot, sum);
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
        $dumpvars(0,A, B, clk, op_sel, rst, diff, prod, quot, sum);
    end

endmodule
