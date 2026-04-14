`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg a_in;
    reg b_in;
    reg c_in;
    reg d_in;
    wire y_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a_in(a_in),
        .b_in(b_in),
        .c_in(c_in),
        .d_in(d_in),
        .y_out(y_out)
    );
    task testcase001;

    begin
        test_num = 1;
        a_in = 1; b_in = 1; c_in = 0; d_in = 0;
        $display("Test Case 001: a=1, b=1, c=0, d=0 -> Expected y=1");
        #1;

        check_outputs(1);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        a_in = 0; b_in = 0; c_in = 1; d_in = 1;
        $display("Test Case 002: a=0, b=0, c=1, d=1 -> Expected y=0");
        #1;

        check_outputs(0);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        a_in = 1; b_in = 1; c_in = 1; d_in = 1;
        $display("Test Case 003: a=1, b=1, c=1, d=1 -> Expected y=1");
        #1;

        check_outputs(1);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        a_in = 0; b_in = 0; c_in = 0; d_in = 0;
        $display("Test Case 004: a=0, b=0, c=0, d=0 -> Expected y=0");
        #1;

        check_outputs(0);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        a_in = 1; b_in = 0; c_in = 1; d_in = 0;
        $display("Test Case 005: a=1, b=0, c=1, d=0 -> Expected y=0");
        #1;

        check_outputs(0);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        a_in = 0; b_in = 1; c_in = 0; d_in = 1;
        $display("Test Case 006: a=0, b=1, c=0, d=1 -> Expected y=1");
        #1;

        check_outputs(1);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        a_in = 1; b_in = 1; c_in = 1; d_in = 0;
        $display("Test Case 007: a=1, b=1, c=1, d=0 -> Expected y=1");
        #1;

        check_outputs(1);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        a_in = 0; b_in = 0; c_in = 1; d_in = 0;
        $display("Test Case 008: a=0, b=0, c=1, d=0 -> Expected y=0");
        #1;

        check_outputs(0);
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
        input expected_y_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_y_out === (expected_y_out ^ y_out ^ expected_y_out)) begin
                $display("PASS");
                $display("  Outputs: y_out=%b",
                         y_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: y_out=%b",
                         expected_y_out);
                $display("  Got:      y_out=%b",
                         y_out);
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
