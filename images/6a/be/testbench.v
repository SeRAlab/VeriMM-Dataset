`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg wA;
    reg wB;
    reg wCi;
    wire wCo;
    wire wR;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .wA(wA),
        .wB(wB),
        .wCi(wCi),
        .wCo(wCo),
        .wR(wR)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All inputs zero (0+0+0)", test_num);
            wA = 1'b0; wB = 1'b0; wCi = 1'b0;
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Carry-in only (0+0+1)", test_num);
            wA = 1'b0; wB = 1'b0; wCi = 1'b1;
            #1;

            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Input B only (0+1+0)", test_num);
            wA = 1'b0; wB = 1'b1; wCi = 1'b0;
            #1;

            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Input B and Carry-in (0+1+1)", test_num);
            wA = 1'b0; wB = 1'b1; wCi = 1'b1;
            #1;

            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Input A only (1+0+0)", test_num);
            wA = 1'b1; wB = 1'b0; wCi = 1'b0;
            #1;

            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Input A and Carry-in (1+0+1)", test_num);
            wA = 1'b1; wB = 1'b0; wCi = 1'b1;
            #1;

            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Inputs A and B (1+1+0)", test_num);
            wA = 1'b1; wB = 1'b1; wCi = 1'b0;
            #1;

            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All inputs high (1+1+1)", test_num);
            wA = 1'b1; wB = 1'b1; wCi = 1'b1;
            #1;

            check_outputs(1'b1, 1'b1);
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
        input expected_wCo;
        input expected_wR;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_wCo === (expected_wCo ^ wCo ^ expected_wCo) &&
                expected_wR === (expected_wR ^ wR ^ expected_wR)) begin
                $display("PASS");
                $display("  Outputs: wCo=%b, wR=%b",
                         wCo, wR);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: wCo=%b, wR=%b",
                         expected_wCo, expected_wR);
                $display("  Got:      wCo=%b, wR=%b",
                         wCo, wR);
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
