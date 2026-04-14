`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg cfg_err_cpl_timeout_n;
    reg clk;
    reg decr_nfl;
    reg rst;
    wire inc_dec_b;
    wire nfl_num;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .cfg_err_cpl_timeout_n(cfg_err_cpl_timeout_n),
        .clk(clk),
        .decr_nfl(decr_nfl),
        .rst(rst),
        .inc_dec_b(inc_dec_b),
        .nfl_num(nfl_num)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            cfg_err_cpl_timeout_n = 1;
            decr_nfl = 0;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            $display("Testcase 001: Checking Idle state after Reset");
            cfg_err_cpl_timeout_n = 1;
            decr_nfl = 0;
            @(posedge clk);
            #1 #1;
 check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            $display("Testcase 002: Testing Decrement (decr_nfl=1)");
            cfg_err_cpl_timeout_n = 1;
            decr_nfl = 1;
            @(posedge clk);
            #1 #1;
 check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            $display("Testcase 003: Testing Increment (cfg_err_cpl_timeout_n=0)");
            cfg_err_cpl_timeout_n = 0;
            decr_nfl = 0;
            @(posedge clk);
            #1 #1;
 check_outputs(1'b1, 1'b1);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            $display("Testcase 004: Testing No-op/Idle return");

            cfg_err_cpl_timeout_n = 0;
            @(posedge clk);
            cfg_err_cpl_timeout_n = 1;
            decr_nfl = 0;
            @(posedge clk);
            #1 #1;
 check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            $display("Testcase 005: Testing Simultaneous Inc and Dec signals");

            cfg_err_cpl_timeout_n = 0;
            decr_nfl = 1;
            @(posedge clk);
            #1 #1;
 check_outputs(1'b1, 1'b1);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = 6;
            $display("Testcase 006: Verifying reset overrides inputs");
            rst = 1;
            cfg_err_cpl_timeout_n = 0;
            decr_nfl = 1;
            @(posedge clk);
            #1 #1;
 check_outputs(1'b0, 1'b0);
            rst = 0;
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
        input expected_inc_dec_b;
        input expected_nfl_num;
        begin
            if (expected_inc_dec_b === (expected_inc_dec_b ^ inc_dec_b ^ expected_inc_dec_b) &&
                expected_nfl_num === (expected_nfl_num ^ nfl_num ^ expected_nfl_num)) begin
                $display("PASS");
                $display("  Outputs: inc_dec_b=%b, nfl_num=%b",
                         inc_dec_b, nfl_num);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: inc_dec_b=%b, nfl_num=%b",
                         expected_inc_dec_b, expected_nfl_num);
                $display("  Got:      inc_dec_b=%b, nfl_num=%b",
                         inc_dec_b, nfl_num);
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
        $dumpvars(0,cfg_err_cpl_timeout_n, clk, decr_nfl, rst, inc_dec_b, nfl_num);
    end

endmodule
