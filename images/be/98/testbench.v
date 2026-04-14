`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    wire [19:0] Phase_Voltages_0;
    wire [19:0] Phase_Voltages_1;
    wire [19:0] Phase_Voltages_2;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .Phase_Voltages_0(Phase_Voltages_0),
        .Phase_Voltages_1(Phase_Voltages_1),
        .Phase_Voltages_2(Phase_Voltages_2)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Test Case 001: Verifying initial standby phase voltages are zero");

        #1;


        check_outputs(20'sd0, 20'sd0, 20'sd0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test Case 002: Verifying voltages remain zero after a short delay");
        #50;
        #1;

        check_outputs(20'sh00000, 20'sh00000, 20'sh00000);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test Case 003: Verifying voltages remain zero after a long delay");
        #500;
        #1;

        check_outputs(20'sh0, 20'sh0, 20'sh0);
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
        input [19:0] expected_Phase_Voltages_0;
        input [19:0] expected_Phase_Voltages_1;
        input [19:0] expected_Phase_Voltages_2;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Phase_Voltages_0 === (expected_Phase_Voltages_0 ^ Phase_Voltages_0 ^ expected_Phase_Voltages_0) &&
                expected_Phase_Voltages_1 === (expected_Phase_Voltages_1 ^ Phase_Voltages_1 ^ expected_Phase_Voltages_1) &&
                expected_Phase_Voltages_2 === (expected_Phase_Voltages_2 ^ Phase_Voltages_2 ^ expected_Phase_Voltages_2)) begin
                $display("PASS");
                $display("  Outputs: Phase_Voltages_0=%h, Phase_Voltages_1=%h, Phase_Voltages_2=%h",
                         Phase_Voltages_0, Phase_Voltages_1, Phase_Voltages_2);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Phase_Voltages_0=%h, Phase_Voltages_1=%h, Phase_Voltages_2=%h",
                         expected_Phase_Voltages_0, expected_Phase_Voltages_1, expected_Phase_Voltages_2);
                $display("  Got:      Phase_Voltages_0=%h, Phase_Voltages_1=%h, Phase_Voltages_2=%h",
                         Phase_Voltages_0, Phase_Voltages_1, Phase_Voltages_2);
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
