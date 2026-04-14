`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg i;
    wire oa;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .i(i),
        .oa(oa)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Driving i to 0", test_num);
            i = 1'b0;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Driving i to 1", test_num);
            i = 1'b1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Transition i from 1 to 0", test_num);
            i = 1'b1;
            #10;
            i = 1'b0;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Transition i from 0 to 1", test_num);
            i = 1'b0;
            #10;
            i = 1'b1;
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
        input expected_oa;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_oa === (expected_oa ^ oa ^ expected_oa)) begin
                $display("PASS");
                $display("  Outputs: oa=%b",
                         oa);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: oa=%b",
                         expected_oa);
                $display("  Got:      oa=%b",
                         oa);
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
