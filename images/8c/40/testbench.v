`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] a;
    reg [7:0] b;
    reg [1:0] op;
    wire [7:0] out;
    wire valid;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .op(op),
        .out(out),
        .valid(valid)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Basic Addition (10 + 5)", test_num);
        a = 8'd10;
        b = 8'd5;
        op = 2'b00;
        #1;

        check_outputs(8'd15, 1'b1);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Basic Subtraction (50 - 20)", test_num);
        a = 8'd50;
        b = 8'd20;
        op = 2'b01;
        #1;

        check_outputs(8'd30, 1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Basic Multiplication (12 * 4)", test_num);
        a = 8'd12;
        b = 8'd4;
        op = 2'b10;
        #1;

        check_outputs(8'd48, 1'b1);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Basic Division (100 / 5)", test_num);
        a = 8'd100;
        b = 8'd5;
        op = 2'b11;
        #1;

        check_outputs(8'd20, 1'b1);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Addition with Overflow (200 + 100)", test_num);

        a = 8'd200;
        b = 8'd100;
        op = 2'b00;
        #1;

        check_outputs(8'd44, 1'b1);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Subtraction with Negative Result (10 - 20)", test_num);

        a = 8'd10;
        b = 8'd20;
        op = 2'b01;
        #1;

        check_outputs(8'd246, 1'b1);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Multiplication with Overflow (64 * 8)", test_num);

        a = 8'd64;
        b = 8'd8;
        op = 2'b10;
        #1;

        check_outputs(8'd0, 1'b1);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Division with Remainder (10 / 3)", test_num);

        a = 8'd10;
        b = 8'd3;
        op = 2'b11;
        #1;

        check_outputs(8'd3, 1'b1);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Boundary - Multiplication by Zero (255 * 0)", test_num);
        a = 8'd255;
        b = 8'd0;
        op = 2'b10;
        #1;

        check_outputs(8'd0, 1'b1);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Boundary - Maximum Multiplication (16 * 16)", test_num);

        a = 8'd16;
        b = 8'd16;
        op = 2'b10;
        #1;

        check_outputs(8'd0, 1'b1);
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
        input [7:0] expected_out;
        input expected_valid;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_out === (expected_out ^ out ^ expected_out) &&
                expected_valid === (expected_valid ^ valid ^ expected_valid)) begin
                $display("PASS");
                $display("  Outputs: out=%h, valid=%b",
                         out, valid);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out=%h, valid=%b",
                         expected_out, expected_valid);
                $display("  Got:      out=%h, valid=%b",
                         out, valid);
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
