`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg a__1;
    reg a__2;
    reg a__4;
    reg a__5;
    reg b__1;
    reg b__3;
    wire n__138;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a__1(a__1),
        .a__2(a__2),
        .a__4(a__4),
        .a__5(a__5),
        .b__1(b__1),
        .b__3(b__3),
        .n__138(n__138)
    );
    task testcase001;

        begin
            test_num = 1;
            a__1 = 0; a__2 = 0; a__4 = 0; a__5 = 0; b__1 = 0; b__3 = 0;
            $display("Testcase 001: All inputs low");
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            a__1 = 1; b__1 = 1; a__2 = 0; a__4 = 0; a__5 = 0; b__3 = 0;
            $display("Testcase 002: Pair (a1, b1) active");
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            a__1 = 0; b__1 = 0; a__2 = 1; b__3 = 1; a__4 = 0; a__5 = 0;
            $display("Testcase 003: Pair (a2, b3) active");
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            a__1 = 0; b__1 = 0; a__2 = 0; b__3 = 0; a__4 = 1; a__5 = 1;
            $display("Testcase 004: Pair (a4, a5) active");
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            a__1 = 1; a__2 = 1; a__4 = 1; a__5 = 1; b__1 = 1; b__3 = 1;
            $display("Testcase 005: All inputs high");
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            a__1 = 1; a__2 = 1; a__4 = 1; b__1 = 0; b__3 = 0; a__5 = 0;
            $display("Testcase 006: Mixed high inputs (a1, a2, a4) - no pairs");
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            a__1 = 0; a__2 = 0; a__4 = 0; b__1 = 1; b__3 = 1; a__5 = 1;
            $display("Testcase 007: Mixed high inputs (b1, b3, a5) - no pairs");
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            a__1 = 0; a__2 = 1; a__4 = 0; b__1 = 1; b__3 = 0; a__5 = 1;
            $display("Testcase 008: Individual mismatching bits");
            #1;

            check_outputs(1'b1);
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
        input expected_n__138;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_n__138 === (expected_n__138 ^ n__138 ^ expected_n__138)) begin
                $display("PASS");
                $display("  Outputs: n__138=%b",
                         n__138);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: n__138=%b",
                         expected_n__138);
                $display("  Got:      n__138=%b",
                         n__138);
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
