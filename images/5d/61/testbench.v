`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg e;
    reg f;
    reg g;
    reg h;
    wire q_pos;
    wire q_sop;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .e(e),
        .f(f),
        .g(g),
        .h(h),
        .q_pos(q_pos),
        .q_sop(q_sop)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case 001: Input 0 (0000) - Expected Output: 1");
            e = 0; f = 0; g = 0; h = 0;
            #1;

            check_outputs(1'b1, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case 002: Input 8 (1000) - Expected Output: 1");
            e = 1; f = 0; g = 0; h = 0;
            #1;

            check_outputs(1'b1, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case 003: Input 10 (1010) - Expected Output: 1");
            e = 1; f = 0; g = 1; h = 0;
            #1;

            check_outputs(1'b1, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case 004: Input 12 (1100) - Expected Output: 1");
            e = 1; f = 1; g = 0; h = 0;
            #1;

            check_outputs(1'b1, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case 005: Input 1 (0001) - Expected Output: 0");
            e = 0; f = 0; g = 0; h = 1;
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test Case 006: Input 2 (0010) - Expected Output: 0");
            e = 0; f = 0; g = 1; h = 0;
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test Case 007: Input 3 (0011) - Expected Output: 0");
            e = 0; f = 0; g = 1; h = 1;
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Test Case 008: Input 4 (0100) - Expected Output: 0");
            e = 0; f = 1; g = 0; h = 0;
            #1;

            check_outputs(1'b0, 1'b0);
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
        input expected_q_pos;
        input expected_q_sop;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_q_pos === (expected_q_pos ^ q_pos ^ expected_q_pos) &&
                expected_q_sop === (expected_q_sop ^ q_sop ^ expected_q_sop)) begin
                $display("PASS");
                $display("  Outputs: q_pos=%b, q_sop=%b",
                         q_pos, q_sop);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: q_pos=%b, q_sop=%b",
                         expected_q_pos, expected_q_sop);
                $display("  Got:      q_pos=%b, q_sop=%b",
                         q_pos, q_sop);
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
