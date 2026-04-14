`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [2:0] opcode;
    reg [7:0] operand1;
    reg [7:0] operand2;
    wire [7:0] result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .opcode(opcode),
        .operand1(operand1),
        .operand2(operand2),
        .result(result)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Addition (15 + 27)", test_num);
        opcode = 3'b000;
        operand1 = 8'd15;
        operand2 = 8'd27;
        #1;

        check_outputs(8'd42);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Addition Overflow (200 + 100)", test_num);
        opcode = 3'b000;
        operand1 = 8'd200;
        operand2 = 8'd100;
        #1;

        check_outputs(8'd44);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Subtraction (50 - 20)", test_num);
        opcode = 3'b001;
        operand1 = 8'd50;
        operand2 = 8'd20;
        #1;

        check_outputs(8'd30);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Subtraction Underflow (10 - 20)", test_num);
        opcode = 3'b001;
        operand1 = 8'd10;
        operand2 = 8'd20;
        #1;

        check_outputs(8'd246);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Multiplication (12 * 8)", test_num);
        opcode = 3'b010;
        operand1 = 8'd12;
        operand2 = 8'd8;
        #1;

        check_outputs(8'd96);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Multiplication Overflow (40 * 10)", test_num);
        opcode = 3'b010;
        operand1 = 8'd40;
        operand2 = 8'd10;
        #1;

        check_outputs(8'd144);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Division (100 / 4)", test_num);
        opcode = 3'b011;
        operand1 = 8'd100;
        operand2 = 8'd4;
        #1;

        check_outputs(8'd25);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Integer Division (7 / 2)", test_num);
        opcode = 3'b011;
        operand1 = 8'd7;
        operand2 = 8'd2;
        #1;

        check_outputs(8'd3);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Division by Zero", test_num);
        opcode = 3'b011;
        operand1 = 8'd50;
        operand2 = 8'd0;


        #1;



        check_outputs(8'h00);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Invalid Opcode (Default to zero)", test_num);
        opcode = 3'b111;
        operand1 = 8'd10;
        operand2 = 8'd20;
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
