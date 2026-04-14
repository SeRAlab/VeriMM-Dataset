`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg x;
    reg y;
    wire n;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .x(x),
        .y(y),
        .n(n)
    );
    task testcase001;

        begin
            $display("Running Testcase 001: x=0, y=0");
            x = 1'b0;
            y = 1'b0;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            $display("Running Testcase 002: x=0, y=1");
            x = 1'b0;
            y = 1'b1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            $display("Running Testcase 003: x=1, y=0");
            x = 1'b1;
            y = 1'b0;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            $display("Running Testcase 004: x=1, y=1");
            x = 1'b1;
            y = 1'b1;
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
        input expected_n;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_n === (expected_n ^ n ^ expected_n)) begin
                $display("PASS");
                $display("  Outputs: n=%b",
                         n);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: n=%b",
                         expected_n);
                $display("  Got:      n=%b",
                         n);
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
