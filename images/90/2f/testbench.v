`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg a;
    reg i0;
    reg i1;
    wire s0;
    wire s1;
    wire s2;
    wire s3;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .i0(i0),
        .i1(i1),
        .s0(s0),
        .s1(s1),
        .s2(s2),
        .s3(s3)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Test Case 001: a=0, i1=0, i0=0");
        a = 0; i1 = 0; i0 = 0;
        #1;

        check_outputs(0, 0, 0, 0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test Case 002: a=0, i1=0, i0=1");
        a = 0; i1 = 0; i0 = 1;
        #1;

        check_outputs(0, 0, 0, 0);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test Case 003: a=0, i1=1, i0=0");
        a = 0; i1 = 1; i0 = 0;
        #1;

        check_outputs(0, 0, 0, 0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test Case 004: a=0, i1=1, i0=1");
        a = 0; i1 = 1; i0 = 1;
        #1;

        check_outputs(0, 0, 0, 0);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test Case 005: a=1, i1=0, i0=0");
        a = 1; i1 = 0; i0 = 0;
        #1;

        check_outputs(1, 0, 0, 0);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test Case 006: a=1, i1=0, i0=1");
        a = 1; i1 = 0; i0 = 1;
        #1;

        check_outputs(0, 1, 0, 0);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Test Case 007: a=1, i1=1, i0=0");
        a = 1; i1 = 1; i0 = 0;
        #1;

        check_outputs(0, 0, 1, 0);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Test Case 008: a=1, i1=1, i0=1");
        a = 1; i1 = 1; i0 = 1;
        #1;

        check_outputs(0, 0, 0, 1);
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
        input expected_s0;
        input expected_s1;
        input expected_s2;
        input expected_s3;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_s0 === (expected_s0 ^ s0 ^ expected_s0) &&
                expected_s1 === (expected_s1 ^ s1 ^ expected_s1) &&
                expected_s2 === (expected_s2 ^ s2 ^ expected_s2) &&
                expected_s3 === (expected_s3 ^ s3 ^ expected_s3)) begin
                $display("PASS");
                $display("  Outputs: s0=%b, s1=%b, s2=%b, s3=%b",
                         s0, s1, s2, s3);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: s0=%b, s1=%b, s2=%b, s3=%b",
                         expected_s0, expected_s1, expected_s2, expected_s3);
                $display("  Got:      s0=%b, s1=%b, s2=%b, s3=%b",
                         s0, s1, s2, s3);
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
