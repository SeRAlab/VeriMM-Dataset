`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] a;
    reg [7:0] b;
    reg clk;
    reg [1:0] op;
    reg rst_n;
    wire [7:0] result;
    wire valid;

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
        .rst_n(rst_n),
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
            rst_n = 0;
            a = 0;
            b = 0;
            op = 0;
            repeat(2) @(posedge clk);
            #1 rst_n = 1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Addition (10 + 20)", test_num);
            reset_dut();
            a = 8'd10;
            b = 8'd20;
            op = 2'b00;
            @(posedge clk);
            #1 #1;
 check_outputs(8'd30, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Subtraction (50 - 15)", test_num);
            reset_dut();
            a = 8'd50;
            b = 8'd15;
            op = 2'b01;
            @(posedge clk);
            #1 #1;
 check_outputs(8'd35, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Multiplication (12 * 4)", test_num);
            reset_dut();
            a = 8'd12;
            b = 8'd4;
            op = 2'b10;
            @(posedge clk);
            #1 #1;
 check_outputs(8'd48, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Division (100 / 5)", test_num);
            reset_dut();
            a = 8'd100;
            b = 8'd5;
            op = 2'b11;
            @(posedge clk);
            #1 #1;
 check_outputs(8'd20, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Addition Overflow (250 + 10)", test_num);
            reset_dut();
            a = 8'd250;
            b = 8'd10;
            op = 2'b00;
            @(posedge clk);
            #1 #1;
 check_outputs(8'd4, 1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Subtraction Underflow (5 - 10)", test_num);
            reset_dut();
            a = 8'd5;
            b = 8'd10;
            op = 2'b01;
            @(posedge clk);
            #1 #1;
 check_outputs(8'd251, 1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Multiplication wrap-around (64 * 4)", test_num);
            reset_dut();
            a = 8'd64;
            b = 8'd4;
            op = 2'b10;
            @(posedge clk);
            #1 #1;
 check_outputs(8'd0, 1'b1);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Division Zero result (3 / 5)", test_num);
            reset_dut();
            a = 8'd3;
            b = 8'd5;
            op = 2'b11;
            @(posedge clk);
            #1 #1;
 check_outputs(8'd0, 1'b1);
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
        $dumpvars(0,a, b, clk, op, rst_n, result, valid);
    end

endmodule
