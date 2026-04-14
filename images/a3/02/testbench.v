`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] A;
    reg [3:0] B;
    reg clk;
    reg clr;
    reg sub;
    wire [3:0] Y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .clk(clk),
        .clr(clr),
        .sub(sub),
        .Y(Y)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            clr = 1;
            A = 0;
            B = 0;
            sub = 0;
            @(posedge clk);
            #1;
            clr = 0;
        end
        endtask
    task wait_cycles;

        input integer n;
        begin
            repeat(n) @(posedge clk);
            #1;
        end
        endtask

    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            A = 4'd5;
            B = 4'd3;
            sub = 0;
            wait_cycles(1);
            $display("Testcase 001: Basic Addition (5 + 3)");
            #1;

            check_outputs(4'd8);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            A = 4'd10;
            B = 4'd4;
            sub = 1;
            wait_cycles(1);
            $display("Testcase 002: Basic Subtraction (10 - 4)");
            #1;

            check_outputs(4'd6);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            A = 4'd7;
            B = 4'd2;
            sub = 0;
            clr = 1;
            wait_cycles(1);
            $display("Testcase 003: Synchronous Clear (A=7, B=2, clr=1)");
            #1;

            check_outputs(4'd0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            A = 4'd12;
            B = 4'd5;
            sub = 0;
            wait_cycles(1);
            $display("Testcase 004: Addition Overflow (12 + 5 = 17 mod 16)");
            #1;

            check_outputs(4'd1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            A = 4'd3;
            B = 4'd7;
            sub = 1;
            wait_cycles(1);
            $display("Testcase 005: Subtraction Underflow (3 - 7 = -4)");
            #1;

            check_outputs(4'hC);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();
            A = 4'hF;
            B = 4'hF;
            sub = 0;
            wait_cycles(1);
            $display("Testcase 006: Max Addition (15 + 15)");
            #1;

            check_outputs(4'hE);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            reset_dut();
            A = 4'd8;
            B = 4'd8;
            sub = 1;
            wait_cycles(1);
            $display("Testcase 007: Subtraction to Zero (8 - 8)");
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
        input [3:0] expected_Y;
        begin
            if (expected_Y === (expected_Y ^ Y ^ expected_Y)) begin
                $display("PASS");
                $display("  Outputs: Y=%h",
                         Y);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Y=%h",
                         expected_Y);
                $display("  Got:      Y=%h",
                         Y);
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
        $dumpvars(0,A, B, clk, clr, sub, Y);
    end

endmodule
