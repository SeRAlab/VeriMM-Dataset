`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] A;
    reg [3:0] B;
    reg SUB;
    wire C_OUT;
    wire [3:0] SUM;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .SUB(SUB),
        .C_OUT(C_OUT),
        .SUM(SUM)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Basic Addition (5 + 3)", test_num);
        A = 4'd5;
        B = 4'd3;
        SUB = 1'b0;
        #1;

        check_outputs(1'b0, 4'd8);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Addition with Carry (12 + 5)", test_num);
        A = 4'd12;
        B = 4'd5;
        SUB = 1'b0;
        #1;

        check_outputs(1'b1, 4'd1);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Addition Max Boundary (15 + 1)", test_num);
        A = 4'd15;
        B = 4'd1;
        SUB = 1'b0;
        #1;

        check_outputs(1'b1, 4'd0);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Basic Subtraction (10 - 4)", test_num);
        A = 4'd10;
        B = 4'd4;
        SUB = 1'b1;
        #1;

        check_outputs(1'b0, 4'd6);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Subtraction with Borrow (3 - 5)", test_num);
        A = 4'd3;
        B = 4'd5;
        SUB = 1'b1;
        #1;

        check_outputs(1'b1, 4'd14);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Subtraction to Zero (7 - 7)", test_num);
        A = 4'd7;
        B = 4'd7;
        SUB = 1'b1;
        #1;

        check_outputs(1'b0, 4'd0);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Subtraction from Zero (0 - 1)", test_num);
        A = 4'd0;
        B = 4'd1;
        SUB = 1'b1;
        #1;

        check_outputs(1'b1, 4'd15);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Addition of Max Values (15 + 15)", test_num);
        A = 4'd15;
        B = 4'd15;
        SUB = 1'b0;
        #1;

        check_outputs(1'b1, 4'd14);
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
        input expected_C_OUT;
        input [3:0] expected_SUM;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_C_OUT === (expected_C_OUT ^ C_OUT ^ expected_C_OUT) &&
                expected_SUM === (expected_SUM ^ SUM ^ expected_SUM)) begin
                $display("PASS");
                $display("  Outputs: C_OUT=%b, SUM=%h",
                         C_OUT, SUM);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: C_OUT=%b, SUM=%h",
                         expected_C_OUT, expected_SUM);
                $display("  Got:      C_OUT=%b, SUM=%h",
                         C_OUT, SUM);
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
