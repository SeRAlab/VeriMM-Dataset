`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [1:0] i;
    wire o0;
    wire o1;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .i(i),
        .o0(o0),
        .o1(o1)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Test Case 001: i = 2'b00");
        i = 2'b00;
        #1;

        check_outputs(0, 0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test Case 002: i = 2'b01");
        i = 2'b01;
        #1;

        check_outputs(1, 0);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test Case 003: i = 2'b10");
        i = 2'b10;
        #1;

        check_outputs(0, 1);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test Case 004: i = 2'b11");
        i = 2'b11;
        #1;

        check_outputs(1, 1);
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
        input expected_o0;
        input expected_o1;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_o0 === (expected_o0 ^ o0 ^ expected_o0) &&
                expected_o1 === (expected_o1 ^ o1 ^ expected_o1)) begin
                $display("PASS");
                $display("  Outputs: o0=%b, o1=%b",
                         o0, o1);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: o0=%b, o1=%b",
                         expected_o0, expected_o1);
                $display("  Got:      o0=%b, o1=%b",
                         o0, o1);
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
