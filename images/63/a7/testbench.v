`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] in_val;
    wire [3:0] out_val;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .in_val(in_val),
        .out_val(out_val)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Test Case 001: Input 0 (Outside range 5-12)");
        in_val = 4'd0;
        #1;

        check_outputs(4'd0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test Case 002: Input 4 (Outside range 5-12)");
        in_val = 4'd4;
        #1;

        check_outputs(4'd4);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test Case 003: Input 5 (Lower bound of range 5-12)");
        in_val = 4'd5;
        #1;

        check_outputs(4'd6);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test Case 004: Input 8 (Inside range 5-12)");
        in_val = 4'd8;
        #1;

        check_outputs(4'd9);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test Case 005: Input 11 (Inside range 5-12)");
        in_val = 4'd11;
        #1;

        check_outputs(4'd12);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test Case 006: Input 12 (Upper bound of range 5-12)");
        in_val = 4'd12;
        #1;

        check_outputs(4'd13);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Test Case 007: Input 13 (Outside range 5-12)");
        in_val = 4'd13;
        #1;

        check_outputs(4'd13);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Test Case 008: Input 15 (Outside range 5-12)");
        in_val = 4'd15;
        #1;

        check_outputs(4'd15);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        $display("Test Case 009: Input 7 (Inside range 5-12)");
        in_val = 4'd7;
        #1;

        check_outputs(4'd8);
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
        testcase005();
        testcase006();
        testcase007();
        testcase008();
        testcase009();
        
        
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
        input [3:0] expected_out_val;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_out_val === (expected_out_val ^ out_val ^ expected_out_val)) begin
                $display("PASS");
                $display("  Outputs: out_val=%h",
                         out_val);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out_val=%h",
                         expected_out_val);
                $display("  Got:      out_val=%h",
                         out_val);
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
