`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg cond;
    reg rst;
    wire rel;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .cond(cond),
        .rst(rst),
        .rel(rel)
    );
    task testcase001;

        begin
            $display("Testcase 001: Reset Activated, Condition Low");
            rst = 1'b1;
            cond = 1'b0;
            #10;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Reset Activated, Condition High (Priority Check)");
            rst = 1'b1;
            cond = 1'b1;
            #10;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Reset Inactive, Condition High (Release Check)");

            rst = 1'b1;
            cond = 1'b0;
            #5;

            rst = 1'b0;
            cond = 1'b1;
            #10;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Reset Inactive, Condition Low");

            rst = 1'b1;
            cond = 1'b1;
            #5;

            rst = 1'b0;
            cond = 1'b0;
            #10;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Immediate Reset during Active Release");

            rst = 1'b1;
            #5;

            rst = 1'b0;
            cond = 1'b1;
            #5;

            rst = 1'b1;
            #10;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: Conditional Release Transition");

            rst = 1'b1;
            #5;

            rst = 1'b0;
            cond = 1'b0;
            #5;
            cond = 1'b1;
            #10;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase007;

        begin
            $display("Testcase 007: Condition toggle while Reset is Active");

            rst = 1'b1;
            cond = 1'b1;
            #5;
            cond = 1'b0;
            #5;
            cond = 1'b1;
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
        testcase006();
        testcase007();
        
        
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
        input expected_rel;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_rel === (expected_rel ^ rel ^ expected_rel)) begin
                $display("PASS");
                $display("  Outputs: rel=%b",
                         rel);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: rel=%b",
                         expected_rel);
                $display("  Got:      rel=%b",
                         rel);
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
