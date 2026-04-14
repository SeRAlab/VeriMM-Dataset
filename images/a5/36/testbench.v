`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    wire [7:0] reg_0x02;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .reg_0x02(reg_0x02)
    );
    task testcase001;

        begin
            $display("\nTestcase 001: Checking if reg_0x02 is 0x00");


            #1;



            check_outputs(8'h00);
        end
        endtask

    task testcase002;

        begin
            $display("\nTestcase 002: Checking stability of reg_0x02 over time");

            #50;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase003;

        begin
            $display("\nTestcase 003: Final validation check");
            #100;
            #1;

            check_outputs(8'h00);
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
        input [7:0] expected_reg_0x02;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_reg_0x02 === (expected_reg_0x02 ^ reg_0x02 ^ expected_reg_0x02)) begin
                $display("PASS");
                $display("  Outputs: reg_0x02=%h",
                         reg_0x02);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: reg_0x02=%h",
                         expected_reg_0x02);
                $display("  Got:      reg_0x02=%h",
                         reg_0x02);
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
