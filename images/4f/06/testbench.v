`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clear;
    reg clk;
    reg [7:0] num1;
    reg [7:0] num2;
    reg [1:0] op;
    reg rst;
    wire [7:0] result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clear(clear),
        .clk(clk),
        .num1(num1),
        .num2(num2),
        .op(op),
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
            clear = 0;
            num1 = 0;
            num2 = 0;
            op = 0;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test %0d: Basic Addition (12 + 34)", test_num);
            num1 = 8'd12;
            num2 = 8'd34;
            op = 2'b00;
            @(posedge clk);
            #1 #1;
 check_outputs(8'd46);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test %0d: Basic Subtraction (50 - 20)", test_num);
            num1 = 8'd50;
            num2 = 8'd20;
            op = 2'b01;
            @(posedge clk);
            #1 #1;
 check_outputs(8'd30);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test %0d: Basic Multiplication (10 * 5)", test_num);
            num1 = 8'd10;
            num2 = 8'd5;
            op = 2'b10;
            @(posedge clk);
            #1 #1;
 check_outputs(8'd50);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test %0d: Basic Division (80 / 4)", test_num);
            num1 = 8'd80;
            num2 = 8'd4;
            op = 2'b11;
            @(posedge clk);
            #1 #1;
 check_outputs(8'd20);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test %0d: Clear Signal (Clear should force 0)", test_num);
            num1 = 8'd100;
            num2 = 8'd100;
            op = 2'b00;
            clear = 1;
            @(posedge clk);
            #1 #1;
 check_outputs(8'd0);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test %0d: Addition Overflow (200 + 100 = 300 -> 44)", test_num);
            num1 = 8'd200;
            num2 = 8'd100;
            op = 2'b00;
            @(posedge clk);
            #1 #1;
 check_outputs(8'd44);
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test %0d: Subtraction Underflow (5 - 10 = -5 -> 251)", test_num);
            num1 = 8'd5;
            num2 = 8'd10;
            op = 2'b01;
            @(posedge clk);
            #1 #1;
 check_outputs(8'd251);
        end
        endtask

    task testcase008;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test %0d: Multiplication Wrap (16 * 16 = 256 -> 0)", test_num);
            num1 = 8'd16;
            num2 = 8'd16;
            op = 2'b10;
            @(posedge clk);
            #1 #1;
 check_outputs(8'd0);
        end
        endtask

    task testcase009;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test %0d: Integer Division (50 / 7 = 7)", test_num);
            num1 = 8'd50;
            num2 = 8'd7;
            op = 2'b11;
            @(posedge clk);
            #1 #1;
 check_outputs(8'd7);
        end
        endtask

    task testcase010;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test %0d: Synchronous Reset", test_num);
            num1 = 8'd25;
            num2 = 8'd25;
            op = 2'b00;
            rst = 1;
            @(posedge clk);
            #1 #1;
 check_outputs(8'd0);
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
        $dumpvars(0,clear, clk, num1, num2, op, rst, result);
    end

endmodule
