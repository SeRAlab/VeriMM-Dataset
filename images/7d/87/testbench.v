`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg din;
    wire dout_n;
    wire dout_p;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .din(din),
        .dout_n(dout_n),
        .dout_p(dout_p)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Test Case 001: Setting din = 0");
        din = 1'b0;


        #20;
        #1;

        check_outputs(1'b1, 1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test Case 002: Setting din = 1");
        din = 1'b1;
        #20;
        #1;

        check_outputs(1'b0, 1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test Case 003: Transition din from 1 to 0");
        din = 1'b1;
        #10;
        din = 1'b0;
        #20;
        #1;

        check_outputs(1'b1, 1'b0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test Case 004: Transition din from 0 to 1");
        din = 1'b0;
        #10;
        din = 1'b1;
        #20;
        #1;

        check_outputs(1'b0, 1'b1);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test Case 005: Verifying output stability with din = 0");
        din = 1'b1;
        #5;
        din = 1'b0;
        #20;
        #1;

        check_outputs(1'b1, 1'b0);
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
        input expected_dout_n;
        input expected_dout_p;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_dout_n === (expected_dout_n ^ dout_n ^ expected_dout_n) &&
                expected_dout_p === (expected_dout_p ^ dout_p ^ expected_dout_p)) begin
                $display("PASS");
                $display("  Outputs: dout_n=%b, dout_p=%b",
                         dout_n, dout_p);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: dout_n=%b, dout_p=%b",
                         expected_dout_n, expected_dout_p);
                $display("  Got:      dout_n=%b, dout_p=%b",
                         dout_n, dout_p);
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
