`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg cfg_to_turnoff_n;
    reg clk;
    reg compl_done_i;
    reg req_compl_i;
    reg rst_n;
    wire cfg_turnoff_ok_n;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .cfg_to_turnoff_n(cfg_to_turnoff_n),
        .clk(clk),
        .compl_done_i(compl_done_i),
        .req_compl_i(req_compl_i),
        .rst_n(rst_n),
        .cfg_turnoff_ok_n(cfg_turnoff_ok_n)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst_n = 0;
            cfg_to_turnoff_n = 1;
            req_compl_i = 0;
            compl_done_i = 0;
            repeat(2) @(posedge clk);
            #1 rst_n = 1;
            repeat(1) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase 001: Initial state after reset");
            reset_dut();
            @(posedge clk);
            #1 #1;
 check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase 002: Turn-off request with no pending traffic");
            reset_dut();
            @(posedge clk);
            cfg_to_turnoff_n = 0;
            repeat(2) @(posedge clk);
            #1 #1;
 check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase 003: Turn-off request blocked by pending completion");
            reset_dut();
            @(posedge clk);
            req_compl_i = 1;
            @(posedge clk);
            req_compl_i = 0;
            cfg_to_turnoff_n = 0;
            repeat(2) @(posedge clk);
            #1 #1;
 check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase 004: Turn-off proceeding after completion done");
            reset_dut();
            @(posedge clk);
            req_compl_i = 1;
            @(posedge clk);
            req_compl_i = 0;
            cfg_to_turnoff_n = 0;
            repeat(2) @(posedge clk);

            compl_done_i = 1;
            @(posedge clk);
            compl_done_i = 0;
            repeat(2) @(posedge clk);
            #1 #1;
 check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase 005: Completion finished before turn-off request");
            reset_dut();
            @(posedge clk);
            req_compl_i = 1;
            @(posedge clk);
            req_compl_i = 0;
            @(posedge clk);
            compl_done_i = 1;
            @(posedge clk);
            compl_done_i = 0;
            @(posedge clk);
            cfg_to_turnoff_n = 0;
            repeat(2) @(posedge clk);
            #1 #1;
 check_outputs(1'b0);
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
        input expected_cfg_turnoff_ok_n;
        begin
            if (expected_cfg_turnoff_ok_n === (expected_cfg_turnoff_ok_n ^ cfg_turnoff_ok_n ^ expected_cfg_turnoff_ok_n)) begin
                $display("PASS");
                $display("  Outputs: cfg_turnoff_ok_n=%b",
                         cfg_turnoff_ok_n);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: cfg_turnoff_ok_n=%b",
                         expected_cfg_turnoff_ok_n);
                $display("  Got:      cfg_turnoff_ok_n=%b",
                         cfg_turnoff_ok_n);
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

    // Optional: Waveform dump for debugging
    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0,cfg_to_turnoff_n, clk, compl_done_i, req_compl_i, rst_n, cfg_turnoff_ok_n);
    end

endmodule
