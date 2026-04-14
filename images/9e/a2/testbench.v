`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    wire [7:0] value;
    wire [7:0] value_w;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .value(value),
        .value_w(value_w)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Initial Stabilization Check", test_num);




            #1;


            #1;



            check_outputs(8'h05, 8'h06);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Steady State Stability Check", test_num);


            #100;


            #1;



            check_outputs(8'h05, 8'h06);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Long Duration Consistency Check", test_num);


            #1000;


            #1;



            check_outputs(8'h05, 8'h06);
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
        input [7:0] expected_value;
        input [7:0] expected_value_w;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_value === (expected_value ^ value ^ expected_value) &&
                expected_value_w === (expected_value_w ^ value_w ^ expected_value_w)) begin
                $display("PASS");
                $display("  Outputs: value=%h, value_w=%h",
                         value, value_w);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: value=%h, value_w=%h",
                         expected_value, expected_value_w);
                $display("  Got:      value=%h, value_w=%h",
                         value, value_w);
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
