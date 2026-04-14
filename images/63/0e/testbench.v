`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] A;
    reg [7:0] B;
    reg [1:0] op;
    wire error;
    wire [7:0] result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .op(op),
        .error(error),
        .result(result)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Addition (10 + 25)", test_num);
        A = 8'd10;
        B = 8'd25;
        op = 2'b00;
        #1;

        check_outputs(1'b0, 8'd35);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Addition with overflow (200 + 100)", test_num);
        A = 8'd200;
        B = 8'd100;
        op = 2'b00;

        #1;


        check_outputs(1'b0, 8'd44);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Subtraction (50 - 20)", test_num);
        A = 8'd50;
        B = 8'd20;
        op = 2'b01;
        #1;

        check_outputs(1'b0, 8'd30);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Subtraction with underflow (10 - 20)", test_num);
        A = 8'd10;
        B = 8'd20;
        op = 2'b01;

        #1;


        check_outputs(1'b0, 8'd246);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Multiplication (12 * 5)", test_num);
        A = 8'd12;
        B = 8'd5;
        op = 2'b10;
        #1;

        check_outputs(1'b0, 8'd60);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Multiplication with overflow (20 * 20)", test_num);
        A = 8'd20;
        B = 8'd20;
        op = 2'b10;

        #1;


        check_outputs(1'b0, 8'd144);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Division (100 / 4)", test_num);
        A = 8'd100;
        B = 8'd4;
        op = 2'b11;
        #1;

        check_outputs(1'b0, 8'd25);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Division floor check (10 / 3)", test_num);
        A = 8'd10;
        B = 8'd3;
        op = 2'b11;
        #1;

        check_outputs(1'b0, 8'd3);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Division by zero (10 / 0)", test_num);
        A = 8'd10;
        B = 8'd0;
        op = 2'b11;

        #1;


        check_outputs(1'b1, 8'd0);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Subtraction resulting in zero (5 - 5)", test_num);
        A = 8'd5;
        B = 8'd5;
        op = 2'b01;
        #1;

        check_outputs(1'b0, 8'd0);
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
        input expected_error;
        input [7:0] expected_result;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_error === (expected_error ^ error ^ expected_error) &&
                expected_result === (expected_result ^ result ^ expected_result)) begin
                $display("PASS");
                $display("  Outputs: error=%b, result=%h",
                         error, result);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: error=%b, result=%h",
                         expected_error, expected_result);
                $display("  Got:      error=%b, result=%h",
                         error, result);
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
