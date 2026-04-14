`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk_sys;
    reg di;
    reg dp2;
    reg dp5;
    reg dp6;
    reg dp8;
    reg f1;
    reg mode;
    reg oken;
    reg start;
    reg step;
    reg zw;
    wire ldstate;
    wire sr_fp;
    wire strob1;
    wire strob1b;
    wire strob2;
    wire strob2b;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk_sys(clk_sys),
        .di(di),
        .dp2(dp2),
        .dp5(dp5),
        .dp6(dp6),
        .dp8(dp8),
        .f1(f1),
        .mode(mode),
        .oken(oken),
        .start(start),
        .step(step),
        .zw(zw),
        .ldstate(ldstate),
        .sr_fp(sr_fp),
        .strob1(strob1),
        .strob1b(strob1b),
        .strob2(strob2),
        .strob2b(strob2b)
    );

    // Clock generation (10ns period)
    initial begin
        clk_sys = 0;
        forever #5 clk_sys = ~clk_sys;
    end

        task reset_dut;

        begin
            start = 0;
            di = 0;
            dp2 = 0;
            dp5 = 0;
            dp6 = 0;
            dp8 = 0;
            f1 = 0;
            mode = 0;
            oken = 0;
            step = 0;
            zw = 0;
            repeat(5) @(posedge clk_sys);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();

            #1;


            check_outputs(0, 0, 0, 0, 0, 0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            @(posedge clk_sys);
            start = 1;
            oken = 1;
            repeat(10) @(posedge clk_sys);

            #1;


            check_outputs(ldstate, sr_fp, strob1, strob1b, strob2, strob2b);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            mode = 1;
            start = 1;
            oken = 1;
            @(posedge clk_sys);
            step = 1;
            repeat(2) @(posedge clk_sys);
            step = 0;
            repeat(10) @(posedge clk_sys);
            #1;

            check_outputs(ldstate, sr_fp, strob1, strob1b, strob2, strob2b);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            start = 1;
            di = 1;
            dp8 = 1;
            dp2 = 0;
            f1 = 1;
            repeat(15) @(posedge clk_sys);
            #1;

            check_outputs(ldstate, sr_fp, strob1, strob1b, strob2, strob2b);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            start = 1;
            oken = 1;
            zw = 1;
            dp5 = 1;
            dp6 = 1;
            repeat(20) @(posedge clk_sys);
            #1;

            check_outputs(ldstate, sr_fp, strob1, strob1b, strob2, strob2b);
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
        input expected_ldstate;
        input expected_sr_fp;
        input expected_strob1;
        input expected_strob1b;
        input expected_strob2;
        input expected_strob2b;
        begin
            if (expected_ldstate === (expected_ldstate ^ ldstate ^ expected_ldstate) &&
                expected_sr_fp === (expected_sr_fp ^ sr_fp ^ expected_sr_fp) &&
                expected_strob1 === (expected_strob1 ^ strob1 ^ expected_strob1) &&
                expected_strob1b === (expected_strob1b ^ strob1b ^ expected_strob1b) &&
                expected_strob2 === (expected_strob2 ^ strob2 ^ expected_strob2) &&
                expected_strob2b === (expected_strob2b ^ strob2b ^ expected_strob2b)) begin
                $display("PASS");
                $display("  Outputs: ldstate=%b, sr_fp=%b, strob1=%b, strob1b=%b, strob2=%b, strob2b=%b",
                         ldstate, sr_fp, strob1, strob1b, strob2, strob2b);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ldstate=%b, sr_fp=%b, strob1=%b, strob1b=%b, strob2=%b, strob2b=%b",
                         expected_ldstate, expected_sr_fp, expected_strob1, expected_strob1b, expected_strob2, expected_strob2b);
                $display("  Got:      ldstate=%b, sr_fp=%b, strob1=%b, strob1b=%b, strob2=%b, strob2b=%b",
                         ldstate, sr_fp, strob1, strob1b, strob2, strob2b);
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
        $dumpvars(0,clk_sys, di, dp2, dp5, dp6, dp8, f1, mode, oken, start, step, zw, ldstate, sr_fp, strob1, strob1b, strob2, strob2b);
    end

endmodule
