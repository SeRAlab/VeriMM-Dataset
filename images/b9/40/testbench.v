`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    wire o;
    wire o2;
    wire o3;
    wire o4;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .o(o),
        .o2(o2),
        .o3(o3),
        .o4(o4)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Running Test Case 001: Initial Constant Verification");

            #1;


            check_outputs(1'b0, 1'b1, 1'b0, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Running Test Case 002: Stability Verification (10ns)");
            #10;

            #1;


            check_outputs(1'b0, 1'b1, 1'b0, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Running Test Case 003: Stability Verification (100ns)");
            #100;

            #1;


            check_outputs(1'b0, 1'b1, 1'b0, 1'b1);
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
        input expected_o;
        input expected_o2;
        input expected_o3;
        input expected_o4;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_o === (expected_o ^ o ^ expected_o) &&
                expected_o2 === (expected_o2 ^ o2 ^ expected_o2) &&
                expected_o3 === (expected_o3 ^ o3 ^ expected_o3) &&
                expected_o4 === (expected_o4 ^ o4 ^ expected_o4)) begin
                $display("PASS");
                $display("  Outputs: o=%b, o2=%b, o3=%b, o4=%b",
                         o, o2, o3, o4);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: o=%b, o2=%b, o3=%b, o4=%b",
                         expected_o, expected_o2, expected_o3, expected_o4);
                $display("  Got:      o=%b, o2=%b, o3=%b, o4=%b",
                         o, o2, o3, o4);
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
