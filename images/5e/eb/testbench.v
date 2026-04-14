`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg i_input;
    wire [1:0] o_LED;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .i_input(i_input),
        .o_LED(o_LED)
    );
    task testcase001;

        begin
            $display("Test Case 001: i_input = 0");
            test_num = 1;
            i_input = 1'b0;
            #1;

            check_outputs(2'b10);
        end
        endtask

    task testcase002;

        begin
            $display("Test Case 002: i_input = 1");
            test_num = 2;
            i_input = 1'b1;
            #1;

            check_outputs(2'b01);
        end
        endtask

    task testcase003;

        begin
            $display("Test Case 003: Toggle Input (1 -> 0)");
            test_num = 3;
            i_input = 1'b1;
            #10;
            i_input = 1'b0;
            #1;

            check_outputs(2'b10);
        end
        endtask

    task testcase004;

        begin
            $display("Test Case 004: Toggle Input (0 -> 1)");
            test_num = 4;
            i_input = 1'b0;
            #10;
            i_input = 1'b1;
            #1;

            check_outputs(2'b01);
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
        input [1:0] expected_o_LED;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_o_LED === (expected_o_LED ^ o_LED ^ expected_o_LED)) begin
                $display("PASS");
                $display("  Outputs: o_LED=%h",
                         o_LED);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: o_LED=%h",
                         expected_o_LED);
                $display("  Got:      o_LED=%h",
                         o_LED);
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
