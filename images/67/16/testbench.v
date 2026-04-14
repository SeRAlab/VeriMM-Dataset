`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] A;
    reg [15:0] B;
    reg [1:0] op;
    wire [15:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .op(op),
        .out(out)
    );
    task testcase001;

    begin
        A = 16'd100;
        B = 16'd200;
        op = 2'b00;
        #10;
        $display("Test Case 001: Addition (100 + 200)");
        #1;

        check_outputs(16'd300);
    end
        endtask

    task testcase002;

    begin
        A = 16'd500;
        B = 16'd150;
        op = 2'b01;
        #10;
        $display("Test Case 002: Subtraction (500 - 150)");
        #1;

        check_outputs(16'd350);
    end
        endtask

    task testcase003;

    begin
        A = 16'd25;
        B = 16'd10;
        op = 2'b10;
        #10;
        $display("Test Case 003: Multiplication (25 * 10)");
        #1;

        check_outputs(16'd250);
    end
        endtask

    task testcase004;

    begin
        A = 16'd100;
        B = 16'd4;
        op = 2'b11;
        #10;
        $display("Test Case 004: Division (100 / 4)");
        #1;

        check_outputs(16'd25);
    end
        endtask

    task testcase005;

    begin
        A = 16'hFFFF;
        B = 16'h0001;
        op = 2'b00;
        #10;
        $display("Test Case 005: Addition Overflow (0xFFFF + 1)");
        #1;

        check_outputs(16'h0000);
    end
        endtask

    task testcase006;

    begin
        A = 16'h0000;
        B = 16'h0001;
        op = 2'b01;
        #10;
        $display("Test Case 006: Subtraction Underflow (0 - 1)");
        #1;

        check_outputs(16'hFFFF);
    end
        endtask

    task testcase007;

    begin
        A = 16'h1000;
        B = 16'h0020;
        op = 2'b10;
        #10;
        $display("Test Case 007: Multiplication Truncation (0x1000 * 0x20)");
        #1;

        check_outputs(16'h0000);
    end
        endtask

    task testcase008;

    begin
        A = 16'd0;
        B = 16'd50;
        op = 2'b11;
        #10;
        $display("Test Case 008: Division Zero Dividend (0 / 50)");
        #1;

        check_outputs(16'd0);
    end
        endtask

    task testcase009;

    begin
        A = 16'd10;
        B = 16'd3;
        op = 2'b11;
        #10;
        $display("Test Case 009: Division Floor (10 / 3)");
        #1;

        check_outputs(16'd3);
    end
        endtask

    task testcase010;

    begin
        A = 16'h8000;
        B = 16'h8000;
        op = 2'b00;
        #10;
        $display("Test Case 010: Large Addition (0x8000 + 0x8000)");
        #1;

        check_outputs(16'h0000);
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
        input [15:0] expected_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_out === (expected_out ^ out ^ expected_out)) begin
                $display("PASS");
                $display("  Outputs: out=%h",
                         out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out=%h",
                         expected_out);
                $display("  Got:      out=%h",
                         out);
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
