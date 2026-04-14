`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    wire LED0;
    wire LED1;
    wire LED2;
    wire LED3;
    wire LED4;
    wire LED5;
    wire LED6;
    wire LED7;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .LED0(LED0),
        .LED1(LED1),
        .LED2(LED2),
        .LED3(LED3),
        .LED4(LED4),
        .LED5(LED5),
        .LED6(LED6),
        .LED7(LED7)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Verifying all LEDs are initially high", test_num);
            #1;

            check_outputs(1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Verifying LEDs remain high after 10ns", test_num);
            #10;
            #1;

            check_outputs(1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1);
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
        input expected_LED0;
        input expected_LED1;
        input expected_LED2;
        input expected_LED3;
        input expected_LED4;
        input expected_LED5;
        input expected_LED6;
        input expected_LED7;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_LED0 === (expected_LED0 ^ LED0 ^ expected_LED0) &&
                expected_LED1 === (expected_LED1 ^ LED1 ^ expected_LED1) &&
                expected_LED2 === (expected_LED2 ^ LED2 ^ expected_LED2) &&
                expected_LED3 === (expected_LED3 ^ LED3 ^ expected_LED3) &&
                expected_LED4 === (expected_LED4 ^ LED4 ^ expected_LED4) &&
                expected_LED5 === (expected_LED5 ^ LED5 ^ expected_LED5) &&
                expected_LED6 === (expected_LED6 ^ LED6 ^ expected_LED6) &&
                expected_LED7 === (expected_LED7 ^ LED7 ^ expected_LED7)) begin
                $display("PASS");
                $display("  Outputs: LED0=%b, LED1=%b, LED2=%b, LED3=%b, LED4=%b, LED5=%b, LED6=%b, LED7=%b",
                         LED0, LED1, LED2, LED3, LED4, LED5, LED6, LED7);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: LED0=%b, LED1=%b, LED2=%b, LED3=%b, LED4=%b, LED5=%b, LED6=%b, LED7=%b",
                         expected_LED0, expected_LED1, expected_LED2, expected_LED3, expected_LED4, expected_LED5, expected_LED6, expected_LED7);
                $display("  Got:      LED0=%b, LED1=%b, LED2=%b, LED3=%b, LED4=%b, LED5=%b, LED6=%b, LED7=%b",
                         LED0, LED1, LED2, LED3, LED4, LED5, LED6, LED7);
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
