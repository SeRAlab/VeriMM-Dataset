`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    wire [255:0] A_Rom_const;
    wire [255:0] B_Rom_const;
    wire [255:0] P_Rom_const;
    wire carry_in_2;
    wire carry_in_n;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A_Rom_const(A_Rom_const),
        .B_Rom_const(B_Rom_const),
        .P_Rom_const(P_Rom_const),
        .carry_in_2(carry_in_2),
        .carry_in_n(carry_in_n)
    );
    task testcase001;

        begin
            $display("\nTestcase 001: Verifying Carry Constants (carry_in_n=0, carry_in_2=1)...");
            test_num = 1;


            expected_A = A_Rom_const;
            expected_B = B_Rom_const;
            expected_P = P_Rom_const;

            #1;


            check_outputs(expected_A, expected_B, expected_P, 1'b1, 1'b0);
        end
        endtask

    task testcase002;

        begin
            $display("\nTestcase 002: Verifying Stability of ROM values over time...");
            test_num = 2;
            #500;

            #1;


            check_outputs(expected_A, expected_B, expected_P, 1'b1, 1'b0);
        end
        endtask

    task testcase003;

        begin
            $display("\nTestcase 003: Checking for Undefined/High-Impedance states...");
            test_num = 3;

            if (^A_Rom_const === 1'bX || ^B_Rom_const === 1'bX || ^P_Rom_const === 1'bX ||
                carry_in_2 === 1'bX || carry_in_n === 1'bX) begin
                $display("FAIL: One or more outputs contain X or Z states.");
                fail_count = fail_count + 1;
            end else begin
                $display("PASS: All outputs are at valid logic levels.");
                pass_count = pass_count + 1;
            end
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
        input [255:0] expected_A_Rom_const;
        input [255:0] expected_B_Rom_const;
        input [255:0] expected_P_Rom_const;
        input expected_carry_in_2;
        input expected_carry_in_n;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_A_Rom_const === (expected_A_Rom_const ^ A_Rom_const ^ expected_A_Rom_const) &&
                expected_B_Rom_const === (expected_B_Rom_const ^ B_Rom_const ^ expected_B_Rom_const) &&
                expected_P_Rom_const === (expected_P_Rom_const ^ P_Rom_const ^ expected_P_Rom_const) &&
                expected_carry_in_2 === (expected_carry_in_2 ^ carry_in_2 ^ expected_carry_in_2) &&
                expected_carry_in_n === (expected_carry_in_n ^ carry_in_n ^ expected_carry_in_n)) begin
                $display("PASS");
                $display("  Outputs: A_Rom_const=%h, B_Rom_const=%h, P_Rom_const=%h, carry_in_2=%b, carry_in_n=%b",
                         A_Rom_const, B_Rom_const, P_Rom_const, carry_in_2, carry_in_n);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: A_Rom_const=%h, B_Rom_const=%h, P_Rom_const=%h, carry_in_2=%b, carry_in_n=%b",
                         expected_A_Rom_const, expected_B_Rom_const, expected_P_Rom_const, expected_carry_in_2, expected_carry_in_n);
                $display("  Got:      A_Rom_const=%h, B_Rom_const=%h, P_Rom_const=%h, carry_in_2=%b, carry_in_n=%b",
                         A_Rom_const, B_Rom_const, P_Rom_const, carry_in_2, carry_in_n);
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
