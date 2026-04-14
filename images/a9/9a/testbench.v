`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] num1;
    reg [7:0] num2;
    reg [1:0] op;
    reg rst;
    wire [15:0] result;

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
            num1 = 0;
            num2 = 0;
            op = 0;
            @(posedge clk);
            #1;
            rst = 0;

            if (result !== 16'h0) begin
                $display("Reset Failure: result not zero");
            end
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("\nTestcase %0d: Addition (10 + 20)", test_num);
            reset_dut();
            num1 = 8'd10;
            num2 = 8'd20;
            op = 2'b00;
            @(posedge clk);
            #2;
            #1;

            check_outputs(16'd30);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTestcase %0d: Subtraction (50 - 20)", test_num);
            reset_dut();
            num1 = 8'd50;
            num2 = 8'd20;
            op = 2'b01;
            @(posedge clk);
            #2;
            #1;

            check_outputs(16'd30);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTestcase %0d: Subtraction with negative result (20 - 50)", test_num);
            reset_dut();
            num1 = 8'd20;
            num2 = 8'd50;
            op = 2'b01;
            @(posedge clk);
            #2;

            #1;


            check_outputs(16'hFFE2);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTestcase %0d: Multiplication (15 * 10)", test_num);
            reset_dut();
            num1 = 8'd15;
            num2 = 8'd10;
            op = 2'b10;
            @(posedge clk);
            #2;
            #1;

            check_outputs(16'd150);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nTestcase %0d: Multiplication Max (255 * 255)", test_num);
            reset_dut();
            num1 = 8'hFF;
            num2 = 8'hFF;
            op = 2'b10;
            @(posedge clk);
            #2;

            #1;


            check_outputs(16'hFE01);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("\nTestcase %0d: Division (100 / 4)", test_num);
            reset_dut();
            num1 = 8'd100;
            num2 = 8'd4;
            op = 2'b11;
            @(posedge clk);
            #2;
            #1;

            check_outputs(16'd25);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("\nTestcase %0d: Division with remainder (10 / 3)", test_num);
            reset_dut();
            num1 = 8'd10;
            num2 = 8'd3;
            op = 2'b11;
            @(posedge clk);
            #2;

            #1;


            check_outputs(16'd3);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("\nTestcase %0d: Addition near 8-bit limit (200 + 100)", test_num);
            reset_dut();
            num1 = 8'd200;
            num2 = 8'd100;
            op = 2'b00;
            @(posedge clk);
            #2;

            #1;


            check_outputs(16'd300);
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
        input [15:0] expected_result;
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
        $dumpvars(0,clk, num1, num2, op, rst, result);
    end

endmodule
