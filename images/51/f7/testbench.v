`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] A;
    reg [7:0] B;
    reg [1:0] opcode;
    wire [7:0] result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .opcode(opcode),
        .result(result)
    );
    task testcase001;

        begin
            test_num = 1;
            A = 8'd15;
            B = 8'd25;
            opcode = 2'b00;
            $display("Test Case 001: Addition (15 + 25)");
            #1;

            check_outputs(8'd40);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            A = 8'hF0;
            B = 8'h20;
            opcode = 2'b00;
            $display("Test Case 002: Addition Overflow (240 + 32 = 272 -> 16)");
            #1;

            check_outputs(8'h10);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            A = 8'd50;
            B = 8'd20;
            opcode = 2'b01;
            $display("Test Case 003: Subtraction (50 - 20)");
            #1;

            check_outputs(8'd30);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            A = 8'd10;
            B = 8'd20;
            opcode = 2'b01;
            $display("Test Case 004: Subtraction Underflow (10 - 20 = -10 -> 246)");
            #1;

            check_outputs(8'd246);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            A = 8'd12;
            B = 8'd5;
            opcode = 2'b10;
            $display("Test Case 005: Multiplication (12 * 5)");
            #1;

            check_outputs(8'd60);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            A = 8'd40;
            B = 8'd10;
            opcode = 2'b10;
            $display("Test Case 006: Multiplication Overflow (40 * 10 = 400 -> 144)");
            #1;

            check_outputs(8'd144);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            A = 8'd100;
            B = 8'd4;
            opcode = 2'b11;
            $display("Test Case 007: Division (100 / 4)");
            #1;

            check_outputs(8'd25);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            A = 8'd7;
            B = 8'd2;
            opcode = 2'b11;
            $display("Test Case 008: Division Floor (7 / 2)");
            #1;

            check_outputs(8'd3);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            A = 8'd55;
            B = 8'd0;
            opcode = 2'b11;
            $display("Test Case 009: Division by Zero (55 / 0)");
            #1;

            check_outputs(8'hFF);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            A = 8'd0;
            B = 8'd0;
            opcode = 2'b00;
            $display("Test Case 010: Addition (0 + 0)");
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
            #1; // Small delay for combinational logic to settle
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

endmodule
