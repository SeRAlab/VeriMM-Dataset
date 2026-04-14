`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg ld;
    wire lz;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ld(ld),
        .lz(lz)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Test Case 001: Drive ld to 0");
        ld = 1'b0;
        #10;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test Case 002: Drive ld to 1");
        ld = 1'b1;
        #10;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test Case 003: High-to-Low Transition");
        ld = 1'b1;
        #5;
        ld = 1'b0;
        #10;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test Case 004: Low-to-High Transition");
        ld = 1'b0;
        #5;
        ld = 1'b1;
        #10;
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
        input expected_lz;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_lz === (expected_lz ^ lz ^ expected_lz)) begin
                $display("PASS");
                $display("  Outputs: lz=%b",
                         lz);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: lz=%b",
                         expected_lz);
                $display("  Got:      lz=%b",
                         lz);
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
