`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] KEY_IN;
    reg clk;
    reg [1:0] operator;
    reg reset_n;
    wire [3:0] A;
    wire [3:0] B;
    wire sign_result;
    wire [3:0] value_result_tens;
    wire [3:0] value_result_units;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .KEY_IN(KEY_IN),
        .clk(clk),
        .operator(operator),
        .reset_n(reset_n),
        .A(A),
        .B(B),
        .sign_result(sign_result),
        .value_result_tens(value_result_tens),
        .value_result_units(value_result_units)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset_n = 0;
            KEY_IN = 4'd0;
            operator = 2'b00;
            repeat(2) @(posedge clk);
            #1 reset_n = 1;
            repeat(2) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Simple Addition (5 + 4 = 09)", test_num);
            reset_dut();
            operator = 2'b00;


            KEY_IN = 4'd5;
            @(posedge clk);
            #1;


            KEY_IN = 4'd4;
            @(posedge clk);
            #2;

            #1;


            check_outputs(4'd5, 4'd4, 1'b0, 4'd0, 4'd9);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Addition with Tens Carry (8 + 7 = 15)", test_num);
            reset_dut();
            operator = 2'b00;


            KEY_IN = 4'd8;
            @(posedge clk);
            #1;


            KEY_IN = 4'd7;
            @(posedge clk);
            #2;

            #1;


            check_outputs(4'd8, 4'd7, 1'b0, 4'd1, 4'd5);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Max Value Addition (15 + 15 = 30)", test_num);
            reset_dut();
            operator = 2'b00;


            KEY_IN = 4'd15;
            @(posedge clk);
            #1;


            KEY_IN = 4'd15;
            @(posedge clk);
            #2;

            #1;


            check_outputs(4'd15, 4'd15, 1'b0, 4'd3, 4'd0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Positive Subtraction (12 - 4 = 08)", test_num);
            reset_dut();
            operator = 2'b01;


            KEY_IN = 4'd12;
            @(posedge clk);
            #1;


            KEY_IN = 4'd4;
            @(posedge clk);
            #2;

            #1;


            check_outputs(4'd12, 4'd4, 1'b0, 4'd0, 4'd8);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Negative Subtraction (3 - 9 = -06)", test_num);
            reset_dut();
            operator = 2'b01;


            KEY_IN = 4'd3;
            @(posedge clk);
            #1;


            KEY_IN = 4'd9;
            @(posedge clk);
            #2;

            #1;


            check_outputs(4'd3, 4'd9, 1'b1, 4'd0, 4'd6);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Zero Result (10 - 10 = 00)", test_num);
            reset_dut();
            operator = 2'b01;


            KEY_IN = 4'd10;
            @(posedge clk);
            #1;


            KEY_IN = 4'd10;
            @(posedge clk);
            #2;

            #1;


            check_outputs(4'd10, 4'd10, 1'b0, 4'd0, 4'd0);
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
        input [3:0] expected_A;
        input [3:0] expected_B;
        input expected_sign_result;
        input [3:0] expected_value_result_tens;
        input [3:0] expected_value_result_units;
        begin
            if (expected_A === (expected_A ^ A ^ expected_A) &&
                expected_B === (expected_B ^ B ^ expected_B) &&
                expected_sign_result === (expected_sign_result ^ sign_result ^ expected_sign_result) &&
                expected_value_result_tens === (expected_value_result_tens ^ value_result_tens ^ expected_value_result_tens) &&
                expected_value_result_units === (expected_value_result_units ^ value_result_units ^ expected_value_result_units)) begin
                $display("PASS");
                $display("  Outputs: A=%h, B=%h, sign_result=%b, value_result_tens=%h, value_result_units=%h",
                         A, B, sign_result, value_result_tens, value_result_units);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: A=%h, B=%h, sign_result=%b, value_result_tens=%h, value_result_units=%h",
                         expected_A, expected_B, expected_sign_result, expected_value_result_tens, expected_value_result_units);
                $display("  Got:      A=%h, B=%h, sign_result=%b, value_result_tens=%h, value_result_units=%h",
                         A, B, sign_result, value_result_tens, value_result_units);
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
        $dumpvars(0,KEY_IN, clk, operator, reset_n, A, B, sign_result, value_result_tens, value_result_units);
    end

endmodule
