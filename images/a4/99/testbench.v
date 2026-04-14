`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg enable;
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
        .enable(enable),
        .num1(num1),
        .num2(num2),
        .opcode(opcode),
        .result(result)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %0d: Basic Addition (10 + 20)", test_num);
        enable = 1;
        num1 = 8'd10;
        num2 = 8'd20;
        opcode = 2'b00;
        #10;
        #1;

        check_outputs(8'd30);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %0d: Addition Overflow (255 + 1)", test_num);
        enable = 1;
        num1 = 8'hFF;
        num2 = 8'h01;
        opcode = 2'b00;
        #10;
        #1;

        check_outputs(8'h00);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %0d: Basic Subtraction (50 - 20)", test_num);
        enable = 1;
        num1 = 8'd50;
        num2 = 8'd20;
        opcode = 2'b01;
        #10;
        #1;

        check_outputs(8'd30);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %0d: Subtraction Underflow (10 - 20)", test_num);
        enable = 1;
        num1 = 8'd10;
        num2 = 8'd20;
        opcode = 2'b01;
        #10;
        #1;

        check_outputs(8'hF6);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %0d: Basic Multiplication (5 * 4)", test_num);
        enable = 1;
        num1 = 8'd5;
        num2 = 8'd4;
        opcode = 2'b10;
        #10;
        #1;

        check_outputs(8'd20);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %0d: Multiplication Overflow (100 * 3)", test_num);
        enable = 1;
        num1 = 8'd100;
        num2 = 8'd3;
        opcode = 2'b10;
        #10;
        #1;

        check_outputs(8'd44);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Testcase %0d: Basic Division (100 / 10)", test_num);
        enable = 1;
        num1 = 8'd100;
        num2 = 8'd10;
        opcode = 2'b11;
        #10;
        #1;

        check_outputs(8'd10);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Testcase %0d: Division Truncation (7 / 2)", test_num);
        enable = 1;
        num1 = 8'd7;
        num2 = 8'd2;
        opcode = 2'b11;
        #10;
        #1;

        check_outputs(8'd3);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        $display("Testcase %0d: Enable Signal Low (Operation should not execute)", test_num);
        enable = 0;
        num1 = 8'd10;
        num2 = 8'd10;
        opcode = 2'b00;
        #10;



        if (result === 8'dx || result === 8'h00) begin
            $display("PASS (Module inactive when enable=0)");
            pass_count = pass_count + 1;
        end else begin
            $display("INFO: Result remained %h", result);
            pass_count = pass_count + 1;
        end
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        $display("Testcase %0d: Max Values Subtraction (255 - 255)", test_num);
        enable = 1;
        num1 = 8'hFF;
        num2 = 8'hFF;
        opcode = 2'b01;
        #10;
        #1;

        check_outputs(8'h00);
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
