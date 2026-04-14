`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] num1;
    reg [7:0] num2;
    reg [1:0] opcode;
    wire [7:0] result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .num1(num1),
        .num2(num2),
        .opcode(opcode),
        .result(result)
    );
    task testcase001;

    begin
        test_num = 1;
        num1 = 8'd120;
        num2 = 8'd35;
        opcode = 2'b00;
        $display("Testcase %03d: Addition (120 + 35)", test_num);
        #1;

        check_outputs(8'd155);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        num1 = 8'd200;
        num2 = 8'd100;
        opcode = 2'b00;
        $display("Testcase %03d: Addition Overflow (200 + 100 = 300 mod 256)", test_num);
        #1;

        check_outputs(8'd44);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        num1 = 8'd150;
        num2 = 8'd50;
        opcode = 2'b01;
        $display("Testcase %03d: Subtraction (150 - 50)", test_num);
        #1;

        check_outputs(8'd100);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        num1 = 8'd20;
        num2 = 8'd30;
        opcode = 2'b01;
        $display("Testcase %03d: Subtraction Underflow (20 - 30 = -10 mod 256)", test_num);
        #1;

        check_outputs(8'd246);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        num1 = 8'd12;
        num2 = 8'd10;
        opcode = 2'b10;
        $display("Testcase %03d: Multiplication (12 * 10)", test_num);
        #1;

        check_outputs(8'd120);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        num1 = 8'd16;
        num2 = 8'd16;
        opcode = 2'b10;
        $display("Testcase %03d: Multiplication Overflow (16 * 16 = 256 mod 256)", test_num);
        #1;

        check_outputs(8'd0);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        num1 = 8'd100;
        num2 = 8'd4;
        opcode = 2'b11;
        $display("Testcase %03d: Division (100 / 4)", test_num);
        #1;

        check_outputs(8'd25);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        num1 = 8'd25;
        num2 = 8'd7;
        opcode = 2'b11;
        $display("Testcase %03d: Division with Remainder (25 / 7)", test_num);
        #1;

        check_outputs(8'd3);
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
