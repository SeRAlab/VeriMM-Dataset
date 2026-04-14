`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    wire GND;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .GND(GND)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case 001: Initial check of GND output.");

            #1;


            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case 002: Check GND output after simulation delay.");

            #100;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case 003: Final stability check.");

            #500;
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
        input expected_GND;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_GND === (expected_GND ^ GND ^ expected_GND)) begin
                $display("PASS");
                $display("  Outputs: GND=%b",
                         GND);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: GND=%b",
                         expected_GND);
                $display("  Got:      GND=%b",
                         GND);
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
