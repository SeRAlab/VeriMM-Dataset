`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg binary;
    wire [1:0] one_hot;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .binary(binary),
        .one_hot(one_hot)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Input binary = 0", test_num);
            binary = 1'b0;

            #1;


            check_outputs(2'b01);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Input binary = 1", test_num);
            binary = 1'b1;

            #1;


            check_outputs(2'b10);
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
        input [1:0] expected_one_hot;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_one_hot === (expected_one_hot ^ one_hot ^ expected_one_hot)) begin
                $display("PASS");
                $display("  Outputs: one_hot=%h",
                         one_hot);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: one_hot=%h",
                         expected_one_hot);
                $display("  Got:      one_hot=%h",
                         one_hot);
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
