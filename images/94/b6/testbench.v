`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg DATA0X0;
    reg DATA1X0;
    wire RESULT0;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .DATA0X0(DATA0X0),
        .DATA1X0(DATA1X0),
        .RESULT0(RESULT0)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Inputs DATA0X0=0, DATA1X0=0", test_num);
            DATA0X0 = 1'b0;
            DATA1X0 = 1'b0;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Inputs DATA0X0=0, DATA1X0=1", test_num);
            DATA0X0 = 1'b0;
            DATA1X0 = 1'b1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Inputs DATA0X0=1, DATA1X0=0", test_num);
            DATA0X0 = 1'b1;
            DATA1X0 = 1'b0;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Inputs DATA0X0=1, DATA1X0=1", test_num);
            DATA0X0 = 1'b1;
            DATA1X0 = 1'b1;
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
        input expected_RESULT0;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_RESULT0 === (expected_RESULT0 ^ RESULT0 ^ expected_RESULT0)) begin
                $display("PASS");
                $display("  Outputs: RESULT0=%b",
                         RESULT0);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: RESULT0=%b",
                         expected_RESULT0);
                $display("  Got:      RESULT0=%b",
                         RESULT0);
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
