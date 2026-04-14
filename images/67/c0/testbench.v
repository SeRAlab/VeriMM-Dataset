`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg ref_signal;
    reg threshold;
    reg touch_signal;
    wire touch_detected;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ref_signal(ref_signal),
        .threshold(threshold),
        .touch_signal(touch_signal),
        .touch_detected(touch_detected)
    );
    task testcase001;

        begin
            test_num = 1;
            touch_signal = 1;
            ref_signal   = 0;
            threshold    = 0;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            touch_signal = 1;
            ref_signal   = 0;
            threshold    = 1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            touch_signal = 1;
            ref_signal   = 1;
            threshold    = 0;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            touch_signal = 0;
            ref_signal   = 0;
            threshold    = 0;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            touch_signal = 0;
            ref_signal   = 1;
            threshold    = 0;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            touch_signal = 1;
            ref_signal   = 1;
            threshold    = 1;
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
        input expected_touch_detected;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_touch_detected === (expected_touch_detected ^ touch_detected ^ expected_touch_detected)) begin
                $display("PASS");
                $display("  Outputs: touch_detected=%b",
                         touch_detected);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: touch_detected=%b",
                         expected_touch_detected);
                $display("  Got:      touch_detected=%b",
                         touch_detected);
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
