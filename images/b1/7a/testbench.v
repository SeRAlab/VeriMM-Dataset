`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg a0;
    reg a1;
    reg a2;
    wire r0;
    wire r1;
    wire r2;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a0(a0),
        .a1(a1),
        .a2(a2),
        .r0(r0),
        .r1(r1),
        .r2(r2)
    );
    task testcase001;

    begin
        $display("Testcase 001: a=000");
        test_num = 1;
        a2 = 0; a1 = 0; a0 = 0;
        #1;

        check_outputs(0, 0, 0);
    end
        endtask

    task testcase002;

    begin
        $display("Testcase 002: a=001");
        test_num = 2;
        a2 = 0; a1 = 0; a0 = 1;
        #1;

        check_outputs(0, 1, 0);
    end
        endtask

    task testcase003;

    begin
        $display("Testcase 003: a=010");
        test_num = 3;
        a2 = 0; a1 = 1; a0 = 0;
        #1;

        check_outputs(0, 1, 0);
    end
        endtask

    task testcase004;

    begin
        $display("Testcase 004: a=011");
        test_num = 4;
        a2 = 0; a1 = 1; a0 = 1;
        #1;

        check_outputs(0, 0, 1);
    end
        endtask

    task testcase005;

    begin
        $display("Testcase 005: a=100");
        test_num = 5;
        a2 = 1; a1 = 0; a0 = 0;
        #1;

        check_outputs(0, 0, 1);
    end
        endtask

    task testcase006;

    begin
        $display("Testcase 006: a=101");
        test_num = 6;
        a2 = 1; a1 = 0; a0 = 1;
        #1;

        check_outputs(0, 1, 1);
    end
        endtask

    task testcase007;

    begin
        $display("Testcase 007: a=110");
        test_num = 7;
        a2 = 1; a1 = 1; a0 = 0;
        #1;

        check_outputs(0, 1, 1);
    end
        endtask

    task testcase008;

    begin
        $display("Testcase 008: a=111");
        test_num = 8;
        a2 = 1; a1 = 1; a0 = 1;
        #1;

        check_outputs(0, 0, 0);
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
        input expected_r0;
        input expected_r1;
        input expected_r2;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_r0 === (expected_r0 ^ r0 ^ expected_r0) &&
                expected_r1 === (expected_r1 ^ r1 ^ expected_r1) &&
                expected_r2 === (expected_r2 ^ r2 ^ expected_r2)) begin
                $display("PASS");
                $display("  Outputs: r0=%b, r1=%b, r2=%b",
                         r0, r1, r2);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: r0=%b, r1=%b, r2=%b",
                         expected_r0, expected_r1, expected_r2);
                $display("  Got:      r0=%b, r1=%b, r2=%b",
                         r0, r1, r2);
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
