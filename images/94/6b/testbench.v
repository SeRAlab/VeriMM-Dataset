`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] a;
    reg [3:0] b;
    reg clk;
    reg [1:0] op;
    reg rst_n;
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
        .op(op),
        .rst_n(rst_n),
        .result(result)
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
            @(posedge clk);
            #1 rst_n = 1;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Addition (5 + 3)", test_num);
            reset_dut();
            a = 4'd5;
            b = 4'd3;
            op = 2'b00;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'd8);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Subtraction (10 - 4)", test_num);
            reset_dut();
            a = 4'd10;
            b = 4'd4;
            op = 2'b01;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'd6);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Multiplication (4 * 3)", test_num);
            reset_dut();
            a = 4'd4;
            b = 4'd3;
            op = 2'b10;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'd12);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Division (12 / 4)", test_num);
            reset_dut();
            a = 4'd12;
            b = 4'd4;
            op = 2'b11;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'd3);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Max Addition (15 + 15)", test_num);
            reset_dut();
            a = 4'd15;
            b = 4'd15;
            op = 2'b00;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'd30);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Max Multiplication (15 * 15)", test_num);
            reset_dut();
            a = 4'd15;
            b = 4'd15;
            op = 2'b10;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'd225);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Division Remainder (10 / 3)", test_num);
            reset_dut();
            a = 4'd10;
            b = 4'd3;
            op = 2'b11;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'd3);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Reset verification", test_num);
            reset_dut();
            a = 4'd10;
            b = 4'd10;
            op = 2'b00;
            @(posedge clk);
            #1;
            rst_n = 0;
            @(posedge clk);
            #1;
            #1;

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
        $dumpvars(0,a, b, clk, op, rst_n, result);
    end

endmodule
