`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg clk;
    reg toggle_up;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .toggle_up(toggle_up)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Running Testcase 001: Initial Reset and Idle State");

            toggle_up = 0;
            repeat(2) @(posedge clk);
            #1;

            check_outputs();
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Running Testcase 002: Setting toggle_up High");

            toggle_up = 0;
            @(posedge clk);

            toggle_up = 1;
            repeat(3) @(posedge clk);
            #1;

            check_outputs();
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Running Testcase 003: Pulsing toggle_up");

            toggle_up = 0;
            @(posedge clk);

            toggle_up = 1;
            @(posedge clk);
            toggle_up = 0;
            @(posedge clk);
            #1;

            check_outputs();
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Running Testcase 004: Rapid Input Transitions");

            toggle_up = 0;
            @(posedge clk);

            toggle_up = 1;
            #2;
            toggle_up = 0;
            #2;
            toggle_up = 1;
            @(posedge clk);
            #1;

            check_outputs();
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
        begin
            #1; // Small delay for combinational logic to settle
            if () begin
                $display("PASS");
                $display("  Outputs: ",
                         );
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ",
                         );
                $display("  Got:      ",
                         );
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
