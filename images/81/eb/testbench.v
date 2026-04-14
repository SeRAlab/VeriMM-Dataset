`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] A;
    reg [3:0] B;
    reg mode;
    wire [3:0] Y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .mode(mode),
        .Y(Y)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("\nTestcase %0d: Mode 0 (Addition) - Simple Sum", test_num);
        A = 4'd5;
        B = 4'd3;
        mode = 1'b0;
        #1;

        check_outputs(4'd8);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("\nTestcase %0d: Mode 0 (Addition) - Carry Overflow", test_num);
        A = 4'd12;
        B = 4'd7;
        mode = 1'b0;
        #1;

        check_outputs(4'd3);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("\nTestcase %0d: Mode 1 (Subtraction & Inversion) - Positive Result", test_num);
        A = 4'd5;
        B = 4'd3;
        mode = 1'b1;

        #1;


        check_outputs(4'd13);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("\nTestcase %0d: Mode 1 (Subtraction & Inversion) - Result Zero", test_num);
        A = 4'd10;
        B = 4'd10;
        mode = 1'b1;

        #1;


        check_outputs(4'd15);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("\nTestcase %0d: Mode 1 (Subtraction & Inversion) - Negative/Underflow", test_num);
        A = 4'd2;
        B = 4'd6;
        mode = 1'b1;

        #1;


        check_outputs(4'd3);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("\nTestcase %0d: Mode 0 (Addition) - Maximum Values", test_num);
        A = 4'hF;
        B = 4'hF;
        mode = 1'b0;
        #1;

        check_outputs(4'd14);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("\nTestcase %0d: Mode 1 (Subtraction & Inversion) - Zero Minus Max", test_num);
        A = 4'd0;
        B = 4'd1;
        mode = 1'b1;

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
