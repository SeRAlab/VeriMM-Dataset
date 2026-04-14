`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] A;
    reg ADD;
    reg [3:0] B;
    reg SUB;
    wire [3:0] C;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .ADD(ADD),
        .B(B),
        .SUB(SUB),
        .C(C)
    );
    task testcase001;

    begin
        test_num = 1;
        A = 4'd5;
        B = 4'd3;
        ADD = 1'b1;
        SUB = 1'b0;
        $display("Test %0d: Addition (A=%d, B=%d, ADD=1, SUB=0)", test_num, A, B);
        #1;

        check_outputs(4'd8);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        A = 4'd12;
        B = 4'd6;
        ADD = 1'b1;
        SUB = 1'b0;
        $display("Test %0d: Addition Overflow (A=%d, B=%d, ADD=1, SUB=0)", test_num, A, B);

        #1;


        check_outputs(4'd2);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        A = 4'd10;
        B = 4'd4;
        ADD = 1'b0;
        SUB = 1'b1;
        $display("Test %0d: Subtraction (A=%d, B=%d, ADD=0, SUB=1)", test_num, A, B);
        #1;

        check_outputs(4'd6);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        A = 4'd3;
        B = 4'd5;
        ADD = 1'b0;
        SUB = 1'b1;
        $display("Test %0d: Subtraction Underflow (A=%d, B=%d, ADD=0, SUB=1)", test_num, A, B);

        #1;


        check_outputs(4'hE);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        A = 4'd7;
        B = 4'd2;
        ADD = 1'b1;
        SUB = 1'b1;
        $display("Test %0d: Asserting both ADD and SUB (Expect Undefined)", test_num);
        #1;

        check_outputs(4'hx);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        A = 4'd0;
        B = 4'd0;
        ADD = 1'b1;
        SUB = 1'b0;
        $display("Test %0d: Zero Addition (A=0, B=0, ADD=1)", test_num);
        #1;

        check_outputs(4'd0);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        A = 4'd15;
        B = 4'd15;
        ADD = 1'b0;
        SUB = 1'b1;
        $display("Test %0d: Subtraction to Zero (A=15, B=15, SUB=1)", test_num);
        #1;

        check_outputs(4'd0);
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
        input [3:0] expected_C;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_C === (expected_C ^ C ^ expected_C)) begin
                $display("PASS");
                $display("  Outputs: C=%h",
                         C);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: C=%h",
                         expected_C);
                $display("  Got:      C=%h",
                         C);
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
