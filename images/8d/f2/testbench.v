`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg RESET_IN;
    wire RESET_OUT;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .RESET_IN(RESET_IN),
        .RESET_OUT(RESET_OUT)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: RESET_IN = 0", test_num);
            RESET_IN = 1'b0;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: RESET_IN = 1", test_num);
            RESET_IN = 1'b1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Transition 1 -> 0", test_num);
            RESET_IN = 1'b1;
            #5;
            RESET_IN = 1'b0;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Transition 0 -> 1", test_num);
            RESET_IN = 1'b0;
            #5;
            RESET_IN = 1'b1;
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
        input expected_RESET_OUT;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_RESET_OUT === (expected_RESET_OUT ^ RESET_OUT ^ expected_RESET_OUT)) begin
                $display("PASS");
                $display("  Outputs: RESET_OUT=%b",
                         RESET_OUT);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: RESET_OUT=%b",
                         expected_RESET_OUT);
                $display("  Got:      RESET_OUT=%b",
                         RESET_OUT);
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
