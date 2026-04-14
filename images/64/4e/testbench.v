`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg control;
    reg [7:0] num1;
    reg [7:0] num2;
    wire carry;
    wire [7:0] result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .control(control),
        .num1(num1),
        .num2(num2),
        .carry(carry),
        .result(result)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Addition (10 + 20)", test_num);
        control = 1'b0;
        num1 = 8'd10;
        num2 = 8'd20;
        #1;

        check_outputs(1'b0, 8'd30);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Addition with overflow (200 + 100)", test_num);
        control = 1'b0;
        num1 = 8'd200;
        num2 = 8'd100;
        #1;

        check_outputs(1'b1, 8'd44);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Addition boundary (255 + 1)", test_num);
        control = 1'b0;
        num1 = 8'hFF;
        num2 = 8'h01;
        #1;

        check_outputs(1'b1, 8'h00);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Subtraction (50 - 20)", test_num);
        control = 1'b1;
        num1 = 8'd50;
        num2 = 8'd20;
        #1;

        check_outputs(1'b0, 8'd30);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Subtraction with borrow (20 - 50)", test_num);
        control = 1'b1;
        num1 = 8'd20;
        num2 = 8'd50;
        #1;

        check_outputs(1'b1, 8'd226);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Subtraction boundary (0 - 1)", test_num);
        control = 1'b1;
        num1 = 8'h00;
        num2 = 8'h01;
        #1;

        check_outputs(1'b1, 8'hFF);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Subtraction identity (127 - 127)", test_num);
        control = 1'b1;
        num1 = 8'd127;
        num2 = 8'd127;
        #1;

        check_outputs(1'b0, 8'h00);
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
        input expected_carry;
        input [7:0] expected_result;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_carry === (expected_carry ^ carry ^ expected_carry) &&
                expected_result === (expected_result ^ result ^ expected_result)) begin
                $display("PASS");
                $display("  Outputs: carry=%b, result=%h",
                         carry, result);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: carry=%b, result=%h",
                         expected_carry, expected_result);
                $display("  Got:      carry=%b, result=%h",
                         carry, result);
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
