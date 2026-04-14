`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] operand1;
    reg [3:0] operand2;
    reg [1:0] select;
    wire [3:0] result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .operand1(operand1),
        .operand2(operand2),
        .select(select),
        .result(result)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Multiplication (select=00), 3 * 2", test_num);
        select = 2'b00;
        operand1 = 4'd3;
        operand2 = 4'd2;
        #1;

        check_outputs(4'd6);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Multiplication (select=00), 5 * 4 (Overflow)", test_num);
        select = 2'b00;
        operand1 = 4'd5;
        operand2 = 4'd4;
        #1;

        check_outputs(4'd4);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Multiplication (select=00), 15 * 0", test_num);
        select = 2'b00;
        operand1 = 4'd15;
        operand2 = 4'd0;
        #1;

        check_outputs(4'd0);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Addition (select=01), 7 + 5", test_num);
        select = 2'b01;
        operand1 = 4'd7;
        operand2 = 4'd5;
        #1;

        check_outputs(4'd12);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Addition (select=10), 13 + 6 (Overflow)", test_num);
        select = 2'b10;
        operand1 = 4'd13;
        operand2 = 4'd6;
        #1;

        check_outputs(4'd3);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Addition (select=11), 15 + 1", test_num);
        select = 2'b11;
        operand1 = 4'd15;
        operand2 = 4'd1;
        #1;

        check_outputs(4'd0);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Multiplication (select=00), 15 * 15", test_num);
        select = 2'b00;
        operand1 = 4'd15;
        operand2 = 4'd15;
        #1;

        check_outputs(4'd1);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Addition (select=01), 0 + 0", test_num);
        select = 2'b01;
        operand1 = 4'd0;
        operand2 = 4'd0;
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
