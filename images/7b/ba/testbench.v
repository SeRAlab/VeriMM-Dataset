`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg dirin;
    wire DIR;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .dirin(dirin),
        .DIR(DIR)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: dirin = 0", test_num);
            dirin = 1'b0;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: dirin = 1", test_num);
            dirin = 1'b1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Toggle from 1 to 0", test_num);
            dirin = 1'b1;
            #10;
            dirin = 1'b0;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Toggle from 0 to 1", test_num);
            dirin = 1'b0;
            #10;
            dirin = 1'b1;
            #1;

            check_outputs(1'b1);
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
        input expected_DIR;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_DIR === (expected_DIR ^ DIR ^ expected_DIR)) begin
                $display("PASS");
                $display("  Outputs: DIR=%b",
                         DIR);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: DIR=%b",
                         expected_DIR);
                $display("  Got:      DIR=%b",
                         DIR);
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
