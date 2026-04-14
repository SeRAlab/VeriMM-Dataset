`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] A;
    reg [7:0] B;
    reg [1:0] OP;
    reg clk;
    wire [7:0] result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .OP(OP),
        .clk(clk),
        .result(result)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            A = 8'd0;
            B = 8'd0;
            OP = 2'b00;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            A = 8'd15;
            B = 8'd25;
            OP = 2'b00;
            @(posedge clk);
            #2;
            $display("Testcase 001: Addition (15 + 25)");
            #1;

            check_outputs(8'd40);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            A = 8'd200;
            B = 8'd100;
            OP = 2'b00;
            @(posedge clk);
            #2;
            $display("Testcase 002: Addition Overflow (200 + 100 = 300 -> 44)");
            #1;

            check_outputs(8'd44);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            A = 8'd50;
            B = 8'd20;
            OP = 2'b01;
            @(posedge clk);
            #2;
            $display("Testcase 003: Subtraction (50 - 20)");
            #1;

            check_outputs(8'd30);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            A = 8'd10;
            B = 8'd20;
            OP = 2'b01;
            @(posedge clk);
            #2;
            $display("Testcase 004: Subtraction Underflow (10 - 20 = -10 -> 0xF6)");
            #1;

            check_outputs(8'hF6);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            A = 8'd12;
            B = 8'd5;
            OP = 2'b10;
            @(posedge clk);
            #2;
            $display("Testcase 005: Multiplication (12 * 5)");
            #1;

            check_outputs(8'd60);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = 6;
            A = 8'd64;
            B = 8'd4;
            OP = 2'b10;
            @(posedge clk);
            #2;
            $display("Testcase 006: Multiplication Overflow (64 * 4 = 256 -> 0)");
            #1;

            check_outputs(8'd0);
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            test_num = 7;
            A = 8'd100;
            B = 8'd4;
            OP = 2'b11;
            @(posedge clk);
            #2;
            $display("Testcase 007: Division (100 / 4)");
            #1;

            check_outputs(8'd25);
        end
        endtask

    task testcase008;

        begin
            reset_dut();
            test_num = 8;
            A = 8'd255;
            B = 8'd0;
            OP = 2'b11;
            @(posedge clk);
            #2;
            $display("Testcase 008: Division by Zero (255 / 0)");
            #1;

            check_outputs(8'd0);
        end
        endtask

    task testcase009;

        begin
            reset_dut();
            test_num = 9;
            A = 8'd10;
            B = 8'd3;
            OP = 2'b11;
            @(posedge clk);
            #2;
            $display("Testcase 009: Division Truncation (10 / 3)");
            #1;

            check_outputs(8'd3);
        end
        endtask

    task testcase010;

        begin
            reset_dut();
            test_num = 10;
            A = 8'd0;
            B = 8'd128;
            OP = 2'b10;
            @(posedge clk);
            #2;
            $display("Testcase 010: Multiplied by Zero (0 * 128)");
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
        $dumpvars(0,A, B, OP, clk, result);
    end

endmodule
