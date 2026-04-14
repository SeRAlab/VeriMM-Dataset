`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg en;
    reg n_rst;
    wire its_fr_time;
    wire rst_ref_cnt;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .en(en),
        .n_rst(n_rst),
        .its_fr_time(its_fr_time),
        .rst_ref_cnt(rst_ref_cnt)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            n_rst = 0;
            en = 0;
            #20;
            n_rst = 1;
            #10;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            $display("Testcase 001: Verifying outputs after reset...");
            #1;
            #1;

            check_outputs(0, 0);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            $display("Testcase 002: Verifying en=0 prevents counter increment...");
            en = 0;
            repeat(100) @(posedge clk);
            #1;
            #1;

            check_outputs(0, 0);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            $display("Testcase 003: Waiting for its_fr_time signal...");
            en = 1;

            wait(its_fr_time === 1);
            #1;
            #1;

            check_outputs(1, rst_ref_cnt);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            $display("Testcase 004: Waiting for rst_ref_cnt signal...");
            en = 1;

            wait(rst_ref_cnt === 1);
            #1;
            #1;

            check_outputs(its_fr_time, 1);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            $display("Testcase 005: Testing async reset during operation...");
            en = 1;
            repeat(50) @(posedge clk);
            n_rst = 0;
            #2;
            #1;

            check_outputs(0, 0);
            n_rst = 1;
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
        input expected_its_fr_time;
        input expected_rst_ref_cnt;
        begin
            if (expected_its_fr_time === (expected_its_fr_time ^ its_fr_time ^ expected_its_fr_time) &&
                expected_rst_ref_cnt === (expected_rst_ref_cnt ^ rst_ref_cnt ^ expected_rst_ref_cnt)) begin
                $display("PASS");
                $display("  Outputs: its_fr_time=%b, rst_ref_cnt=%b",
                         its_fr_time, rst_ref_cnt);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: its_fr_time=%b, rst_ref_cnt=%b",
                         expected_its_fr_time, expected_rst_ref_cnt);
                $display("  Got:      its_fr_time=%b, rst_ref_cnt=%b",
                         its_fr_time, rst_ref_cnt);
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
        $dumpvars(0,clk, en, n_rst, its_fr_time, rst_ref_cnt);
    end

endmodule
