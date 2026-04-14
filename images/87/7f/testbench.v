`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    wire not_used;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .not_used(not_used)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %03d: Initial state check", test_num);

        #1;


        check_outputs(1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %03d: Check output after delay", test_num);
        #50;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %03d: Stability check over longer duration", test_num);
        #200;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %03d: Final check before finishing", test_num);
        #1000;
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
        input expected_not_used;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_not_used === (expected_not_used ^ not_used ^ expected_not_used)) begin
                $display("PASS");
                $display("  Outputs: not_used=%b",
                         not_used);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: not_used=%b",
                         expected_not_used);
                $display("  Got:      not_used=%b",
                         not_used);
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
