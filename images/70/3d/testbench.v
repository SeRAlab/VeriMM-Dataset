`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg A;
    reg B;
    reg C;
    reg D;
    wire V;
    wire [1:0] Y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .C(C),
        .D(D),
        .V(V),
        .Y(Y)
    );
    task testcase001;

    begin
        $display("Test Case 001: No inputs high");
        test_num = 1;
        A = 0; B = 0; C = 0; D = 0;
        #1;

        check_outputs(1'b0, 2'b00);
    end
        endtask

    task testcase002;

    begin
        $display("Test Case 002: Only A high");
        test_num = 2;
        A = 1; B = 0; C = 0; D = 0;
        #1;

        check_outputs(1'b1, 2'b00);
    end
        endtask

    task testcase003;

    begin
        $display("Test Case 003: Only B high");
        test_num = 3;
        A = 0; B = 1; C = 0; D = 0;
        #1;

        check_outputs(1'b1, 2'b01);
    end
        endtask

    task testcase004;

    begin
        $display("Test Case 004: Only C high");
        test_num = 4;
        A = 0; B = 0; C = 1; D = 0;
        #1;

        check_outputs(1'b1, 2'b10);
    end
        endtask

    task testcase005;

    begin
        $display("Test Case 005: Only D high");
        test_num = 5;
        A = 0; B = 0; C = 0; D = 1;
        #1;

        check_outputs(1'b1, 2'b11);
    end
        endtask

    task testcase006;

    begin
        $display("Test Case 006: Multiple inputs - A has priority (A and D)");
        test_num = 6;
        A = 1; B = 0; C = 0; D = 1;
        #1;

        check_outputs(1'b1, 2'b00);
    end
        endtask

    task testcase007;

    begin
        $display("Test Case 007: Multiple inputs - B has priority (B and C)");
        test_num = 7;
        A = 0; B = 1; C = 1; D = 0;
        #1;

        check_outputs(1'b1, 2'b01);
    end
        endtask

    task testcase008;

    begin
        $display("Test Case 008: Multiple inputs - C has priority (C and D)");
        test_num = 8;
        A = 0; B = 0; C = 1; D = 1;
        #1;

        check_outputs(1'b1, 2'b10);
    end
        endtask

    task testcase009;

    begin
        $display("Test Case 009: All inputs high - A has highest priority");
        test_num = 9;
        A = 1; B = 1; C = 1; D = 1;
        #1;

        check_outputs(1'b1, 2'b00);
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
        input expected_V;
        input [1:0] expected_Y;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_V === (expected_V ^ V ^ expected_V) &&
                expected_Y === (expected_Y ^ Y ^ expected_Y)) begin
                $display("PASS");
                $display("  Outputs: V=%b, Y=%h",
                         V, Y);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: V=%b, Y=%h",
                         expected_V, expected_Y);
                $display("  Got:      V=%b, Y=%h",
                         V, Y);
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
