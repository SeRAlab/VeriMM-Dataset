`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg a;
    reg b;
    reg c;
    wire f1;
    wire f2;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .c(c),
        .f1(f1),
        .f2(f2)
    );
    task run_test;

        input reg_a;
        input reg_b;
        input reg_c;
        input exp_f1;
        input exp_f2;
        input [511:0] desc;
        begin
            test_num = test_num + 1;
            $display("--- Testcase %0d: %s ---", test_num, desc);
            a = reg_a;
            b = reg_b;
            c = reg_c;
            #10;
            #1;

            check_outputs(exp_f1, exp_f2);
        end
        endtask

    task testcase001;

        begin
            run_test(1'b1, 1'b1, 1'b0, 1'b0, 1'b0, "Initialization: a=1, b=1 -> f1=0, f2=0");
        end
        endtask

    task testcase002;

        begin
            run_test(1'b0, 1'b0, 1'b0, 1'b1, 1'b1, "Toggle: a=0, b=0 -> f1=1, f2 toggles to 1");
        end
        endtask

    task testcase003;

        begin
            run_test(1'b0, 1'b1, 1'b1, 1'b0, 1'b1, "Hold: a=0, b=1 -> f1=0, f2 stays 1");
        end
        endtask

    task testcase004;

        begin
            run_test(1'b0, 1'b0, 1'b0, 1'b1, 1'b0, "Toggle: a=0, b=0 -> f1=1, f2 toggles to 0");
        end
        endtask

    task testcase005;

        begin
            run_test(1'b1, 1'b0, 1'b1, 1'b0, 1'b0, "Hold & C-check: a=1, b=0, c=1 -> f1=0, f2 stays 0");
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
        input expected_f1;
        input expected_f2;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_f1 === (expected_f1 ^ f1 ^ expected_f1) &&
                expected_f2 === (expected_f2 ^ f2 ^ expected_f2)) begin
                $display("PASS");
                $display("  Outputs: f1=%b, f2=%b",
                         f1, f2);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: f1=%b, f2=%b",
                         expected_f1, expected_f2);
                $display("  Got:      f1=%b, f2=%b",
                         f1, f2);
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
