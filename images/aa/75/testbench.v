`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg USER_SIGNAL_TO_GLOBAL_BUFFER;
    wire GLOBAL_BUFFER_OUTPUT;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .USER_SIGNAL_TO_GLOBAL_BUFFER(USER_SIGNAL_TO_GLOBAL_BUFFER),
        .GLOBAL_BUFFER_OUTPUT(GLOBAL_BUFFER_OUTPUT)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case 001: Drive input to 0");
            USER_SIGNAL_TO_GLOBAL_BUFFER = 1'b0;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case 002: Drive input to 1");
            USER_SIGNAL_TO_GLOBAL_BUFFER = 1'b1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case 003: Toggle input back to 0");
            USER_SIGNAL_TO_GLOBAL_BUFFER = 1'b0;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case 004: Drive input to 1 again");
            USER_SIGNAL_TO_GLOBAL_BUFFER = 1'b1;
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
        input expected_GLOBAL_BUFFER_OUTPUT;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_GLOBAL_BUFFER_OUTPUT === (expected_GLOBAL_BUFFER_OUTPUT ^ GLOBAL_BUFFER_OUTPUT ^ expected_GLOBAL_BUFFER_OUTPUT)) begin
                $display("PASS");
                $display("  Outputs: GLOBAL_BUFFER_OUTPUT=%b",
                         GLOBAL_BUFFER_OUTPUT);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: GLOBAL_BUFFER_OUTPUT=%b",
                         expected_GLOBAL_BUFFER_OUTPUT);
                $display("  Got:      GLOBAL_BUFFER_OUTPUT=%b",
                         GLOBAL_BUFFER_OUTPUT);
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
