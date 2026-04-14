`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    wire [7:0] as;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .as(as)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Checking constant sum calculation...", test_num);



        #1;




        check_outputs(8'h02);
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
        input [7:0] expected_as;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_as === (expected_as ^ as ^ expected_as)) begin
                $display("PASS");
                $display("  Outputs: as=%h",
                         as);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: as=%h",
                         expected_as);
                $display("  Got:      as=%h",
                         as);
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
