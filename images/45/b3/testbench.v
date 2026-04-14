`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg A0;
    reg A1;
    reg A2;
    reg A3;
    reg B0;
    reg B1;
    reg B2;
    reg B3;
    wire GT;
    wire LT;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A0(A0),
        .A1(A1),
        .A2(A2),
        .A3(A3),
        .B0(B0),
        .B1(B1),
        .B2(B2),
        .B3(B3),
        .GT(GT),
        .LT(LT)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Test Case 001: A=0000, B=0000 (Equality)");
        A3=0; A2=0; A1=0; A0=0;
        B3=0; B2=0; B1=0; B0=0;
        #1;

        check_outputs(1'b0, 1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test Case 002: A=1111, B=1111 (Equality)");
        A3=1; A2=1; A1=1; A0=1;
        B3=1; B2=1; B1=1; B0=1;
        #1;

        check_outputs(1'b0, 1'b0);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test Case 003: A=1000, B=0000 (A > B)");
        A3=1; A2=0; A1=0; A0=0;
        B3=0; B2=0; B1=0; B0=0;
        #1;

        check_outputs(1'b1, 1'b0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test Case 004: A=0000, B=1000 (A < B)");
        A3=0; A2=0; A1=0; A0=0;
        B3=1; B2=0; B1=0; B0=0;
        #1;

        check_outputs(1'b0, 1'b1);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test Case 005: A=0001, B=0000 (A > B)");
        A3=0; A2=0; A1=0; A0=1;
        B3=0; B2=0; B1=0; B0=0;
        #1;

        check_outputs(1'b1, 1'b0);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test Case 006: A=0000, B=0001 (A < B)");
        A3=0; A2=0; A1=0; A0=0;
        B3=0; B2=0; B1=0; B0=1;
        #1;

        check_outputs(1'b0, 1'b1);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Test Case 007: A=1010, B=0101 (A > B)");
        A3=1; A2=0; A1=1; A0=0;
        B3=0; B2=1; B1=0; B0=1;
        #1;

        check_outputs(1'b1, 1'b0);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Test Case 008: A=0101, B=1010 (A < B)");
        A3=0; A2=1; A1=0; A0=1;
        B3=1; B2=0; B1=1; B0=0;
        #1;

        check_outputs(1'b0, 1'b1);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        $display("Test Case 009: A=1100, B=1101 (A < B)");
        A3=1; A2=1; A1=0; A0=0;
        B3=1; B2=1; B1=0; B0=1;
        #1;

        check_outputs(1'b0, 1'b1);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        $display("Test Case 010: A=1101, B=1100 (A > B)");
        A3=1; A2=1; A1=0; A0=1;
        B3=1; B2=1; B1=0; B0=0;
        #1;

        check_outputs(1'b1, 1'b0);
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
        input expected_GT;
        input expected_LT;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_GT === (expected_GT ^ GT ^ expected_GT) &&
                expected_LT === (expected_LT ^ LT ^ expected_LT)) begin
                $display("PASS");
                $display("  Outputs: GT=%b, LT=%b",
                         GT, LT);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: GT=%b, LT=%b",
                         expected_GT, expected_LT);
                $display("  Got:      GT=%b, LT=%b",
                         GT, LT);
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
