`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg asyn_stall;
    reg flush_branch;
    reg flush_except;
    reg if_stall;
    reg lsu_stall;
    reg [1:0] multicycle_cnt;
    wire ex_freeze;
    wire flushpipe;
    wire id_freeze;
    wire if_freeze;
    wire pc_freeze;
    wire wb_freeze;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .asyn_stall(asyn_stall),
        .flush_branch(flush_branch),
        .flush_except(flush_except),
        .if_stall(if_stall),
        .lsu_stall(lsu_stall),
        .multicycle_cnt(multicycle_cnt),
        .ex_freeze(ex_freeze),
        .flushpipe(flushpipe),
        .id_freeze(id_freeze),
        .if_freeze(if_freeze),
        .pc_freeze(pc_freeze),
        .wb_freeze(wb_freeze)
    );
    task testcase001;

        begin
            $display("\nRunning Testcase 001: Normal Operation (No Stalls/Flushes)");
            test_num = test_num + 1;
            asyn_stall = 0;
            flush_branch = 0;
            flush_except = 0;
            if_stall = 0;
            lsu_stall = 0;
            multicycle_cnt = 2'b00;

            #1;


            check_outputs(0, 0, 0, 0, 0, 0);
        end
        endtask

    task testcase002;

        begin
            $display("\nRunning Testcase 002: Flush Exception");
            test_num = test_num + 1;
            asyn_stall = 0;
            flush_branch = 0;
            flush_except = 1;
            if_stall = 0;
            lsu_stall = 0;
            multicycle_cnt = 2'b00;

            #1;


            check_outputs(0, 1, 0, 0, 1, 0);
        end
        endtask

    task testcase003;

        begin
            $display("\nRunning Testcase 003: Flush Branch");
            test_num = test_num + 1;
            asyn_stall = 0;
            flush_branch = 1;
            flush_except = 0;
            if_stall = 0;
            lsu_stall = 0;
            multicycle_cnt = 2'b00;

            #1;


            check_outputs(0, 1, 0, 0, 1, 0);
        end
        endtask

    task testcase004;

        begin
            $display("\nRunning Testcase 004: Instruction Fetch (IF) Stall");
            test_num = test_num + 1;
            asyn_stall = 0;
            flush_branch = 0;
            flush_except = 0;
            if_stall = 1;
            lsu_stall = 0;
            multicycle_cnt = 2'b00;

            #1;


            check_outputs(0, 0, 0, 1, 1, 0);
        end
        endtask

    task testcase005;

        begin
            $display("\nRunning Testcase 005: Load-Store Unit (LSU) Stall");
            test_num = test_num + 1;
            asyn_stall = 0;
            flush_branch = 0;
            flush_except = 0;
            if_stall = 0;
            lsu_stall = 1;
            multicycle_cnt = 2'b00;

            #1;


            check_outputs(1, 0, 1, 1, 1, 0);
        end
        endtask

    task testcase006;

        begin
            $display("\nRunning Testcase 006: Multicycle Counter Operation");
            test_num = test_num + 1;
            asyn_stall = 0;
            flush_branch = 0;
            flush_except = 0;
            if_stall = 0;
            lsu_stall = 0;
            multicycle_cnt = 2'b10;

            #1;


            check_outputs(1, 0, 1, 1, 1, 0);
        end
        endtask

    task testcase007;

        begin
            $display("\nRunning Testcase 007: Asynchronous Stall");
            test_num = test_num + 1;
            asyn_stall = 1;
            flush_branch = 0;
            flush_except = 0;
            if_stall = 0;
            lsu_stall = 0;
            multicycle_cnt = 2'b00;

            #1;


            check_outputs(1, 0, 1, 1, 1, 1);
        end
        endtask

    task testcase008;

        begin
            $display("\nRunning Testcase 008: Combinational Flush and IF Stall");
            test_num = test_num + 1;
            asyn_stall = 0;
            flush_branch = 0;
            flush_except = 1;
            if_stall = 1;
            lsu_stall = 0;
            multicycle_cnt = 2'b00;

            #1;


            check_outputs(0, 1, 0, 1, 1, 0);
        end
        endtask

    task testcase009;

        begin
            $display("\nRunning Testcase 009: Global Freeze Hierarchy (LSU + IF)");
            test_num = test_num + 1;
            asyn_stall = 0;
            flush_branch = 0;
            flush_except = 0;
            if_stall = 1;
            lsu_stall = 1;
            multicycle_cnt = 2'b00;

            #1;


            check_outputs(1, 0, 1, 1, 1, 0);
        end
        endtask

    task testcase010;

        begin
            $display("\nRunning Testcase 010: Reset State / Clearing Stalls");
            test_num = test_num + 1;
            asyn_stall = 0;
            flush_branch = 0;
            flush_except = 0;
            if_stall = 0;
            lsu_stall = 0;
            multicycle_cnt = 2'b00;
            #1;

            check_outputs(0, 0, 0, 0, 0, 0);
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
        testcase009();
        testcase010();
        
        
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
        input expected_ex_freeze;
        input expected_flushpipe;
        input expected_id_freeze;
        input expected_if_freeze;
        input expected_pc_freeze;
        input expected_wb_freeze;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_ex_freeze === (expected_ex_freeze ^ ex_freeze ^ expected_ex_freeze) &&
                expected_flushpipe === (expected_flushpipe ^ flushpipe ^ expected_flushpipe) &&
                expected_id_freeze === (expected_id_freeze ^ id_freeze ^ expected_id_freeze) &&
                expected_if_freeze === (expected_if_freeze ^ if_freeze ^ expected_if_freeze) &&
                expected_pc_freeze === (expected_pc_freeze ^ pc_freeze ^ expected_pc_freeze) &&
                expected_wb_freeze === (expected_wb_freeze ^ wb_freeze ^ expected_wb_freeze)) begin
                $display("PASS");
                $display("  Outputs: ex_freeze=%b, flushpipe=%b, id_freeze=%b, if_freeze=%b, pc_freeze=%b, wb_freeze=%b",
                         ex_freeze, flushpipe, id_freeze, if_freeze, pc_freeze, wb_freeze);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ex_freeze=%b, flushpipe=%b, id_freeze=%b, if_freeze=%b, pc_freeze=%b, wb_freeze=%b",
                         expected_ex_freeze, expected_flushpipe, expected_id_freeze, expected_if_freeze, expected_pc_freeze, expected_wb_freeze);
                $display("  Got:      ex_freeze=%b, flushpipe=%b, id_freeze=%b, if_freeze=%b, pc_freeze=%b, wb_freeze=%b",
                         ex_freeze, flushpipe, id_freeze, if_freeze, pc_freeze, wb_freeze);
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
