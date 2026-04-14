`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg nrst;
    reg [7:0] num1;
    reg [7:0] num2;
    reg [1:0] op_code;
    wire [7:0] result;
    wire valid;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .nrst(nrst),
        .num1(num1),
        .num2(num2),
        .op_code(op_code),
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
        nrst = 0;
        num1 = 0;
        num2 = 0;
        op_code = 0;
        @(posedge clk);
        #1;
        nrst = 1;
    end
        endtask
    task testcase001;

    begin
        reset_dut();
        test_num = 1;
        num1 = 8'd15;
        num2 = 8'd25;
        op_code = 2'b00;
        @(posedge clk);
        #2;
        #1;

        check_outputs(8'd40, 1'b1);
    end
        endtask

    task testcase002;

    begin
        reset_dut();
        test_num = 2;
        num1 = 8'd50;
        num2 = 8'd20;
        op_code = 2'b01;
        @(posedge clk);
        #2;
        #1;

        check_outputs(8'd30, 1'b1);
    end
        endtask

    task testcase003;

    begin
        reset_dut();
        test_num = 3;
        num1 = 8'd12;
        num2 = 8'd5;
        op_code = 2'b10;
        @(posedge clk);
        #2;
        #1;

        check_outputs(8'd60, 1'b1);
    end
        endtask

    task testcase004;

    begin
        reset_dut();
        test_num = 4;
        num1 = 8'd100;
        num2 = 8'd4;
        op_code = 2'b11;
        @(posedge clk);
        #2;
        #1;

        check_outputs(8'd25, 1'b1);
    end
        endtask

    task testcase005;

    begin
        reset_dut();
        test_num = 5;
        num1 = 8'd55;
        num2 = 8'd0;
        op_code = 2'b11;
        @(posedge clk);
        #2;
        #1;

        check_outputs(8'd0, 1'b0);
    end
        endtask

    task testcase006;

    begin
        reset_dut();
        test_num = 6;
        num1 = 8'd200;
        num2 = 8'd100;
        op_code = 2'b00;
        @(posedge clk);
        #2;
        #1;

        check_outputs(8'd44, 1'b1);
    end
        endtask

    task testcase007;

    begin
        reset_dut();
        test_num = 7;
        num1 = 8'd10;
        num2 = 8'd20;
        op_code = 2'b01;
        @(posedge clk);
        #2;
        #1;

        check_outputs(8'd246, 1'b1);
    end
        endtask

    task testcase008;

    begin
        reset_dut();
        test_num = 8;
        num1 = 8'd40;
        num2 = 8'd10;
        op_code = 2'b10;
        @(posedge clk);
        #2;
        #1;

        check_outputs(8'd144, 1'b1);
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
        $dumpvars(0,clk, nrst, num1, num2, op_code, result, valid);
    end

endmodule
