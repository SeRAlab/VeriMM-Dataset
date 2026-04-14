`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg addend1;
    reg addend2;
    reg lastCarry;
    wire carry;
    wire sum;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .addend1(addend1),
        .addend2(addend2),
        .lastCarry(lastCarry),
        .carry(carry),
        .sum(sum)
    );
    task testcase001;

        begin
            test_num = 1;
            addend1 = 0;
            addend2 = 0;
            lastCarry = 0;
            $display("Test Case 001: 0 + 0 + 0");
            #1;

            check_outputs(0, 0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            addend1 = 0;
            addend2 = 0;
            lastCarry = 1;
            $display("Test Case 002: 0 + 0 + 1");
            #1;

            check_outputs(0, 1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            addend1 = 0;
            addend2 = 1;
            lastCarry = 0;
            $display("Test Case 003: 0 + 1 + 0");
            #1;

            check_outputs(0, 1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            addend1 = 0;
            addend2 = 1;
            lastCarry = 1;
            $display("Test Case 004: 0 + 1 + 1");
            #1;

            check_outputs(1, 0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            addend1 = 1;
            addend2 = 0;
            lastCarry = 0;
            $display("Test Case 005: 1 + 0 + 0");
            #1;

            check_outputs(0, 1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            addend1 = 1;
            addend2 = 0;
            lastCarry = 1;
            $display("Test Case 006: 1 + 0 + 1");
            #1;

            check_outputs(1, 0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            addend1 = 1;
            addend2 = 1;
            lastCarry = 0;
            $display("Test Case 007: 1 + 1 + 0");
            #1;

            check_outputs(1, 0);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            addend1 = 1;
            addend2 = 1;
            lastCarry = 1;
            $display("Test Case 008: 1 + 1 + 1");
            #1;

            check_outputs(1, 1);
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
        input expected_carry;
        input expected_sum;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_carry === (expected_carry ^ carry ^ expected_carry) &&
                expected_sum === (expected_sum ^ sum ^ expected_sum)) begin
                $display("PASS");
                $display("  Outputs: carry=%b, sum=%b",
                         carry, sum);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: carry=%b, sum=%b",
                         expected_carry, expected_sum);
                $display("  Got:      carry=%b, sum=%b",
                         carry, sum);
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
