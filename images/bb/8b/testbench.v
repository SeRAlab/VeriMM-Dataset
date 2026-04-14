`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] a;
    reg [15:0] b;
    reg [1:0] op;
    wire [15:0] result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .op(op),
        .result(result)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Test Case %0d: Simple Addition (10 + 20)", test_num);
        a = 16'sd10;
        b = 16'sd20;
        op = 2'b00;
        #1;

        check_outputs(16'sd30);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test Case %0d: Addition with Negatives (-10 + -20)", test_num);
        a = -16'sd10;
        b = -16'sd20;
        op = 2'b00;
        #1;

        check_outputs(-16'sd30);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test Case %0d: Simple Subtraction (50 - 20)", test_num);
        a = 16'sd50;
        b = 16'sd20;
        op = 2'b01;
        #1;

        check_outputs(16'sd30);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test Case %0d: Subtraction Negative Result (10 - 20)", test_num);
        a = 16'sd10;
        b = 16'sd20;
        op = 2'b01;
        #1;

        check_outputs(-16'sd10);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test Case %0d: Multiplication (12 * 10)", test_num);
        a = 16'sd12;
        b = 16'sd10;
        op = 2'b10;
        #1;

        check_outputs(16'sd120);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test Case %0d: Signed Multiplication (-5 * 4)", test_num);
        a = -16'sd5;
        b = 16'sd4;
        op = 2'b10;
        #1;

        check_outputs(-16'sd20);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Test Case %0d: Division (100 / 5)", test_num);
        a = 16'sd100;
        b = 16'sd5;
        op = 2'b11;
        #1;

        check_outputs(16'sd20);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Test Case %0d: Signed Division (-100 / 3)", test_num);
        a = -16'sd100;
        b = 16'sd3;
        op = 2'b11;
        #1;

        check_outputs(-16'sd33);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        $display("Test Case %0d: Addition Overflow (32767 + 1)", test_num);
        a = 16'h7FFF;
        b = 16'h0001;
        op = 2'b00;
        #1;

        check_outputs(16'h8000);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        $display("Test Case %0d: Multiplication Truncation (500 * 100)", test_num);
        a = 16'sd500;
        b = 16'sd100;
        op = 2'b10;
        #1;

        check_outputs(16'hC350);
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
