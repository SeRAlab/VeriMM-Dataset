`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] a;
    reg [31:0] b;
    reg [1:0] mode;
    wire [31:0] add_out;
    wire [31:0] div_out;
    wire [31:0] mul_out;
    wire [31:0] sub_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .mode(mode),
        .add_out(add_out),
        .div_out(div_out),
        .mul_out(mul_out),
        .sub_out(sub_out)
    );
    task testcase001;

        begin
            $display("Testcase 001: Basic Addition");
            a = 32'd15; b = 32'd25; mode = 2'b00;
            #1;

            check_outputs(32'd40, 32'd0, 32'd0, 32'd0);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Basic Subtraction");
            a = 32'd100; b = 32'd45; mode = 2'b01;
            #1;

            check_outputs(32'd0, 32'd0, 32'd0, 32'd55);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Basic Multiplication");
            a = 32'd12; b = 32'd9; mode = 2'b10;
            #1;

            check_outputs(32'd0, 32'd0, 32'd108, 32'd0);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Basic Division");
            a = 32'd144; b = 32'd12; mode = 2'b11;
            #1;

            check_outputs(32'd0, 32'd12, 32'd0, 32'd0);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Addition Overflow Wrap-around");
            a = 32'hFFFFFFFF; b = 32'd1; mode = 2'b00;
            #1;

            check_outputs(32'd0, 32'd0, 32'd0, 32'd0);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: Subtraction Underflow (Negative Result)");
            a = 32'd10; b = 32'd20; mode = 2'b01;
            #1;

            check_outputs(32'd0, 32'd0, 32'd0, 32'hFFFFFFF6);
        end
        endtask

    task testcase007;

        begin
            $display("Testcase 007: Large Multiplication");
            a = 32'h10000; b = 32'h10; mode = 2'b10;
            #1;

            check_outputs(32'd0, 32'd0, 32'h100000, 32'd0);
        end
        endtask

    task testcase008;

        begin
            $display("Testcase 008: Integer Division (Flooring)");
            a = 32'd10; b = 32'd3; mode = 2'b11;
            #1;

            check_outputs(32'd0, 32'd3, 32'd0, 32'd0);
        end
        endtask

    task testcase009;

        begin
            $display("Testcase 009: Zero Operands Addition");
            a = 32'd0; b = 32'd0; mode = 2'b00;
            #1;

            check_outputs(32'd0, 32'd0, 32'd0, 32'd0);
        end
        endtask

    task testcase010;

        begin
            $display("Testcase 010: Division by Larger Number (Result 0)");
            a = 32'd5; b = 32'd10; mode = 2'b11;
            #1;

            check_outputs(32'd0, 32'd0, 32'd0, 32'd0);
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
        input [31:0] expected_add_out;
        input [31:0] expected_div_out;
        input [31:0] expected_mul_out;
        input [31:0] expected_sub_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_add_out === (expected_add_out ^ add_out ^ expected_add_out) &&
                expected_div_out === (expected_div_out ^ div_out ^ expected_div_out) &&
                expected_mul_out === (expected_mul_out ^ mul_out ^ expected_mul_out) &&
                expected_sub_out === (expected_sub_out ^ sub_out ^ expected_sub_out)) begin
                $display("PASS");
                $display("  Outputs: add_out=%h, div_out=%h, mul_out=%h, sub_out=%h",
                         add_out, div_out, mul_out, sub_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: add_out=%h, div_out=%h, mul_out=%h, sub_out=%h",
                         expected_add_out, expected_div_out, expected_mul_out, expected_sub_out);
                $display("  Got:      add_out=%h, div_out=%h, mul_out=%h, sub_out=%h",
                         add_out, div_out, mul_out, sub_out);
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
