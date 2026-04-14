`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    wire clockSignal;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clockSignal(clockSignal)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case 001: Checking initial value at start of simulation");


            #1;



            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case 002: Checking value after first half-period toggle");

            #4;


            #1;



            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case 003: Checking value after second toggle (one full period)");

            #4;


            #1;



            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case 004: Checking value after third toggle");

            #4;


            #1;



            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case 005: Checking stability between toggles");


            #2;

            #1;


            check_outputs(1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test Case 006: Checking value after a longer duration (t=51)");



            #31;

            #1;


            check_outputs(1'b0);
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
        input expected_clockSignal;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_clockSignal === (expected_clockSignal ^ clockSignal ^ expected_clockSignal)) begin
                $display("PASS");
                $display("  Outputs: clockSignal=%b",
                         clockSignal);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: clockSignal=%b",
                         expected_clockSignal);
                $display("  Got:      clockSignal=%b",
                         clockSignal);
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
