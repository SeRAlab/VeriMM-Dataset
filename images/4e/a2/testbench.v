`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg a;
    reg b;
    wire F0;
    wire F1;
    wire F2;
    wire F3;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .F0(F0),
        .F1(F1),
        .F2(F2),
        .F3(F3)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Input (a,b) = (0,0)", test_num);
        a = 1'b0;
        b = 1'b0;
        #1;

        check_outputs(1, 0, 0, 0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Input (a,b) = (0,1)", test_num);
        a = 1'b0;
        b = 1'b1;
        #1;

        check_outputs(0, 1, 0, 0);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Input (a,b) = (1,0)", test_num);
        a = 1'b1;
        b = 1'b0;
        #1;

        check_outputs(0, 0, 1, 0);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Input (a,b) = (1,1)", test_num);
        a = 1'b1;
        b = 1'b1;
        #1;

        check_outputs(0, 0, 0, 1);
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
        input expected_F0;
        input expected_F1;
        input expected_F2;
        input expected_F3;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_F0 === (expected_F0 ^ F0 ^ expected_F0) &&
                expected_F1 === (expected_F1 ^ F1 ^ expected_F1) &&
                expected_F2 === (expected_F2 ^ F2 ^ expected_F2) &&
                expected_F3 === (expected_F3 ^ F3 ^ expected_F3)) begin
                $display("PASS");
                $display("  Outputs: F0=%b, F1=%b, F2=%b, F3=%b",
                         F0, F1, F2, F3);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: F0=%b, F1=%b, F2=%b, F3=%b",
                         expected_F0, expected_F1, expected_F2, expected_F3);
                $display("  Got:      F0=%b, F1=%b, F2=%b, F3=%b",
                         F0, F1, F2, F3);
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
