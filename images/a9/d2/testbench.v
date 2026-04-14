`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg w;
    reg [1:0] y;
    wire Z1;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .w(w),
        .y(y),
        .Z1(Z1)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test Case 001: Current State S1 (y=00), w=0. Expected Next y[1]=1");
        y = 2'b00; w = 0;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case 002: Current State S1 (y=00), w=1. Expected Next y[1]=0");
        y = 2'b00; w = 1;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test Case 003: Current State S2 (y=01), w=0. Expected Next y[1]=0");
        y = 2'b01; w = 0;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test Case 004: Current State S2 (y=01), w=1. Expected Next y[1]=0");
        y = 2'b01; w = 1;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test Case 005: Current State S3 (y=10), w=0. Expected Next y[1]=0");
        y = 2'b10; w = 0;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test Case 006: Current State S3 (y=10), w=1. Expected Next y[1]=1");
        y = 2'b10; w = 1;
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
        testcase005();
        testcase006();
        
        
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
        input expected_Z1;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Z1 === (expected_Z1 ^ Z1 ^ expected_Z1)) begin
                $display("PASS");
                $display("  Outputs: Z1=%b",
                         Z1);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Z1=%b",
                         expected_Z1);
                $display("  Got:      Z1=%b",
                         Z1);
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
