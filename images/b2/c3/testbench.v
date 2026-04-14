`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg IN_RST;
    wire OUT_RST;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .IN_RST(IN_RST),
        .OUT_RST(OUT_RST)
    );
    task testcase001;

        begin
            $display("Test Case 001: Set IN_RST to 0");
            IN_RST = 0;
            #10;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            $display("Test Case 002: Set IN_RST to 1");
            IN_RST = 1;
            #10;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            $display("Test Case 003: Toggle IN_RST (1 -> 0)");
            IN_RST = 1;
            #5;
            IN_RST = 0;
            #10;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            $display("Test Case 004: Toggle IN_RST (0 -> 1)");
            IN_RST = 0;
            #5;
            IN_RST = 1;
            #10;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            $display("Test Case 005: Rapid toggling sequence ending in 0");
            IN_RST = 0; #2;
            IN_RST = 1; #2;
            IN_RST = 0; #2;
            IN_RST = 1; #2;
            IN_RST = 0;
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
        input expected_OUT_RST;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_OUT_RST === (expected_OUT_RST ^ OUT_RST ^ expected_OUT_RST)) begin
                $display("PASS");
                $display("  Outputs: OUT_RST=%b",
                         OUT_RST);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: OUT_RST=%b",
                         expected_OUT_RST);
                $display("  Got:      OUT_RST=%b",
                         OUT_RST);
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
