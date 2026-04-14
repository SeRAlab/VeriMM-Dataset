`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg bflush;
    reg jflush;
    wire flush;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .bflush(bflush),
        .jflush(jflush),
        .flush(flush)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Test %0d: Neither bflush nor jflush asserted", test_num);
        bflush = 1'b0;
        jflush = 1'b0;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test %0d: Only jflush asserted", test_num);
        bflush = 1'b0;
        jflush = 1'b1;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test %0d: Only bflush asserted", test_num);
        bflush = 1'b1;
        jflush = 1'b0;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test %0d: Both bflush and jflush asserted", test_num);
        bflush = 1'b1;
        jflush = 1'b1;
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
        input expected_flush;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_flush === (expected_flush ^ flush ^ expected_flush)) begin
                $display("PASS");
                $display("  Outputs: flush=%b",
                         flush);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: flush=%b",
                         expected_flush);
                $display("  Got:      flush=%b",
                         flush);
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
