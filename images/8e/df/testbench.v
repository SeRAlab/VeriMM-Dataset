`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] A;
    reg [3:0] B;
    reg clk;
    reg reset;
    reg sub;
    wire [3:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .clk(clk),
        .reset(reset),
        .sub(sub),
        .out(out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            A = 0;
            B = 0;
            sub = 0;
            reset = 0;
            @(posedge clk);
            #1;
            reset = 1;
        end
        endtask
    task testcase001;

        begin
            $display("Testcase 001: Simple Addition (5 + 3)");
            reset_dut();
            A = 4'd5;
            B = 4'd3;
            sub = 1'b0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'd8);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Simple Subtraction (10 - 4)");
            reset_dut();
            A = 4'd10;
            B = 4'd4;
            sub = 1'b1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'd6);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Addition with Overflow (12 + 7)");
            reset_dut();
            A = 4'd12;
            B = 4'd7;
            sub = 1'b0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'd3);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Subtraction with Underflow (3 - 5)");
            reset_dut();
            A = 4'd3;
            B = 4'd5;
            sub = 1'b1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'd14);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Addition of Zero (0 + 0)");
            reset_dut();
            A = 4'd0;
            B = 4'd0;
            sub = 1'b0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'd0);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: Subtraction resulting in Zero (15 - 15)");
            reset_dut();
            A = 4'd15;
            B = 4'd15;
            sub = 1'b1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'd0);
        end
        endtask

    task testcase007;

        begin
            $display("Testcase 007: Max Addition (15 + 15)");
            reset_dut();
            A = 4'd15;
            B = 4'd15;
            sub = 1'b0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'd14);
        end
        endtask

    task testcase008;

        begin
            $display("Testcase 008: Sub Max from Min (0 - 15)");
            reset_dut();
            A = 4'd0;
            B = 4'd15;
            sub = 1'b1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'd1);
        end
        endtask

    task testcase009;

        begin
            $display("Testcase 009: Reset during calculation");
            reset_dut();
            A = 4'd10;
            B = 4'd10;
            sub = 1'b0;
            reset = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'd0);
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
        input [3:0] expected_out;
        begin
            if (expected_out === (expected_out ^ out ^ expected_out)) begin
                $display("PASS");
                $display("  Outputs: out=%h",
                         out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out=%h",
                         expected_out);
                $display("  Got:      out=%h",
                         out);
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
        $dumpvars(0,A, B, clk, reset, sub, out);
    end

endmodule
