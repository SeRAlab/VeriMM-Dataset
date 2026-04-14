`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg a0;
    reg a1;
    reg en;
    wire d0;
    wire d1;
    wire d2;
    wire d3;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a0(a0),
        .a1(a1),
        .en(en),
        .d0(d0),
        .d1(d1),
        .d2(d2),
        .d3(d3)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: en=0, a1=0, a0=0 (Disabled State)", test_num);
            en = 0; a1 = 0; a0 = 0;
            #1;

            check_outputs(0, 0, 0, 0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: en=0, a1=1, a0=1 (Disabled State, other inputs high)", test_num);
            en = 0; a1 = 1; a0 = 1;
            #1;

            check_outputs(0, 0, 0, 0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: en=1, a1=0, a0=0 (Select d0)", test_num);
            en = 1; a1 = 0; a0 = 0;
            #1;

            check_outputs(1, 0, 0, 0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: en=1, a1=0, a0=1 (Select d1)", test_num);
            en = 1; a1 = 0; a0 = 1;
            #1;

            check_outputs(0, 1, 0, 0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: en=1, a1=1, a0=0 (Select d2)", test_num);
            en = 1; a1 = 1; a0 = 0;
            #1;

            check_outputs(0, 0, 1, 0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: en=1, a1=1, a0=1 (Select d3)", test_num);
            en = 1; a1 = 1; a0 = 1;
            #1;

            check_outputs(0, 0, 0, 1);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test %0d: en=0 transition (Return to Disabled)", test_num);
            en = 0; a1 = 1; a0 = 0;
            #1;

            check_outputs(0, 0, 0, 0);
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
        input expected_d0;
        input expected_d1;
        input expected_d2;
        input expected_d3;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_d0 === (expected_d0 ^ d0 ^ expected_d0) &&
                expected_d1 === (expected_d1 ^ d1 ^ expected_d1) &&
                expected_d2 === (expected_d2 ^ d2 ^ expected_d2) &&
                expected_d3 === (expected_d3 ^ d3 ^ expected_d3)) begin
                $display("PASS");
                $display("  Outputs: d0=%b, d1=%b, d2=%b, d3=%b",
                         d0, d1, d2, d3);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: d0=%b, d1=%b, d2=%b, d3=%b",
                         expected_d0, expected_d1, expected_d2, expected_d3);
                $display("  Got:      d0=%b, d1=%b, d2=%b, d3=%b",
                         d0, d1, d2, d3);
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
