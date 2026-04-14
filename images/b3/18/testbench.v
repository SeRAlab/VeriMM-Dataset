`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg DOA0;
    reg DOA1;
    reg DOB0;
    reg DOB1;
    reg DOC0;
    reg DOC1;
    reg DOD0;
    reg DOD1;
    wire DOA0_OUT;
    wire DOA1_OUT;
    wire DOB0_OUT;
    wire DOB1_OUT;
    wire DOC0_OUT;
    wire DOC1_OUT;
    wire DOD0_OUT;
    wire DOD1_OUT;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .DOA0(DOA0),
        .DOA1(DOA1),
        .DOB0(DOB0),
        .DOB1(DOB1),
        .DOC0(DOC0),
        .DOC1(DOC1),
        .DOD0(DOD0),
        .DOD1(DOD1),
        .DOA0_OUT(DOA0_OUT),
        .DOA1_OUT(DOA1_OUT),
        .DOB0_OUT(DOB0_OUT),
        .DOB1_OUT(DOB1_OUT),
        .DOC0_OUT(DOC0_OUT),
        .DOC1_OUT(DOC1_OUT),
        .DOD0_OUT(DOD0_OUT),
        .DOD1_OUT(DOD1_OUT)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Test Case 001: All Zeros");
        DOA0 = 0; DOA1 = 0; DOB0 = 0; DOB1 = 0;
        DOC0 = 0; DOC1 = 0; DOD0 = 0; DOD1 = 0;

        #1;


        check_outputs(0, 0, 0, 0, 0, 0, 0, 0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test Case 002: All Ones");
        DOA0 = 1; DOA1 = 1; DOB0 = 1; DOB1 = 1;
        DOC0 = 1; DOC1 = 1; DOD0 = 1; DOD1 = 1;
        #1;

        check_outputs(1, 1, 1, 1, 1, 1, 1, 1);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test Case 003: DOA and DOB bits high, others low");
        DOA0 = 1; DOA1 = 1; DOB0 = 1; DOB1 = 1;
        DOC0 = 0; DOC1 = 0; DOD0 = 0; DOD1 = 0;
        #1;

        check_outputs(1, 1, 1, 1, 0, 0, 0, 0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test Case 004: DOC and DOD bits high, others low");
        DOA0 = 0; DOA1 = 0; DOB0 = 0; DOB1 = 0;
        DOC0 = 1; DOC1 = 1; DOD0 = 1; DOD1 = 1;
        #1;

        check_outputs(0, 0, 0, 0, 1, 1, 1, 1);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test Case 005: Bit 0 signals high, Bit 1 signals low");
        DOA0 = 1; DOA1 = 0; DOB0 = 1; DOB1 = 0;
        DOC0 = 1; DOC1 = 0; DOD0 = 1; DOD1 = 0;
        #1;

        check_outputs(1, 0, 1, 0, 1, 0, 1, 0);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test Case 006: Bit 1 signals high, Bit 0 signals low");
        DOA0 = 0; DOA1 = 1; DOB0 = 0; DOB1 = 1;
        DOC0 = 0; DOC1 = 1; DOD0 = 0; DOD1 = 1;
        #1;

        check_outputs(0, 1, 0, 1, 0, 1, 0, 1);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Test Case 007: Checkerboard pattern");
        DOA0 = 1; DOA1 = 0; DOB0 = 0; DOB1 = 1;
        DOC0 = 1; DOC1 = 0; DOD0 = 0; DOD1 = 1;
        #1;

        check_outputs(1, 0, 0, 1, 1, 0, 0, 1);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Test Case 008: Inverse checkerboard pattern");
        DOA0 = 0; DOA1 = 1; DOB0 = 1; DOB1 = 0;
        DOC0 = 0; DOC1 = 1; DOD0 = 1; DOD1 = 0;
        #1;

        check_outputs(0, 1, 1, 0, 0, 1, 1, 0);
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
        input expected_DOA0_OUT;
        input expected_DOA1_OUT;
        input expected_DOB0_OUT;
        input expected_DOB1_OUT;
        input expected_DOC0_OUT;
        input expected_DOC1_OUT;
        input expected_DOD0_OUT;
        input expected_DOD1_OUT;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_DOA0_OUT === (expected_DOA0_OUT ^ DOA0_OUT ^ expected_DOA0_OUT) &&
                expected_DOA1_OUT === (expected_DOA1_OUT ^ DOA1_OUT ^ expected_DOA1_OUT) &&
                expected_DOB0_OUT === (expected_DOB0_OUT ^ DOB0_OUT ^ expected_DOB0_OUT) &&
                expected_DOB1_OUT === (expected_DOB1_OUT ^ DOB1_OUT ^ expected_DOB1_OUT) &&
                expected_DOC0_OUT === (expected_DOC0_OUT ^ DOC0_OUT ^ expected_DOC0_OUT) &&
                expected_DOC1_OUT === (expected_DOC1_OUT ^ DOC1_OUT ^ expected_DOC1_OUT) &&
                expected_DOD0_OUT === (expected_DOD0_OUT ^ DOD0_OUT ^ expected_DOD0_OUT) &&
                expected_DOD1_OUT === (expected_DOD1_OUT ^ DOD1_OUT ^ expected_DOD1_OUT)) begin
                $display("PASS");
                $display("  Outputs: DOA0_OUT=%b, DOA1_OUT=%b, DOB0_OUT=%b, DOB1_OUT=%b, DOC0_OUT=%b, DOC1_OUT=%b, DOD0_OUT=%b, DOD1_OUT=%b",
                         DOA0_OUT, DOA1_OUT, DOB0_OUT, DOB1_OUT, DOC0_OUT, DOC1_OUT, DOD0_OUT, DOD1_OUT);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: DOA0_OUT=%b, DOA1_OUT=%b, DOB0_OUT=%b, DOB1_OUT=%b, DOC0_OUT=%b, DOC1_OUT=%b, DOD0_OUT=%b, DOD1_OUT=%b",
                         expected_DOA0_OUT, expected_DOA1_OUT, expected_DOB0_OUT, expected_DOB1_OUT, expected_DOC0_OUT, expected_DOC1_OUT, expected_DOD0_OUT, expected_DOD1_OUT);
                $display("  Got:      DOA0_OUT=%b, DOA1_OUT=%b, DOB0_OUT=%b, DOB1_OUT=%b, DOC0_OUT=%b, DOC1_OUT=%b, DOD0_OUT=%b, DOD1_OUT=%b",
                         DOA0_OUT, DOA1_OUT, DOB0_OUT, DOB1_OUT, DOC0_OUT, DOC1_OUT, DOD0_OUT, DOD1_OUT);
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
