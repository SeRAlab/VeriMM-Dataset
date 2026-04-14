`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    wire [7:0] reg_0x03;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .reg_0x03(reg_0x03)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("\n[Test Case 001] Checking initial constant assignment...");

            #1;


            check_outputs(8'h03);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\n[Test Case 002] Checking output stability over time...");
            #50;
            #1;

            check_outputs(8'h03);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\n[Test Case 003] Final verification check...");
            #100;
            #1;

            check_outputs(8'h03);
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
        input [7:0] expected_reg_0x03;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_reg_0x03 === (expected_reg_0x03 ^ reg_0x03 ^ expected_reg_0x03)) begin
                $display("PASS");
                $display("  Outputs: reg_0x03=%h",
                         reg_0x03);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: reg_0x03=%h",
                         expected_reg_0x03);
                $display("  Got:      reg_0x03=%h",
                         reg_0x03);
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
