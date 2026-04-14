`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg ID_EXInstall;
    reg IF_IDInstall;
    wire EX_MEMClear;
    wire ID_EXClear;
    wire ID_EXEnable;
    wire IF_IDEnable;
    wire PCEnable;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ID_EXInstall(ID_EXInstall),
        .IF_IDInstall(IF_IDInstall),
        .EX_MEMClear(EX_MEMClear),
        .ID_EXClear(ID_EXClear),
        .ID_EXEnable(ID_EXEnable),
        .IF_IDEnable(IF_IDEnable),
        .PCEnable(PCEnable)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Test Case %0d: Normal Operation (No install signals)", test_num);
        IF_IDInstall = 0;
        ID_EXInstall = 0;

        #1;


        check_outputs(0, 0, 1, 1, 1);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test Case %0d: IF_IDInstall Active", test_num);
        IF_IDInstall = 1;
        ID_EXInstall = 0;





        #1;






        check_outputs(0, 1, 1, 0, 0);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test Case %0d: ID_EXInstall Active", test_num);
        IF_IDInstall = 0;
        ID_EXInstall = 1;




        #1;





        check_outputs(1, 0, 0, 1, 1);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test Case %0d: Both Install Signals Active", test_num);
        IF_IDInstall = 1;
        ID_EXInstall = 1;




        #1;





        check_outputs(1, 1, 0, 0, 0);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test Case %0d: Transition back to Normal Operation", test_num);
        IF_IDInstall = 0;
        ID_EXInstall = 0;


        #1;



        check_outputs(0, 0, 1, 1, 1);
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
        input expected_EX_MEMClear;
        input expected_ID_EXClear;
        input expected_ID_EXEnable;
        input expected_IF_IDEnable;
        input expected_PCEnable;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_EX_MEMClear === (expected_EX_MEMClear ^ EX_MEMClear ^ expected_EX_MEMClear) &&
                expected_ID_EXClear === (expected_ID_EXClear ^ ID_EXClear ^ expected_ID_EXClear) &&
                expected_ID_EXEnable === (expected_ID_EXEnable ^ ID_EXEnable ^ expected_ID_EXEnable) &&
                expected_IF_IDEnable === (expected_IF_IDEnable ^ IF_IDEnable ^ expected_IF_IDEnable) &&
                expected_PCEnable === (expected_PCEnable ^ PCEnable ^ expected_PCEnable)) begin
                $display("PASS");
                $display("  Outputs: EX_MEMClear=%b, ID_EXClear=%b, ID_EXEnable=%b, IF_IDEnable=%b, PCEnable=%b",
                         EX_MEMClear, ID_EXClear, ID_EXEnable, IF_IDEnable, PCEnable);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: EX_MEMClear=%b, ID_EXClear=%b, ID_EXEnable=%b, IF_IDEnable=%b, PCEnable=%b",
                         expected_EX_MEMClear, expected_ID_EXClear, expected_ID_EXEnable, expected_IF_IDEnable, expected_PCEnable);
                $display("  Got:      EX_MEMClear=%b, ID_EXClear=%b, ID_EXEnable=%b, IF_IDEnable=%b, PCEnable=%b",
                         EX_MEMClear, ID_EXClear, ID_EXEnable, IF_IDEnable, PCEnable);
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
