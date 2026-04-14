`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [15:0] operand1;
    reg [15:0] operand2;
    reg [1:0] operation;
    reg rst;
    wire overflow;
    wire [15:0] result;
    wire zero;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .operand1(operand1),
        .operand2(operand2),
        .operation(operation),
        .rst(rst),
        .overflow(overflow),
        .result(result),
        .zero(zero)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            operand1 = 0;
            operand2 = 0;
            operation = 0;
            @(posedge clk);
            #1;
            rst = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            operand1 = 16'sd500;
            operand2 = 16'sd250;
            operation = 2'b00;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0, 16'sd750, 1'b0);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            operand1 = 16'sd100;
            operand2 = -16'sd100;
            operation = 2'b00;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0, 16'sd0, 1'b1);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            operand1 = 16'sd30000;
            operand2 = 16'sd10000;
            operation = 2'b00;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1, 16'sd40000, 1'b0);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            operand1 = 16'sd1000;
            operand2 = 16'sd400;
            operation = 2'b01;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0, 16'sd600, 1'b0);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            operand1 = -16'sd20000;
            operand2 = 16'sd20000;
            operation = 2'b01;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1, -16'sd40000, 1'b0);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = 6;
            operand1 = 16'sd20;
            operand2 = -16'sd5;
            operation = 2'b10;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0, -16'sd100, 1'b0);
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            test_num = 7;
            operand1 = 16'sd200;
            operand2 = 16'sd200;
            operation = 2'b10;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1, 16'sd40000, 1'b0);
        end
        endtask

    task testcase008;

        begin
            reset_dut();
            test_num = 8;
            operand1 = 16'sd100;
            operand2 = 16'sd3;
            operation = 2'b11;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0, 16'sd33, 1'b0);
        end
        endtask

    task testcase009;

        begin
            reset_dut();
            test_num = 9;
            operand1 = 16'sd50;
            operand2 = 16'sd0;
            operation = 2'b11;
            @(posedge clk);
            #1;

            #1;


            check_outputs(1'b1, result, zero);
        end
        endtask

    task testcase010;

        begin
            reset_dut();
            test_num = 10;
            operand1 = 16'sd2;
            operand2 = 16'sd10;
            operation = 2'b11;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0, 16'sd0, 1'b1);
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
        input [15:0] expected_result;
        input expected_zero;
        begin
            if (expected_overflow === (expected_overflow ^ overflow ^ expected_overflow) &&
                expected_result === (expected_result ^ result ^ expected_result) &&
                expected_zero === (expected_zero ^ zero ^ expected_zero)) begin
                $display("PASS");
                $display("  Outputs: overflow=%b, result=%h, zero=%b",
                         overflow, result, zero);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: overflow=%b, result=%h, zero=%b",
                         expected_overflow, expected_result, expected_zero);
                $display("  Got:      overflow=%b, result=%h, zero=%b",
                         overflow, result, zero);
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
        $dumpvars(0,clk, operand1, operand2, operation, rst, overflow, result, zero);
    end

endmodule
