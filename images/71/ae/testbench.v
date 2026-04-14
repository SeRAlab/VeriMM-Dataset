`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] a;
    reg [7:0] b;
    reg clk;
    reg [1:0] op;
    reg rst;
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
            a = 0;
            b = 0;
            op = 0;
            @(posedge clk);
            #1;
            rst = 0;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            a = 8'sd10;
            b = 8'sd20;
            op = 2'b00;
            @(posedge clk);
            #1;
            $display("Test 001: Addition 10 + 20");
            #1;

            check_outputs(8'sd30);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            a = 8'sd50;
            b = 8'sd70;
            op = 2'b01;
            @(posedge clk);
            #1;
            $display("Test 002: Subtraction 50 - 70");
            #1;

            check_outputs(-8'sd20);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            a = 8'sd4;
            b = 8'sd12;
            op = 2'b10;
            @(posedge clk);
            #1;
            $display("Test 003: Multiplication 4 * 12");
            #1;

            check_outputs(8'sd48);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            a = 8'sd100;
            b = 8'sd4;
            op = 2'b11;
            @(posedge clk);
            #1;
            $display("Test 004: Division 100 / 4");
            #1;

            check_outputs(8'sd25);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            a = 8'sd55;
            b = 8'sd0;
            op = 2'b11;
            @(posedge clk);
            #1;
            $display("Test 005: Division by Zero (55 / 0)");
            #1;

            check_outputs(8'sd0);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            a = -8'sd5;
            b = 8'sd6;
            op = 2'b10;
            @(posedge clk);
            #1;
            $display("Test 006: Negative Multiplication -5 * 6");
            #1;

            check_outputs(-8'sd30);
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            a = 8'sd0;
            b = 8'sd127;
            op = 2'b01;
            @(posedge clk);
            #1;
            $display("Test 007: Subtraction 0 - 127");
            #1;

            check_outputs(-8'sd127);
        end
        endtask

    task testcase008;

        begin
            reset_dut();
            a = -8'sd10;
            b = -8'sd15;
            op = 2'b00;
            @(posedge clk);
            #1;
            $display("Test 008: Negative Addition -10 + -15");
            #1;

            check_outputs(-8'sd25);
        end
        endtask

    task testcase009;

        begin
            reset_dut();
            a = -8'sd20;
            b = -8'sd5;
            op = 2'b11;
            @(posedge clk);
            #1;
            $display("Test 009: Negative Division -20 / -5");
            #1;

            check_outputs(8'sd4);
        end
        endtask

    task testcase010;

        begin
            reset_dut();
            a = 8'sd50;
            b = 8'sd50;
            op = 2'b00;
            rst = 1;
            @(posedge clk);
            #1;
            $display("Test 010: Reset behavior during active inputs");
            #1;

            check_outputs(8'sd0);
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
        $dumpvars(0,a, b, clk, op, rst, result);
    end

endmodule
