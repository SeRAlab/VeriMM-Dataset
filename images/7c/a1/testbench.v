`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg SW_0;
    reg SW_1;
    reg SW_2;
    reg SW_3;
    wire LED_0;
    wire LED_1;
    wire LED_2;
    wire LED_3;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .SW_0(SW_0),
        .SW_1(SW_1),
        .SW_2(SW_2),
        .SW_3(SW_3),
        .LED_0(LED_0),
        .LED_1(LED_1),
        .LED_2(LED_2),
        .LED_3(LED_3)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Test Case 001: All switches not pressed (1111)");
        SW_0 = 1; SW_1 = 1; SW_2 = 1; SW_3 = 1;
        #1;

        check_outputs(0, 0, 0, 0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test Case 002: All switches pressed (0000)");
        SW_0 = 0; SW_1 = 0; SW_2 = 0; SW_3 = 0;
        #1;

        check_outputs(1, 1, 1, 1);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test Case 003: SW_0=1, SW_1=0, SW_2=1, SW_3=0");
        SW_0 = 1; SW_1 = 0; SW_2 = 1; SW_3 = 0;
        #1;

        check_outputs(0, 1, 0, 1);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test Case 004: SW_0=0, SW_1=1, SW_2=0, SW_3=1");
        SW_0 = 0; SW_1 = 1; SW_2 = 0; SW_3 = 1;
        #1;

        check_outputs(1, 0, 1, 0);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test Case 005: SW_0 pressed only (0111)");
        SW_0 = 0; SW_1 = 1; SW_2 = 1; SW_3 = 1;
        #1;

        check_outputs(1, 0, 0, 0);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test Case 006: SW_3 pressed only (1110)");
        SW_0 = 1; SW_1 = 1; SW_2 = 1; SW_3 = 0;
        #1;

        check_outputs(0, 0, 0, 1);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Test Case 007: SW_1 and SW_2 pressed (1001)");
        SW_0 = 1; SW_1 = 0; SW_2 = 0; SW_3 = 1;
        #1;

        check_outputs(0, 1, 1, 0);
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
        input expected_LED_0;
        input expected_LED_1;
        input expected_LED_2;
        input expected_LED_3;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_LED_0 === (expected_LED_0 ^ LED_0 ^ expected_LED_0) &&
                expected_LED_1 === (expected_LED_1 ^ LED_1 ^ expected_LED_1) &&
                expected_LED_2 === (expected_LED_2 ^ LED_2 ^ expected_LED_2) &&
                expected_LED_3 === (expected_LED_3 ^ LED_3 ^ expected_LED_3)) begin
                $display("PASS");
                $display("  Outputs: LED_0=%b, LED_1=%b, LED_2=%b, LED_3=%b",
                         LED_0, LED_1, LED_2, LED_3);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: LED_0=%b, LED_1=%b, LED_2=%b, LED_3=%b",
                         expected_LED_0, expected_LED_1, expected_LED_2, expected_LED_3);
                $display("  Got:      LED_0=%b, LED_1=%b, LED_2=%b, LED_3=%b",
                         LED_0, LED_1, LED_2, LED_3);
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
