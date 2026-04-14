`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] A;
    reg [3:0] B;
    reg S;
    wire [3:0] Y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .S(S),
        .Y(Y)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Test Case %0d: Simple Addition (S=0, A=2, B=3)", test_num);
        A = 4'd2;
        B = 4'd3;
        S = 1'b0;
        #1;

        check_outputs(4'd5);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test Case %0d: Addition with Overflow (S=0, A=12, B=6)", test_num);
        A = 4'd12;
        B = 4'd6;
        S = 1'b0;
        #1;

        check_outputs(4'd2);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test Case %0d: Addition with Zero (S=0, A=15, B=0)", test_num);
        A = 4'd15;
        B = 4'd0;
        S = 1'b0;
        #1;

        check_outputs(4'd15);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test Case %0d: Simple Subtraction (S=1, A=10, B=4)", test_num);
        A = 4'd10;
        B = 4'd4;
        S = 1'b1;
        #1;

        check_outputs(4'd6);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test Case %0d: Subtraction resulting in Zero (S=1, A=7, B=7)", test_num);
        A = 4'd7;
        B = 4'd7;
        S = 1'b1;
        #1;

        check_outputs(4'd0);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test Case %0d: Subtraction with Underflow (S=1, A=2, B=5)", test_num);
        A = 4'd2;
        B = 4'd5;
        S = 1'b1;
        #1;

        check_outputs(4'd13);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Test Case %0d: Subtraction from Zero (S=1, A=0, B=1)", test_num);
        A = 4'd0;
        B = 4'd1;
        S = 1'b1;
        #1;

        check_outputs(4'd15);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Test Case %0d: Max values Addition (S=0, A=15, B=15)", test_num);
        A = 4'hF;
        B = 4'hF;
        S = 1'b0;
        #1;

        check_outputs(4'hE);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        $display("Test Case %0d: Max values Subtraction (S=1, A=15, B=15)", test_num);
        A = 4'hF;
        B = 4'hF;
        S = 1'b1;
        #1;

        check_outputs(4'h0);
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
        input [3:0] expected_Y;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Y === (expected_Y ^ Y ^ expected_Y)) begin
                $display("PASS");
                $display("  Outputs: Y=%h",
                         Y);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Y=%h",
                         expected_Y);
                $display("  Got:      Y=%h",
                         Y);
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
