`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    wire [17:0] b;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .b(b)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case 001: Verify that output b is initialized to constant 123456");

            #1;


            check_outputs(18'd123456);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case 002: Verify that output b remains stable after a time delay");
            #100;
            #1;

            check_outputs(18'd123456);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case 003: Final stability check of the hardcoded vector");
            #500;
            #1;

            check_outputs(18'd123456);
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
        input [17:0] expected_b;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_b === (expected_b ^ b ^ expected_b)) begin
                $display("PASS");
                $display("  Outputs: b=%h",
                         b);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: b=%h",
                         expected_b);
                $display("  Got:      b=%h",
                         b);
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
