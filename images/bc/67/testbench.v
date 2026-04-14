`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg hard_reset;
    reg soft_reset;
    wire chip_resetb;
    wire reset;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .hard_reset(hard_reset),
        .soft_reset(soft_reset),
        .chip_resetb(chip_resetb),
        .reset(reset)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("\nTestcase %0d: No reset active", test_num);
            hard_reset = 0;
            soft_reset = 0;

            #1;


            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTestcase %0d: Hard reset only", test_num);
            hard_reset = 1;
            soft_reset = 0;

            #1;


            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTestcase %0d: Soft reset only", test_num);
            hard_reset = 0;
            soft_reset = 1;

            #1;


            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTestcase %0d: Both hard and soft reset active", test_num);
            hard_reset = 1;
            soft_reset = 1;

            #1;


            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nTestcase %0d: Transition from reset to no reset", test_num);
            hard_reset = 1;
            soft_reset = 1;
            #10;
            hard_reset = 0;
            soft_reset = 0;

            #1;


            check_outputs(1'b1, 1'b0);
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
        input expected_chip_resetb;
        input expected_reset;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_chip_resetb === (expected_chip_resetb ^ chip_resetb ^ expected_chip_resetb) &&
                expected_reset === (expected_reset ^ reset ^ expected_reset)) begin
                $display("PASS");
                $display("  Outputs: chip_resetb=%b, reset=%b",
                         chip_resetb, reset);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: chip_resetb=%b, reset=%b",
                         expected_chip_resetb, expected_reset);
                $display("  Got:      chip_resetb=%b, reset=%b",
                         chip_resetb, reset);
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
