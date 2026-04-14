`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [1:0] op;
    reg [15:0] operands;
    wire [15:0] result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .op(op),
        .operands(operands),
        .result(result)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Addition basic (10 + 20)", test_num);
            op = 2'b00;
            operands = {8'd20, 8'd10};
            #1;

            check_outputs(16'd30);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Addition overflow/max (255 + 255)", test_num);
            op = 2'b00;
            operands = {8'hFF, 8'hFF};
            #1;

            check_outputs(16'd510);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Subtraction basic (100 - 40)", test_num);
            op = 2'b01;
            operands = {8'd40, 8'd100};
            #1;

            check_outputs(16'd60);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Subtraction underflow (10 - 30)", test_num);
            op = 2'b01;
            operands = {8'd30, 8'd10};
            #1;

            check_outputs(16'hFFEC);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Multiplication basic (12 * 10)", test_num);
            op = 2'b10;
            operands = {8'd10, 8'd12};
            #1;

            check_outputs(16'd120);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Multiplication large (255 * 255)", test_num);
            op = 2'b10;
            operands = {8'hFF, 8'hFF};
            #1;

            check_outputs(16'd65025);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Division basic (100 / 5)", test_num);
            op = 2'b11;
            operands = {8'd5, 8'd100};
            #1;

            check_outputs(16'd20);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Division truncation (10 / 3)", test_num);
            op = 2'b11;
            operands = {8'd3, 8'd10};
            #1;

            check_outputs(16'd3);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Division by zero", test_num);
            op = 2'b11;
            operands = {8'd0, 8'd10};
            #1;

            check_outputs(16'bx);
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
        input [15:0] expected_result;
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
