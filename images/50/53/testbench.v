`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    wire id0;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .id0(id0)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Initial check for constant LOW signal", test_num);

            #1;


            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Verify signal remains LOW after time delay", test_num);
            #50;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Final verification of constant LOW", test_num);
            #100;
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
        input expected_id0;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_id0 === (expected_id0 ^ id0 ^ expected_id0)) begin
                $display("PASS");
                $display("  Outputs: id0=%b",
                         id0);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: id0=%b",
                         expected_id0);
                $display("  Got:      id0=%b",
                         id0);
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
