`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] A;
    reg [3:0] B;
    reg C;
    wire [3:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .C(C),
        .out(out)
    );
    task testcase001;

    begin
        test_num = 1;
        A = 4'd5;
        B = 4'd3;
        C = 1'b0;
        $display("Test Case %0d: Addition %d + %d (C=0)", test_num, A, B);
        #1;

        check_outputs(4'd8);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        A = 4'd10;
        B = 4'd4;
        C = 1'b1;
        $display("Test Case %0d: Subtraction %d - %d (C=1)", test_num, A, B);
        #1;

        check_outputs(4'd6);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        A = 4'd12;
        B = 4'd7;
        C = 1'b0;
        $display("Test Case %0d: Addition with overflow %d + %d (C=0)", test_num, A, B);
        #1;

        check_outputs(4'd3);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        A = 4'd2;
        B = 4'd5;
        C = 1'b1;
        $display("Test Case %0d: Subtraction with underflow %d - %d (C=1)", test_num, A, B);
        #1;

        check_outputs(4'd13);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        A = 4'd0;
        B = 4'd0;
        C = 1'b0;
        $display("Test Case %0d: Zero addition %d + %d (C=0)", test_num, A, B);
        #1;

        check_outputs(4'd0);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        A = 4'd15;
        B = 4'd15;
        C = 1'b1;
        $display("Test Case %0d: Identity subtraction %d - %d (C=1)", test_num, A, B);
        #1;

        check_outputs(4'd0);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        A = 4'd15;
        B = 4'd1;
        C = 1'b0;
        $display("Test Case %0d: Max boundary addition %d + %d (C=0)", test_num, A, B);
        #1;

        check_outputs(4'd0);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        A = 4'd0;
        B = 4'd1;
        C = 1'b1;
        $display("Test Case %0d: Min boundary subtraction %d - %d (C=1)", test_num, A, B);
        #1;

        check_outputs(4'd15);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        A = 4'b1010;
        B = 4'b0101;
        C = 1'b0;
        $display("Test Case %0d: Bitwise patterns %b + %b (C=0)", test_num, A, B);
        #1;

        check_outputs(4'b1111);
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
        input [3:0] expected_out;
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
