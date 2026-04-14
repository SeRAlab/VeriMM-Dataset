`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg a3;
    wire b3;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a3(a3),
        .b3(b3)
    );
    task testcase001;

        begin
            test_num = 1;
            a3 = 1'b0;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            a3 = 1'b1;
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
        input expected_b3;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_b3 === (expected_b3 ^ b3 ^ expected_b3)) begin
                $display("PASS");
                $display("  Outputs: b3=%b",
                         b3);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: b3=%b",
                         expected_b3);
                $display("  Got:      b3=%b",
                         b3);
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
