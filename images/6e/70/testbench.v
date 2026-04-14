`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg A;
    reg SLEEP;
    wire X;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .SLEEP(SLEEP),
        .X(X)
    );
    task testcase001;

        begin
            $display("Testcase 001: Active mode (SLEEP=0), A=0");
            A = 1'b0;
            SLEEP = 1'b0;
            #10;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Active mode (SLEEP=0), A=1");
            A = 1'b1;
            SLEEP = 1'b0;
            #10;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Sleep mode (SLEEP=1), A=0");
            A = 1'b0;
            SLEEP = 1'b1;
            #10;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Sleep mode (SLEEP=1), A=1 - Output must be isolated (low)");
            A = 1'b1;
            SLEEP = 1'b1;
            #10;
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
        input expected_X;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_X === (expected_X ^ X ^ expected_X)) begin
                $display("PASS");
                $display("  Outputs: X=%b",
                         X);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: X=%b",
                         expected_X);
                $display("  Got:      X=%b",
                         X);
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
