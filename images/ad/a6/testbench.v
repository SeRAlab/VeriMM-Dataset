`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] A;
    reg [3:0] B;
    reg clk;
    reg reset;
    wire [4:0] C;
    wire overflow;

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
        .C(C),
        .overflow(overflow)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            A = 0;
            B = 0;
            @(posedge clk);
            #1;
            reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            $display("Testcase 001: 2 + 3 = 5 (No Overflow)");
            A = 4'sb0010;
            B = 4'sb0011;
            @(posedge clk);
            #2;
            #1;

            check_outputs(5'sb00101, 1'b0);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            $display("Testcase 002: -2 + -3 = -5 (No Overflow)");
            A = 4'sb1110;
            B = 4'sb1101;
            @(posedge clk);
            #2;
            #1;

            check_outputs(5'sb11011, 1'b0);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            $display("Testcase 003: 5 + 4 = 9 (Positive Overflow)");
            A = 4'sb0101;
            B = 4'sb0100;
            @(posedge clk);
            #2;
            #1;

            check_outputs(5'sb01001, 1'b1);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            $display("Testcase 004: -5 + -6 = -11 (Negative Overflow)");
            A = 4'sb1011;
            B = 4'sb1010;
            @(posedge clk);
            #2;
            #1;

            check_outputs(5'sb10101, 1'b1);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            $display("Testcase 005: 7 + 1 = 8 (Positive Overflow edge case)");
            A = 4'sb0111;
            B = 4'sb0001;
            @(posedge clk);
            #2;
            #1;

            check_outputs(5'sb01000, 1'b1);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            $display("Testcase 006: -8 + -1 = -9 (Negative Overflow edge case)");
            A = 4'sb1000;
            B = 4'sb1111;
            @(posedge clk);
            #2;
            #1;

            check_outputs(5'sb10111, 1'b1);
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            $display("Testcase 007: 7 + (-8) = -1 (Mixed signs, No Overflow)");
            A = 4'sb0111;
            B = 4'sb1000;
            @(posedge clk);
            #2;
            #1;

            check_outputs(5'sb11111, 1'b0);
        end
        endtask

    task testcase008;

        begin
            reset_dut();
            $display("Testcase 008: -8 + -8 = -16 (Minimum values, Overflow)");
            A = 4'sb1000;
            B = 4'sb1000;
            @(posedge clk);
            #2;
            #1;

            check_outputs(5'sb10000, 1'b1);
        end
        endtask

    task testcase009;

        begin
            reset_dut();
            $display("Testcase 009: 0 + 0 = 0 (Zero case)");
            A = 4'sb0000;
            B = 4'sb0000;
            @(posedge clk);
            #2;
            #1;

            check_outputs(5'sb00000, 1'b0);
        end
        endtask

    task testcase010;

        begin
            reset_dut();
            $display("Testcase 010: 7 + 7 = 14 (Maximum positive, Overflow)");
            A = 4'sb0111;
            B = 4'sb0111;
            @(posedge clk);
            #2;
            #1;

            check_outputs(5'sb01110, 1'b1);
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
        input [4:0] expected_C;
        input expected_overflow;
        begin
            if (expected_C === (expected_C ^ C ^ expected_C) &&
                expected_overflow === (expected_overflow ^ overflow ^ expected_overflow)) begin
                $display("PASS");
                $display("  Outputs: C=%h, overflow=%b",
                         C, overflow);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: C=%h, overflow=%b",
                         expected_C, expected_overflow);
                $display("  Got:      C=%h, overflow=%b",
                         C, overflow);
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
        $dumpvars(0,A, B, clk, reset, C, overflow);
    end

endmodule
