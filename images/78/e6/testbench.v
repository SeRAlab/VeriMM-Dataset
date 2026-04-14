`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg pulldown0;
    reg pullup0;
    wire HI;
    wire LO;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .pulldown0(pulldown0),
        .pullup0(pullup0),
        .HI(HI),
        .LO(LO)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case 001: pullup0=0, pulldown0=0 (Idle)");
            pullup0 = 1'b0; pulldown0 = 1'b0;
            #10;

            #1;


            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case 002: pullup0=1, pulldown0=0 (HI Asserted)");
            pullup0 = 1'b1; pulldown0 = 1'b0;
            #10;

            #1;


            check_outputs(1'b1, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case 003: pullup0=0, pulldown0=1 (LO Asserted)");
            pullup0 = 1'b0; pulldown0 = 1'b1;
            #10;

            #1;


            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case 004: pullup0=1, pulldown0=1 (Both High)");
            pullup0 = 1'b1; pulldown0 = 1'b1;
            #10;

            #1;


            check_outputs(1'b0, 1'b1);
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
        input expected_HI;
        input expected_LO;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_HI === (expected_HI ^ HI ^ expected_HI) &&
                expected_LO === (expected_LO ^ LO ^ expected_LO)) begin
                $display("PASS");
                $display("  Outputs: HI=%b, LO=%b",
                         HI, LO);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: HI=%b, LO=%b",
                         expected_HI, expected_LO);
                $display("  Got:      HI=%b, LO=%b",
                         HI, LO);
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
