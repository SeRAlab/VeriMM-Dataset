`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] A;
    reg [3:0] B;
    reg C0;
    reg C1;
    reg clk;
    reg reset;
    wire [3:0] result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .C0(C0),
        .C1(C1),
        .clk(clk),
        .reset(reset),
        .result(result)
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
            C0 = 0;
            C1 = 0;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            $display("Testcase 001: Checking Reset State");
            #1;

            check_outputs(4'h0);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            A = 4'd3; B = 4'd4; C1 = 0; C0 = 0;
            $display("Testcase 002: Addition (3 + 4)");
            @(posedge clk);
            #1 #1;
 check_outputs(4'd7);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            A = 4'd5; B = 4'd2; C1 = 0; C0 = 1;
            $display("Testcase 003: Addition with Carry (5 + 2 + 1)");
            @(posedge clk);
            #1 #1;
 check_outputs(4'd8);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            A = 4'd10; B = 4'd4; C1 = 1; C0 = 0;
            $display("Testcase 004: Subtraction (10 - 4)");
            @(posedge clk);
            #1 #1;
 check_outputs(4'd6);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            A = 4'd10; B = 4'd4; C1 = 1; C0 = 1;
            $display("Testcase 005: Subtraction with Borrow (10 - 4 - 1)");
            @(posedge clk);
            #1 #1;
 check_outputs(4'd5);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = 6;
            A = 4'd13; B = 4'd5; C1 = 0; C0 = 0;
            $display("Testcase 006: Addition Overflow (13 + 5)");
            @(posedge clk);
            #1 #1;
 check_outputs(4'd2);
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            test_num = 7;
            A = 4'd2; B = 4'd5; C1 = 1; C0 = 0;
            $display("Testcase 007: Subtraction Underflow (2 - 5)");
            @(posedge clk);
            #1 #1;
 check_outputs(4'd13);
        end
        endtask

    task testcase008;

        begin
            reset_dut();
            test_num = 8;
            A = 4'hF; B = 4'hF; C1 = 0; C0 = 1;
            $display("Testcase 008: Max addition with carry (15 + 15 + 1)");
            @(posedge clk);
            #1 #1;
 check_outputs(4'hF);
        end
        endtask

    task testcase009;

        begin
            reset_dut();
            test_num = 9;
            A = 4'd7; B = 4'd7; C1 = 1; C0 = 0;
            $display("Testcase 009: Subtraction Result Zero (7 - 7)");
            @(posedge clk);
            #1 #1;
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
        input [3:0] expected_result;
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
        $dumpvars(0,A, B, C0, C1, clk, reset, result);
    end

endmodule
