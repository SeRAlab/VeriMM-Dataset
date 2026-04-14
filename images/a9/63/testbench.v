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
        test_num = test_num + 1;
        $display("Test Case %0d: Addition (1.5 + 2.25)", test_num);
        A = 16'h0180;
        B = 16'h0240;
        op = 2'b00;
        #1;

        check_outputs(16'h03C0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Subtraction (5.0 - 2.5)", test_num);
        A = 16'h0500;
        B = 16'h0280;
        op = 2'b01;
        #1;

        check_outputs(16'h0280);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Subtraction (1.0 - 2.0)", test_num);
        A = 16'h0100;
        B = 16'h0200;
        op = 2'b01;
        #1;

        check_outputs(16'hFF00);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Multiplication (2.0 * 1.5)", test_num);
        A = 16'h0200;
        B = 16'h0180;
        op = 2'b10;
        #1;

        check_outputs(16'h0300);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Multiplication (0.5 * 0.5)", test_num);
        A = 16'h0080;
        B = 16'h0080;
        op = 2'b10;
        #1;

        check_outputs(16'h0040);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Division (8.0 / 2.0)", test_num);
        A = 16'h0800;
        B = 16'h0200;
        op = 2'b11;
        #1;

        check_outputs(16'h0400);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Division (1.0 / 4.0)", test_num);
        A = 16'h0100;
        B = 16'h0400;
        op = 2'b11;
        #1;

        check_outputs(16'h0040);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Signed Multiplication (-2.0 * 3.0)", test_num);
        A = 16'hFE00;
        B = 16'h0300;
        op = 2'b10;
        #1;

        check_outputs(16'hFA00);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Signed Division (-10.0 / 2.0)", test_num);
        A = 16'hF600;
        B = 16'h0200;
        op = 2'b11;
        #1;

        check_outputs(16'hFB00);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Signed Addition (-1.25 + -0.75)", test_num);
        A = 16'hFEC0;
        B = 16'hFF40;
        op = 2'b00;
        #1;

        check_outputs(16'hFE00);
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
