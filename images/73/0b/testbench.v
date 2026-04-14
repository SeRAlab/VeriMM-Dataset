`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] ledIn;
    wire ledGreen;
    wire ledRed;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ledIn(ledIn),
        .ledGreen(ledGreen),
        .ledRed(ledRed)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test %0d: ledIn = 15 (Binary 1111)", test_num);
        ledIn = 4'b1111;
        #1;

        check_outputs(1'b1, 1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test %0d: ledIn = 0 (Binary 0000)", test_num);
        ledIn = 4'b0000;
        #1;

        check_outputs(1'b0, 1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test %0d: ledIn = 14 (Binary 1110)", test_num);
        ledIn = 4'b1110;
        #1;

        check_outputs(1'b0, 1'b1);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test %0d: ledIn = 7 (Binary 0111)", test_num);
        ledIn = 4'b0111;
        #1;

        check_outputs(1'b0, 1'b1);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test %0d: ledIn = 8 (Binary 1000)", test_num);
        ledIn = 4'b1000;
        #1;

        check_outputs(1'b0, 1'b1);
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
        input expected_ledGreen;
        input expected_ledRed;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_ledGreen === (expected_ledGreen ^ ledGreen ^ expected_ledGreen) &&
                expected_ledRed === (expected_ledRed ^ ledRed ^ expected_ledRed)) begin
                $display("PASS");
                $display("  Outputs: ledGreen=%b, ledRed=%b",
                         ledGreen, ledRed);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ledGreen=%b, ledRed=%b",
                         expected_ledGreen, expected_ledRed);
                $display("  Got:      ledGreen=%b, ledRed=%b",
                         ledGreen, ledRed);
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
