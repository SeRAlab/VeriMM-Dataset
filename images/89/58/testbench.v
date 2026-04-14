`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg A;
    reg B;
    reg C;
    reg CI;
    reg D0;
    reg D1;
    wire CO;
    wire SO;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .C(C),
        .CI(CI),
        .D0(D0),
        .D1(D1),
        .CO(CO),
        .SO(SO)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: All Zeros", test_num);
        A = 0; B = 0; C = 0; CI = 0; D0 = 0; D1 = 0;
        #1;

        check_outputs(1'b0, 1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Carry-In only", test_num);
        A = 0; B = 0; C = 0; CI = 1; D0 = 0; D1 = 0;
        #1;

        check_outputs(1'b0, 1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Input A only", test_num);
        A = 1; B = 0; C = 0; CI = 0; D0 = 0; D1 = 0;
        #1;

        check_outputs(1'b0, 1'b1);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Inputs A and B (Carry Gen)", test_num);
        A = 1; B = 1; C = 0; CI = 0; D0 = 0; D1 = 0;
        #1;

        check_outputs(1'b1, 1'b0);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: A, B, and Carry-In (Max Value)", test_num);
        A = 1; B = 1; C = 0; CI = 1; D0 = 0; D1 = 0;
        #1;

        check_outputs(1'b1, 1'b1);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: B and Carry-In", test_num);
        A = 0; B = 1; C = 0; CI = 1; D0 = 0; D1 = 0;
        #1;

        check_outputs(1'b1, 1'b0);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Testing Aux Inputs C, D0, D1", test_num);
        A = 1; B = 0; C = 1; CI = 1; D0 = 1; D1 = 1;
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
        input expected_CO;
        input expected_SO;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_CO === (expected_CO ^ CO ^ expected_CO) &&
                expected_SO === (expected_SO ^ SO ^ expected_SO)) begin
                $display("PASS");
                $display("  Outputs: CO=%b, SO=%b",
                         CO, SO);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: CO=%b, SO=%b",
                         expected_CO, expected_SO);
                $display("  Got:      CO=%b, SO=%b",
                         CO, SO);
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
