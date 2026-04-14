`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg A;
    wire X;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .X(X)
    );
    task testcase001;

        begin
            $display("Test Case 001: Input A set to low (0)");
            test_num = test_num + 1;
            A = 0;
            #5;
            #1;

            check_outputs(0);
        end
        endtask

    task testcase002;

        begin
            $display("Test Case 002: Input A set to high (1)");
            test_num = test_num + 1;
            A = 1;
            #5;
            #1;

            check_outputs(1);
        end
        endtask

    task testcase003;

        begin
            $display("Test Case 003: Transition A from 1 to 0");
            test_num = test_num + 1;
            A = 1;
            #2;
            A = 0;
            #5;
            #1;

            check_outputs(0);
        end
        endtask

    task testcase004;

        begin
            $display("Test Case 004: Transition A from 0 to 1");
            test_num = test_num + 1;
            A = 0;
            #2;
            A = 1;
            #5;
            #1;

            check_outputs(1);
        end
        endtask

    task testcase005;

        begin
            $display("Test Case 005: Rapid toggling, end at low (0)");
            test_num = test_num + 1;
            A = 0; #1;
            A = 1; #1;
            A = 0; #1;
            A = 1; #1;
            A = 0;
            #5;
            #1;

            check_outputs(0);
        end
        endtask

    task testcase006;

        begin
            $display("Test Case 006: Rapid toggling, end at high (1)");
            test_num = test_num + 1;
            A = 1; #1;
            A = 0; #1;
            A = 1; #1;
            A = 0; #1;
            A = 1;
            #5;
            #1;

            check_outputs(1);
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
        input expected_X;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_X === (expected_X ^ X ^ expected_X)) begin
                $display("PASS");
                $display("  Outputs: X=%b",
                         X);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: X=%b",
                         expected_X);
                $display("  Got:      X=%b",
                         X);
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
