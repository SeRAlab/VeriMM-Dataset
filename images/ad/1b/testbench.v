`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [1:0] operation;
    wire op_mod_add_subt;
    wire op_mod_cordic;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .operation(operation),
        .op_mod_add_subt(op_mod_add_subt),
        .op_mod_cordic(op_mod_cordic)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Test Case 001: operation = 00 (Default/Disabled)");
        operation = 2'b00;
        #1;

        check_outputs(1'b0, 1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test Case 002: operation = 01 (Addition/Subtraction Mode)");
        operation = 2'b01;
        #1;

        check_outputs(1'b1, 1'b0);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test Case 003: operation = 10 (Default/Disabled)");
        operation = 2'b10;
        #1;

        check_outputs(1'b0, 1'b0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test Case 004: operation = 11 (CORDIC Mode)");
        operation = 2'b11;
        #1;

        check_outputs(1'b0, 1'b1);
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
        input expected_op_mod_add_subt;
        input expected_op_mod_cordic;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_op_mod_add_subt === (expected_op_mod_add_subt ^ op_mod_add_subt ^ expected_op_mod_add_subt) &&
                expected_op_mod_cordic === (expected_op_mod_cordic ^ op_mod_cordic ^ expected_op_mod_cordic)) begin
                $display("PASS");
                $display("  Outputs: op_mod_add_subt=%b, op_mod_cordic=%b",
                         op_mod_add_subt, op_mod_cordic);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: op_mod_add_subt=%b, op_mod_cordic=%b",
                         expected_op_mod_add_subt, expected_op_mod_cordic);
                $display("  Got:      op_mod_add_subt=%b, op_mod_cordic=%b",
                         op_mod_add_subt, op_mod_cordic);
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
