`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [63:0] operands;
    reg [1:0] operation;
    wire [31:0] result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .operands(operands),
        .operation(operation),
        .result(result)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Addition (5 + 10)", test_num);
            operation = 2'b00;
            operands = {32'd10, 32'd5};
            #1;

            check_outputs(32'd15);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Addition (-5 + -10)", test_num);
            operation = 2'b00;
            operands = {32'shFFFFFFF6, 32'shFFFFFFFB};
            #1;

            check_outputs(32'shFFFFFFF1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Subtraction (20 - 5)", test_num);
            operation = 2'b01;
            operands = {32'd5, 32'd20};
            #1;

            check_outputs(32'd15);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Subtraction (5 - 20)", test_num);
            operation = 2'b01;
            operands = {32'd20, 32'd5};
            #1;

            check_outputs(32'shFFFFFFF1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Multiplication (12 * 3)", test_num);
            operation = 2'b10;
            operands = {32'd3, 32'd12};
            #1;

            check_outputs(32'd36);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Multiplication (-4 * 5)", test_num);
            operation = 2'b10;
            operands = {32'd5, 32'shFFFFFFFC};
            #1;

            check_outputs(32'shFFFFFFEC);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Division (100 / 4)", test_num);
            operation = 2'b11;
            operands = {32'd4, 32'd100};
            #1;

            check_outputs(32'd25);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Division (-50 / 2)", test_num);
            operation = 2'b11;
            operands = {32'd2, 32'shFFFFFFCE};
            #1;

            check_outputs(32'shFFFFFFE7);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Multiplication (-1 * -1)", test_num);
            operation = 2'b10;
            operands = {32'shFFFFFFFF, 32'shFFFFFFFF};
            #1;

            check_outputs(32'd1);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Subtraction (500 - 500)", test_num);
            operation = 2'b01;
            operands = {32'd500, 32'd500};
            #1;

            check_outputs(32'd0);
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
        input [31:0] expected_result;
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
