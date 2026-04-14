`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [2:0] coreid;
    reg [3:0] div_busy_e;
    reg [3:0] div_wait;
    reg [3:0] fp_busy_e;
    reg [3:0] fp_wait;
    reg [3:0] ldmiss;
    reg [3:0] mul_busy_e;
    reg [3:0] mul_wait;
    reg rst_l;
    reg [3:0] wm_imiss;
    reg [3:0] wm_other;
    reg [3:0] wm_stbwait;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .coreid(coreid),
        .div_busy_e(div_busy_e),
        .div_wait(div_wait),
        .fp_busy_e(fp_busy_e),
        .fp_wait(fp_wait),
        .ldmiss(ldmiss),
        .mul_busy_e(mul_busy_e),
        .mul_wait(mul_wait),
        .rst_l(rst_l),
        .wm_imiss(wm_imiss),
        .wm_other(wm_other),
        .wm_stbwait(wm_stbwait)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst_l = 0;
            coreid = 0;
            div_busy_e = 0;
            div_wait = 0;
            fp_busy_e = 0;
            fp_wait = 0;
            ldmiss = 0;
            mul_busy_e = 0;
            mul_wait = 0;
            wm_imiss = 0;
            wm_other = 0;
            wm_stbwait = 0;
            repeat(2) @(posedge clk);
            #2 rst_l = 1;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            reset_dut();
            @(posedge clk);
            wm_imiss = 4'hA;
            repeat(2) @(negedge clk);
            #1;

            check_outputs("Single signal change: wm_imiss");
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            reset_dut();
            @(posedge clk);
            coreid = 3'd5;
            mul_wait = 4'h3;
            div_busy_e = 4'hF;
            repeat(2) @(negedge clk);
            #1;

            check_outputs("Multiple signal changes");
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            reset_dut();
            @(posedge clk);
            ldmiss = 4'h1;
            repeat(2) @(negedge clk);
            @(posedge clk);
            ldmiss = 4'h0;
            repeat(2) @(negedge clk);
            #1;

            check_outputs("Signal toggling");
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            rst_l = 0;
            @(posedge clk);
            fp_wait = 4'h7;
            wm_other = 4'hB;
            repeat(2) @(negedge clk);
            rst_l = 1;
            repeat(1) @(posedge clk);
            #1;

            check_outputs("Changes during reset");
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            reset_dut();
            @(posedge clk);
            wm_imiss = 4'h1; wm_other = 4'h2; wm_stbwait = 4'h3;
            mul_wait = 4'h4; div_wait = 4'h5; fp_wait = 4'h6;
            mul_busy_e = 4'h7; div_busy_e = 4'h8; fp_busy_e = 4'h9;
            ldmiss = 4'hA;
            repeat(2) @(negedge clk);
            #1;

            check_outputs("Full signal burst");
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
        begin
            if () begin
                $display("PASS");
                $display("  Outputs: ",
                         );
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ",
                         );
                $display("  Got:      ",
                         );
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
        $dumpvars(0,clk, coreid, div_busy_e, div_wait, fp_busy_e, fp_wait, ldmiss, mul_busy_e, mul_wait, rst_l, wm_imiss, wm_other, wm_stbwait);
    end

endmodule
