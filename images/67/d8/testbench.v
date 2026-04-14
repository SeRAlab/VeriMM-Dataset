`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg arbpc0_pcxdp_grant_arbbf_pa;
    reg arbpc0_pcxdp_q0_hold_arbbf_pa_l;
    reg arbpc0_pcxdp_qsel0_arbbf_pa;
    reg arbpc0_pcxdp_qsel1_arbbf_pa_l;
    reg arbpc0_pcxdp_shift_arbbf_px;
    reg arbpc2_pcxdp_grant_arbbf_pa;
    reg arbpc2_pcxdp_q0_hold_arbbf_pa_l;
    reg arbpc2_pcxdp_qsel0_arbbf_pa;
    reg arbpc2_pcxdp_qsel1_arbbf_pa_l;
    reg arbpc2_pcxdp_shift_arbbf_px;
    wire arbpc0_pcxdp_grant_pa;
    wire arbpc0_pcxdp_q0_hold_pa_l;
    wire arbpc0_pcxdp_qsel0_pa;
    wire arbpc0_pcxdp_qsel1_pa_l;
    wire arbpc0_pcxdp_shift_px;
    wire arbpc2_pcxdp_grant_pa;
    wire arbpc2_pcxdp_q0_hold_pa_l;
    wire arbpc2_pcxdp_qsel0_pa;
    wire arbpc2_pcxdp_qsel1_pa_l;
    wire arbpc2_pcxdp_shift_px;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .arbpc0_pcxdp_grant_arbbf_pa(arbpc0_pcxdp_grant_arbbf_pa),
        .arbpc0_pcxdp_q0_hold_arbbf_pa_l(arbpc0_pcxdp_q0_hold_arbbf_pa_l),
        .arbpc0_pcxdp_qsel0_arbbf_pa(arbpc0_pcxdp_qsel0_arbbf_pa),
        .arbpc0_pcxdp_qsel1_arbbf_pa_l(arbpc0_pcxdp_qsel1_arbbf_pa_l),
        .arbpc0_pcxdp_shift_arbbf_px(arbpc0_pcxdp_shift_arbbf_px),
        .arbpc2_pcxdp_grant_arbbf_pa(arbpc2_pcxdp_grant_arbbf_pa),
        .arbpc2_pcxdp_q0_hold_arbbf_pa_l(arbpc2_pcxdp_q0_hold_arbbf_pa_l),
        .arbpc2_pcxdp_qsel0_arbbf_pa(arbpc2_pcxdp_qsel0_arbbf_pa),
        .arbpc2_pcxdp_qsel1_arbbf_pa_l(arbpc2_pcxdp_qsel1_arbbf_pa_l),
        .arbpc2_pcxdp_shift_arbbf_px(arbpc2_pcxdp_shift_arbbf_px),
        .arbpc0_pcxdp_grant_pa(arbpc0_pcxdp_grant_pa),
        .arbpc0_pcxdp_q0_hold_pa_l(arbpc0_pcxdp_q0_hold_pa_l),
        .arbpc0_pcxdp_qsel0_pa(arbpc0_pcxdp_qsel0_pa),
        .arbpc0_pcxdp_qsel1_pa_l(arbpc0_pcxdp_qsel1_pa_l),
        .arbpc0_pcxdp_shift_px(arbpc0_pcxdp_shift_px),
        .arbpc2_pcxdp_grant_pa(arbpc2_pcxdp_grant_pa),
        .arbpc2_pcxdp_q0_hold_pa_l(arbpc2_pcxdp_q0_hold_pa_l),
        .arbpc2_pcxdp_qsel0_pa(arbpc2_pcxdp_qsel0_pa),
        .arbpc2_pcxdp_qsel1_pa_l(arbpc2_pcxdp_qsel1_pa_l),
        .arbpc2_pcxdp_shift_px(arbpc2_pcxdp_shift_px)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase 001: All inputs zero");
        arbpc0_pcxdp_grant_arbbf_pa = 0;
        arbpc0_pcxdp_q0_hold_arbbf_pa_l = 0;
        arbpc0_pcxdp_qsel0_arbbf_pa = 0;
        arbpc0_pcxdp_qsel1_arbbf_pa_l = 0;
        arbpc0_pcxdp_shift_arbbf_px = 0;
        arbpc2_pcxdp_grant_arbbf_pa = 0;
        arbpc2_pcxdp_q0_hold_arbbf_pa_l = 0;
        arbpc2_pcxdp_qsel0_arbbf_pa = 0;
        arbpc2_pcxdp_qsel1_arbbf_pa_l = 0;
        arbpc2_pcxdp_shift_arbbf_px = 0;
        #1;

        check_outputs(0, 0, 0, 0, 0, 0, 0, 0, 0, 0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase 002: All inputs one");
        arbpc0_pcxdp_grant_arbbf_pa = 1;
        arbpc0_pcxdp_q0_hold_arbbf_pa_l = 1;
        arbpc0_pcxdp_qsel0_arbbf_pa = 1;
        arbpc0_pcxdp_qsel1_arbbf_pa_l = 1;
        arbpc0_pcxdp_shift_arbbf_px = 1;
        arbpc2_pcxdp_grant_arbbf_pa = 1;
        arbpc2_pcxdp_q0_hold_arbbf_pa_l = 1;
        arbpc2_pcxdp_qsel0_arbbf_pa = 1;
        arbpc2_pcxdp_qsel1_arbbf_pa_l = 1;
        arbpc2_pcxdp_shift_arbbf_px = 1;
        #1;

        check_outputs(1, 1, 1, 1, 1, 1, 1, 1, 1, 1);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase 003: Arbpc0 signals active, Arbpc2 idle");
        arbpc0_pcxdp_grant_arbbf_pa = 1;
        arbpc0_pcxdp_q0_hold_arbbf_pa_l = 0;
        arbpc0_pcxdp_qsel0_arbbf_pa = 1;
        arbpc0_pcxdp_qsel1_arbbf_pa_l = 1;
        arbpc0_pcxdp_shift_arbbf_px = 0;
        arbpc2_pcxdp_grant_arbbf_pa = 0;
        arbpc2_pcxdp_q0_hold_arbbf_pa_l = 1;
        arbpc2_pcxdp_qsel0_arbbf_pa = 0;
        arbpc2_pcxdp_qsel1_arbbf_pa_l = 0;
        arbpc2_pcxdp_shift_arbbf_px = 0;
        #1;

        check_outputs(1, 0, 1, 1, 0, 0, 1, 0, 0, 0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase 004: Arbpc2 signals active, Arbpc0 idle");
        arbpc0_pcxdp_grant_arbbf_pa = 0;
        arbpc0_pcxdp_q0_hold_arbbf_pa_l = 1;
        arbpc0_pcxdp_qsel0_arbbf_pa = 0;
        arbpc0_pcxdp_qsel1_arbbf_pa_l = 0;
        arbpc0_pcxdp_shift_arbbf_px = 0;
        arbpc2_pcxdp_grant_arbbf_pa = 1;
        arbpc2_pcxdp_q0_hold_arbbf_pa_l = 0;
        arbpc2_pcxdp_qsel0_arbbf_pa = 1;
        arbpc2_pcxdp_qsel1_arbbf_pa_l = 1;
        arbpc2_pcxdp_shift_arbbf_px = 1;
        #1;

        check_outputs(0, 1, 0, 0, 0, 1, 0, 1, 1, 1);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase 005: Alternating bit pattern");
        arbpc0_pcxdp_grant_arbbf_pa = 1;
        arbpc0_pcxdp_q0_hold_arbbf_pa_l = 0;
        arbpc0_pcxdp_qsel0_arbbf_pa = 1;
        arbpc0_pcxdp_qsel1_arbbf_pa_l = 0;
        arbpc0_pcxdp_shift_arbbf_px = 1;
        arbpc2_pcxdp_grant_arbbf_pa = 0;
        arbpc2_pcxdp_q0_hold_arbbf_pa_l = 1;
        arbpc2_pcxdp_qsel0_arbbf_pa = 0;
        arbpc2_pcxdp_qsel1_arbbf_pa_l = 1;
        arbpc2_pcxdp_shift_arbbf_px = 0;
        #1;

        check_outputs(1, 0, 1, 0, 1, 0, 1, 0, 1, 0);
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
        input expected_arbpc0_pcxdp_grant_pa;
        input expected_arbpc0_pcxdp_q0_hold_pa_l;
        input expected_arbpc0_pcxdp_qsel0_pa;
        input expected_arbpc0_pcxdp_qsel1_pa_l;
        input expected_arbpc0_pcxdp_shift_px;
        input expected_arbpc2_pcxdp_grant_pa;
        input expected_arbpc2_pcxdp_q0_hold_pa_l;
        input expected_arbpc2_pcxdp_qsel0_pa;
        input expected_arbpc2_pcxdp_qsel1_pa_l;
        input expected_arbpc2_pcxdp_shift_px;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_arbpc0_pcxdp_grant_pa === (expected_arbpc0_pcxdp_grant_pa ^ arbpc0_pcxdp_grant_pa ^ expected_arbpc0_pcxdp_grant_pa) &&
                expected_arbpc0_pcxdp_q0_hold_pa_l === (expected_arbpc0_pcxdp_q0_hold_pa_l ^ arbpc0_pcxdp_q0_hold_pa_l ^ expected_arbpc0_pcxdp_q0_hold_pa_l) &&
                expected_arbpc0_pcxdp_qsel0_pa === (expected_arbpc0_pcxdp_qsel0_pa ^ arbpc0_pcxdp_qsel0_pa ^ expected_arbpc0_pcxdp_qsel0_pa) &&
                expected_arbpc0_pcxdp_qsel1_pa_l === (expected_arbpc0_pcxdp_qsel1_pa_l ^ arbpc0_pcxdp_qsel1_pa_l ^ expected_arbpc0_pcxdp_qsel1_pa_l) &&
                expected_arbpc0_pcxdp_shift_px === (expected_arbpc0_pcxdp_shift_px ^ arbpc0_pcxdp_shift_px ^ expected_arbpc0_pcxdp_shift_px) &&
                expected_arbpc2_pcxdp_grant_pa === (expected_arbpc2_pcxdp_grant_pa ^ arbpc2_pcxdp_grant_pa ^ expected_arbpc2_pcxdp_grant_pa) &&
                expected_arbpc2_pcxdp_q0_hold_pa_l === (expected_arbpc2_pcxdp_q0_hold_pa_l ^ arbpc2_pcxdp_q0_hold_pa_l ^ expected_arbpc2_pcxdp_q0_hold_pa_l) &&
                expected_arbpc2_pcxdp_qsel0_pa === (expected_arbpc2_pcxdp_qsel0_pa ^ arbpc2_pcxdp_qsel0_pa ^ expected_arbpc2_pcxdp_qsel0_pa) &&
                expected_arbpc2_pcxdp_qsel1_pa_l === (expected_arbpc2_pcxdp_qsel1_pa_l ^ arbpc2_pcxdp_qsel1_pa_l ^ expected_arbpc2_pcxdp_qsel1_pa_l) &&
                expected_arbpc2_pcxdp_shift_px === (expected_arbpc2_pcxdp_shift_px ^ arbpc2_pcxdp_shift_px ^ expected_arbpc2_pcxdp_shift_px)) begin
                $display("PASS");
                $display("  Outputs: arbpc0_pcxdp_grant_pa=%b, arbpc0_pcxdp_q0_hold_pa_l=%b, arbpc0_pcxdp_qsel0_pa=%b, arbpc0_pcxdp_qsel1_pa_l=%b, arbpc0_pcxdp_shift_px=%b, arbpc2_pcxdp_grant_pa=%b, arbpc2_pcxdp_q0_hold_pa_l=%b, arbpc2_pcxdp_qsel0_pa=%b, arbpc2_pcxdp_qsel1_pa_l=%b, arbpc2_pcxdp_shift_px=%b",
                         arbpc0_pcxdp_grant_pa, arbpc0_pcxdp_q0_hold_pa_l, arbpc0_pcxdp_qsel0_pa, arbpc0_pcxdp_qsel1_pa_l, arbpc0_pcxdp_shift_px, arbpc2_pcxdp_grant_pa, arbpc2_pcxdp_q0_hold_pa_l, arbpc2_pcxdp_qsel0_pa, arbpc2_pcxdp_qsel1_pa_l, arbpc2_pcxdp_shift_px);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: arbpc0_pcxdp_grant_pa=%b, arbpc0_pcxdp_q0_hold_pa_l=%b, arbpc0_pcxdp_qsel0_pa=%b, arbpc0_pcxdp_qsel1_pa_l=%b, arbpc0_pcxdp_shift_px=%b, arbpc2_pcxdp_grant_pa=%b, arbpc2_pcxdp_q0_hold_pa_l=%b, arbpc2_pcxdp_qsel0_pa=%b, arbpc2_pcxdp_qsel1_pa_l=%b, arbpc2_pcxdp_shift_px=%b",
                         expected_arbpc0_pcxdp_grant_pa, expected_arbpc0_pcxdp_q0_hold_pa_l, expected_arbpc0_pcxdp_qsel0_pa, expected_arbpc0_pcxdp_qsel1_pa_l, expected_arbpc0_pcxdp_shift_px, expected_arbpc2_pcxdp_grant_pa, expected_arbpc2_pcxdp_q0_hold_pa_l, expected_arbpc2_pcxdp_qsel0_pa, expected_arbpc2_pcxdp_qsel1_pa_l, expected_arbpc2_pcxdp_shift_px);
                $display("  Got:      arbpc0_pcxdp_grant_pa=%b, arbpc0_pcxdp_q0_hold_pa_l=%b, arbpc0_pcxdp_qsel0_pa=%b, arbpc0_pcxdp_qsel1_pa_l=%b, arbpc0_pcxdp_shift_px=%b, arbpc2_pcxdp_grant_pa=%b, arbpc2_pcxdp_q0_hold_pa_l=%b, arbpc2_pcxdp_qsel0_pa=%b, arbpc2_pcxdp_qsel1_pa_l=%b, arbpc2_pcxdp_shift_px=%b",
                         arbpc0_pcxdp_grant_pa, arbpc0_pcxdp_q0_hold_pa_l, arbpc0_pcxdp_qsel0_pa, arbpc0_pcxdp_qsel1_pa_l, arbpc0_pcxdp_shift_px, arbpc2_pcxdp_grant_pa, arbpc2_pcxdp_q0_hold_pa_l, arbpc2_pcxdp_qsel0_pa, arbpc2_pcxdp_qsel1_pa_l, arbpc2_pcxdp_shift_px);
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
