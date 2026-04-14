`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg clk_0_clk;
    reg clk_1_clk;
    reg reset_0_reset_n;
    reg reset_1_reset_n;
    wire clock_25_clk;
    wire clock_25_reset_reset_n;
    wire clock_27_clk_clk;
    wire clock_27_reset_reset_n;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk_0_clk(clk_0_clk),
        .clk_1_clk(clk_1_clk),
        .reset_0_reset_n(reset_0_reset_n),
        .reset_1_reset_n(reset_1_reset_n),
        .clock_25_clk(clock_25_clk),
        .clock_25_reset_reset_n(clock_25_reset_reset_n),
        .clock_27_clk_clk(clock_27_clk_clk),
        .clock_27_reset_reset_n(clock_27_reset_reset_n)
    );
    task testcase001;

        begin
            $display("Test Case 001: All signals set to low (Resets active)");
            reset_0_reset_n = 0;
            reset_1_reset_n = 0;
            clk_0_clk = 0;
            clk_1_clk = 0;
            #10;

            #1;


            check_outputs(0, 0, 0, 0);
        end
        endtask

    task testcase002;

        begin
            $display("Test Case 002: All signals set to high (Resets inactive)");
            reset_0_reset_n = 0;
            reset_1_reset_n = 0;
            #5;
            reset_0_reset_n = 1;
            reset_1_reset_n = 1;
            clk_0_clk = 1;
            clk_1_clk = 1;
            #10;
            #1;

            check_outputs(1, 1, 1, 1);
        end
        endtask

    task testcase003;

        begin
            $display("Test Case 003: 27MHz path active, 25MHz path in reset");
            reset_0_reset_n = 0;
            reset_1_reset_n = 0;
            #5;
            reset_0_reset_n = 1;
            reset_1_reset_n = 0;
            clk_0_clk = 1;
            clk_1_clk = 0;
            #10;

            #1;


            check_outputs(0, 0, 1, 1);
        end
        endtask

    task testcase004;

        begin
            $display("Test Case 004: 25MHz path active, 27MHz path in reset");
            reset_0_reset_n = 0;
            reset_1_reset_n = 0;
            #5;
            reset_0_reset_n = 0;
            reset_1_reset_n = 1;
            clk_0_clk = 0;
            clk_1_clk = 1;
            #10;

            #1;


            check_outputs(1, 1, 0, 0);
        end
        endtask

    task testcase005;

        begin
            $display("Test Case 005: Verify direct clock routing (Inverted phase)");
            reset_0_reset_n = 0;
            reset_1_reset_n = 0;
            #5;
            reset_0_reset_n = 1;
            reset_1_reset_n = 1;
            clk_0_clk = 0;
            clk_1_clk = 1;
            #10;

            #1;


            check_outputs(1, 1, 0, 1);
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
        input expected_clock_25_clk;
        input expected_clock_25_reset_reset_n;
        input expected_clock_27_clk_clk;
        input expected_clock_27_reset_reset_n;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_clock_25_clk === (expected_clock_25_clk ^ clock_25_clk ^ expected_clock_25_clk) &&
                expected_clock_25_reset_reset_n === (expected_clock_25_reset_reset_n ^ clock_25_reset_reset_n ^ expected_clock_25_reset_reset_n) &&
                expected_clock_27_clk_clk === (expected_clock_27_clk_clk ^ clock_27_clk_clk ^ expected_clock_27_clk_clk) &&
                expected_clock_27_reset_reset_n === (expected_clock_27_reset_reset_n ^ clock_27_reset_reset_n ^ expected_clock_27_reset_reset_n)) begin
                $display("PASS");
                $display("  Outputs: clock_25_clk=%b, clock_25_reset_reset_n=%b, clock_27_clk_clk=%b, clock_27_reset_reset_n=%b",
                         clock_25_clk, clock_25_reset_reset_n, clock_27_clk_clk, clock_27_reset_reset_n);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: clock_25_clk=%b, clock_25_reset_reset_n=%b, clock_27_clk_clk=%b, clock_27_reset_reset_n=%b",
                         expected_clock_25_clk, expected_clock_25_reset_reset_n, expected_clock_27_clk_clk, expected_clock_27_reset_reset_n);
                $display("  Got:      clock_25_clk=%b, clock_25_reset_reset_n=%b, clock_27_clk_clk=%b, clock_27_reset_reset_n=%b",
                         clock_25_clk, clock_25_reset_reset_n, clock_27_clk_clk, clock_27_reset_reset_n);
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
