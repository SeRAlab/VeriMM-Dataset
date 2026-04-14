`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] A;
    reg [7:0] B;
    reg [1:0] CTRL;
    reg clk;
    reg rst;
    wire [7:0] C;
    wire VALID;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .CTRL(CTRL),
        .clk(clk),
        .rst(rst),
        .C(C),
        .VALID(VALID)
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
            CTRL = 0;
            @(posedge clk);
            #1;
            rst = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("Testcase 001: Addition (10 + 20)");
            reset_dut();
            A = 8'd10;
            B = 8'd20;
            CTRL = 2'b00;
            @(posedge clk);
            #2;
            #1;

            check_outputs(8'd30, 1'b1);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Subtraction (50 - 15)");
            reset_dut();
            A = 8'd50;
            B = 8'd15;
            CTRL = 2'b01;
            @(posedge clk);
            #2;
            #1;

            check_outputs(8'd35, 1'b1);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Multiplication (12 * 5)");
            reset_dut();
            A = 8'd12;
            B = 8'd5;
            CTRL = 2'b10;
            @(posedge clk);
            #2;
            #1;

            check_outputs(8'd60, 1'b1);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Division (100 / 4)");
            reset_dut();
            A = 8'd100;
            B = 8'd4;
            CTRL = 2'b11;
            @(posedge clk);
            #2;
            #1;

            check_outputs(8'd25, 1'b1);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Addition Overflow (200 + 100)");
            reset_dut();
            A = 8'd200;
            B = 8'd100;
            CTRL = 2'b00;
            @(posedge clk);
            #2;
            #1;

            check_outputs(8'd44, 1'b1);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: Subtraction Underflow (10 - 20)");
            reset_dut();
            A = 8'd10;
            B = 8'd20;
            CTRL = 2'b01;
            @(posedge clk);
            #2;
            #1;

            check_outputs(8'hF6, 1'b1);
        end
        endtask

    task testcase007;

        begin
            $display("Testcase 007: Multiplication Truncation (50 * 10)");
            reset_dut();
            A = 8'd50;
            B = 8'd10;
            CTRL = 2'b10;
            @(posedge clk);
            #2;
            #1;

            check_outputs(8'hF4, 1'b1);
        end
        endtask

    task testcase008;

        begin
            $display("Testcase 008: Division Integer Truncation (7 / 2)");
            reset_dut();
            A = 8'd7;
            B = 8'd2;
            CTRL = 2'b11;
            @(posedge clk);
            #2;
            #1;

            check_outputs(8'd3, 1'b1);
        end
        endtask

    task testcase009;

        begin
            $display("Testcase 009: Reset State");
            rst = 1;
            A = 8'hFF;
            B = 8'hFF;
            CTRL = 2'b00;
            @(posedge clk);
            #2;

            if (VALID === 1'b0) begin
                $display("PASS: VALID is low during reset");
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL: VALID should be low during reset");
                fail_count = fail_count + 1;
            end
            rst = 0;
        end
        endtask

    task testcase010;

        begin
            $display("Testcase 010: Division by Zero (Safety check)");
            reset_dut();
            A = 8'd10;
            B = 8'd0;
            CTRL = 2'b11;
            @(posedge clk);
            #2;


            if (VALID === 1'b1) begin
                $display("PASS: Operation flagged as VALID");
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL: Operation not flagged VALID");
                fail_count = fail_count + 1;
            end
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
        input [7:0] expected_C;
        input expected_VALID;
        begin
            if (expected_C === (expected_C ^ C ^ expected_C) &&
                expected_VALID === (expected_VALID ^ VALID ^ expected_VALID)) begin
                $display("PASS");
                $display("  Outputs: C=%h, VALID=%b",
                         C, VALID);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: C=%h, VALID=%b",
                         expected_C, expected_VALID);
                $display("  Got:      C=%h, VALID=%b",
                         C, VALID);
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
        $dumpvars(0,A, B, CTRL, clk, rst, C, VALID);
    end

endmodule
