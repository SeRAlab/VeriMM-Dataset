`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg clk;
    reg pic_wakeup;
    reg pm_cpustall;
    reg rst;
    reg [31:0] spr_addr;
    reg [31:0] spr_dat_i;
    reg spr_write;
    wire [3:0] pm_clksd;
    wire pm_cpu_gate;
    wire pm_dc_gate;
    wire pm_dmmu_gate;
    wire pm_ic_gate;
    wire pm_immu_gate;
    wire pm_lvolt;
    wire pm_tt_gate;
    wire pm_wakeup;
    wire [31:0] spr_dat_o;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .pic_wakeup(pic_wakeup),
        .pm_cpustall(pm_cpustall),
        .rst(rst),
        .spr_addr(spr_addr),
        .spr_dat_i(spr_dat_i),
        .spr_write(spr_write),
        .pm_clksd(pm_clksd),
        .pm_cpu_gate(pm_cpu_gate),
        .pm_dc_gate(pm_dc_gate),
        .pm_dmmu_gate(pm_dmmu_gate),
        .pm_ic_gate(pm_ic_gate),
        .pm_immu_gate(pm_immu_gate),
        .pm_lvolt(pm_lvolt),
        .pm_tt_gate(pm_tt_gate),
        .pm_wakeup(pm_wakeup),
        .spr_dat_o(spr_dat_o)
    );
    task testcase001;

        begin
            $display("Testcase 001: Reset and Default State Check");
            rst = 1;
            pic_wakeup = 0;
            pm_cpustall = 0;
            spr_write = 0;
            spr_addr = 32'h0;
            spr_dat_i = 32'h0;

            #20;
            rst = 0;
            #20;


            #1;



            check_outputs(4'h0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b1, 32'h0);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Wakeup Signals High Check");
            rst = 1;
            #20;
            rst = 0;


            pic_wakeup = 1;
            pm_cpustall = 1;
            #40;


            #1;



            check_outputs(4'h0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b1, 32'h0);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: SPR Access Check");
            rst = 1;
            #20;
            rst = 0;


            spr_write = 1;
            spr_addr = 32'hA0A0_A0A0;
            spr_dat_i = 32'hFFFF_FFFF;
            #20;
            spr_write = 0;
            #20;


            #1;



            check_outputs(4'h0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b1, 32'h0);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Random Input Toggling Check");
            rst = 1;
            #20;
            rst = 0;


            pic_wakeup = 1; spr_write = 1; spr_addr = 32'h1234; spr_dat_i = 32'h5678;
            #10;
            pic_wakeup = 0; spr_write = 0; pm_cpustall = 1;
            #10;
            pic_wakeup = 1; spr_addr = 32'hDEADBEEF;
            #20;


            #1;



            check_outputs(4'h0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b1, 32'h0);
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
        input [3:0] expected_pm_clksd;
        input expected_pm_cpu_gate;
        input expected_pm_dc_gate;
        input expected_pm_dmmu_gate;
        input expected_pm_ic_gate;
        input expected_pm_immu_gate;
        input expected_pm_lvolt;
        input expected_pm_tt_gate;
        input expected_pm_wakeup;
        input [31:0] expected_spr_dat_o;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_pm_clksd === (expected_pm_clksd ^ pm_clksd ^ expected_pm_clksd) &&
                expected_pm_cpu_gate === (expected_pm_cpu_gate ^ pm_cpu_gate ^ expected_pm_cpu_gate) &&
                expected_pm_dc_gate === (expected_pm_dc_gate ^ pm_dc_gate ^ expected_pm_dc_gate) &&
                expected_pm_dmmu_gate === (expected_pm_dmmu_gate ^ pm_dmmu_gate ^ expected_pm_dmmu_gate) &&
                expected_pm_ic_gate === (expected_pm_ic_gate ^ pm_ic_gate ^ expected_pm_ic_gate) &&
                expected_pm_immu_gate === (expected_pm_immu_gate ^ pm_immu_gate ^ expected_pm_immu_gate) &&
                expected_pm_lvolt === (expected_pm_lvolt ^ pm_lvolt ^ expected_pm_lvolt) &&
                expected_pm_tt_gate === (expected_pm_tt_gate ^ pm_tt_gate ^ expected_pm_tt_gate) &&
                expected_pm_wakeup === (expected_pm_wakeup ^ pm_wakeup ^ expected_pm_wakeup) &&
                expected_spr_dat_o === (expected_spr_dat_o ^ spr_dat_o ^ expected_spr_dat_o)) begin
                $display("PASS");
                $display("  Outputs: pm_clksd=%h, pm_cpu_gate=%b, pm_dc_gate=%b, pm_dmmu_gate=%b, pm_ic_gate=%b, pm_immu_gate=%b, pm_lvolt=%b, pm_tt_gate=%b, pm_wakeup=%b, spr_dat_o=%h",
                         pm_clksd, pm_cpu_gate, pm_dc_gate, pm_dmmu_gate, pm_ic_gate, pm_immu_gate, pm_lvolt, pm_tt_gate, pm_wakeup, spr_dat_o);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: pm_clksd=%h, pm_cpu_gate=%b, pm_dc_gate=%b, pm_dmmu_gate=%b, pm_ic_gate=%b, pm_immu_gate=%b, pm_lvolt=%b, pm_tt_gate=%b, pm_wakeup=%b, spr_dat_o=%h",
                         expected_pm_clksd, expected_pm_cpu_gate, expected_pm_dc_gate, expected_pm_dmmu_gate, expected_pm_ic_gate, expected_pm_immu_gate, expected_pm_lvolt, expected_pm_tt_gate, expected_pm_wakeup, expected_spr_dat_o);
                $display("  Got:      pm_clksd=%h, pm_cpu_gate=%b, pm_dc_gate=%b, pm_dmmu_gate=%b, pm_ic_gate=%b, pm_immu_gate=%b, pm_lvolt=%b, pm_tt_gate=%b, pm_wakeup=%b, spr_dat_o=%h",
                         pm_clksd, pm_cpu_gate, pm_dc_gate, pm_dmmu_gate, pm_ic_gate, pm_immu_gate, pm_lvolt, pm_tt_gate, pm_wakeup, spr_dat_o);
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
