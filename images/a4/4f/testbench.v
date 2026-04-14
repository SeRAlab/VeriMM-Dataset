`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg hard_reset_n;
    reg reset_l;
    reg se;
    reg si_l;
    reg synced_upd_imped;
    wire avgcntr_rst;
    wire bypass;
    wire global_reset_n;
    wire int_sclk;
    wire sclk;
    wire so_l;
    wire updclk;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .hard_reset_n(hard_reset_n),
        .reset_l(reset_l),
        .se(se),
        .si_l(si_l),
        .synced_upd_imped(synced_upd_imped),
        .avgcntr_rst(avgcntr_rst),
        .bypass(bypass),
        .global_reset_n(global_reset_n),
        .int_sclk(int_sclk),
        .sclk(sclk),
        .so_l(so_l),
        .updclk(updclk)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            test_num = test_num + 1;
            $display("\n--- Testcase %0d ---", test_num);
            hard_reset_n = 0;
            reset_l = 0;
            se = 0;
            si_l = 0;
            synced_upd_imped = 0;
            repeat (2) @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();



            #1;




            check_outputs(1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            hard_reset_n = 1;
            reset_l = 1;
            repeat (5) @(posedge clk);
            #1;


            #1;



            check_outputs(1'b0, 1'b0, 1'b1, 1'b0, 1'b0, 1'b0, 1'b0);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            hard_reset_n = 1;
            reset_l = 1;
            si_l = 1;
            repeat (20) @(posedge clk);
            #1;




            #1;





            check_outputs(1'b0, 1'b0, 1'b1, 1'b0, 1'b0, 1'b1, 1'b0);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            hard_reset_n = 1;
            reset_l = 1;
            synced_upd_imped = 1;
            repeat (5) @(posedge clk);
            #1;

            #1;


            check_outputs(1'b1, 1'b0, 1'b1, 1'b0, 1'b0, 1'b0, 1'b0);
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
        input expected_avgcntr_rst;
        input expected_bypass;
        input expected_global_reset_n;
        input expected_int_sclk;
        input expected_sclk;
        input expected_so_l;
        input expected_updclk;
        begin
            if (expected_avgcntr_rst === (expected_avgcntr_rst ^ avgcntr_rst ^ expected_avgcntr_rst) &&
                expected_bypass === (expected_bypass ^ bypass ^ expected_bypass) &&
                expected_global_reset_n === (expected_global_reset_n ^ global_reset_n ^ expected_global_reset_n) &&
                expected_int_sclk === (expected_int_sclk ^ int_sclk ^ expected_int_sclk) &&
                expected_sclk === (expected_sclk ^ sclk ^ expected_sclk) &&
                expected_so_l === (expected_so_l ^ so_l ^ expected_so_l) &&
                expected_updclk === (expected_updclk ^ updclk ^ expected_updclk)) begin
                $display("PASS");
                $display("  Outputs: avgcntr_rst=%b, bypass=%b, global_reset_n=%b, int_sclk=%b, sclk=%b, so_l=%b, updclk=%b",
                         avgcntr_rst, bypass, global_reset_n, int_sclk, sclk, so_l, updclk);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: avgcntr_rst=%b, bypass=%b, global_reset_n=%b, int_sclk=%b, sclk=%b, so_l=%b, updclk=%b",
                         expected_avgcntr_rst, expected_bypass, expected_global_reset_n, expected_int_sclk, expected_sclk, expected_so_l, expected_updclk);
                $display("  Got:      avgcntr_rst=%b, bypass=%b, global_reset_n=%b, int_sclk=%b, sclk=%b, so_l=%b, updclk=%b",
                         avgcntr_rst, bypass, global_reset_n, int_sclk, sclk, so_l, updclk);
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
        $dumpvars(0,clk, hard_reset_n, reset_l, se, si_l, synced_upd_imped, avgcntr_rst, bypass, global_reset_n, int_sclk, sclk, so_l, updclk);
    end

endmodule
