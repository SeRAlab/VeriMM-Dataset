`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg BCLK;
    reg DACC_OK;
    reg DATA_HOLD;
    reg DC_ACC;
    reg DC_MDONE;
    reg DPTE_ACC;
    reg DRAM_WR;
    reg IACC_OK;
    reg IC_ACC;
    reg IC_MDONE;
    reg IC_READ;
    reg IPTE_ACC;
    reg KOLLISION;
    reg READ;
    wire [7:0] STATSIGS;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .BCLK(BCLK),
        .DACC_OK(DACC_OK),
        .DATA_HOLD(DATA_HOLD),
        .DC_ACC(DC_ACC),
        .DC_MDONE(DC_MDONE),
        .DPTE_ACC(DPTE_ACC),
        .DRAM_WR(DRAM_WR),
        .IACC_OK(IACC_OK),
        .IC_ACC(IC_ACC),
        .IC_MDONE(IC_MDONE),
        .IC_READ(IC_READ),
        .IPTE_ACC(IPTE_ACC),
        .KOLLISION(KOLLISION),
        .READ(READ),
        .STATSIGS(STATSIGS)
    );

    // Clock generation (10ns period)
    initial begin
        BCLK = 0;
        forever #5 BCLK = ~BCLK;
    end

        task reset_dut;

    begin
        READ = 0; DACC_OK = 0; DC_ACC = 0; DPTE_ACC = 0; DC_MDONE = 0;
        DRAM_WR = 0; IC_READ = 0; IACC_OK = 0; DATA_HOLD = 0; IC_ACC = 0;
        IPTE_ACC = 0; IC_MDONE = 0; KOLLISION = 0;
        @(posedge BCLK);
        #1;
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        reset_dut();
        $display("Testcase %0d: Initial Zero State", test_num);
        #1;

        check_outputs(8'h00);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        reset_dut();
        DRAM_WR = 1;
        @(posedge BCLK); #1;
        $display("Testcase %0d: DRAM_WR High", test_num);
        #1;

        check_outputs(8'h01);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        reset_dut();
        IC_READ = 1;
        IACC_OK = 1;
        @(posedge BCLK); #1;
        $display("Testcase %0d: IC_READ and IACC_OK", test_num);
        #1;

        check_outputs(8'h06);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        reset_dut();
        DATA_HOLD = 1;
        IC_ACC = 1;
        @(posedge BCLK); #1;
        $display("Testcase %0d: DATA_HOLD and IC_ACC", test_num);
        #1;

        check_outputs(8'h18);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        reset_dut();
        IPTE_ACC = 1;
        IC_MDONE = 1;
        @(posedge BCLK); #1;
        $display("Testcase %0d: IPTE_ACC and IC_MDONE", test_num);
        #1;

        check_outputs(8'h60);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        reset_dut();
        KOLLISION = 1;
        @(posedge BCLK); #1;
        $display("Testcase %0d: KOLLISION", test_num);
        #1;

        check_outputs(8'h80);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        reset_dut();
        DRAM_WR = 1;
        IACC_OK = 1;
        IC_ACC = 1;
        IC_MDONE = 1;
        @(posedge BCLK); #1;
        $display("Testcase %0d: Pattern 1010101 (Alt bits)", test_num);
        #1;

        check_outputs(8'h55);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        reset_dut();
        READ = 1;
        DACC_OK = 1;
        DC_ACC = 1;
        DPTE_ACC = 1;
        DC_MDONE = 1;
        @(posedge BCLK); #1;
        $display("Testcase %0d: Data-side inputs (expected to be ignored)", test_num);
        #1;

        check_outputs(8'h00);
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
        input [7:0] expected_STATSIGS;
        begin
            if (expected_STATSIGS === (expected_STATSIGS ^ STATSIGS ^ expected_STATSIGS)) begin
                $display("PASS");
                $display("  Outputs: STATSIGS=%h",
                         STATSIGS);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: STATSIGS=%h",
                         expected_STATSIGS);
                $display("  Got:      STATSIGS=%h",
                         STATSIGS);
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
        $dumpvars(0,BCLK, DACC_OK, DATA_HOLD, DC_ACC, DC_MDONE, DPTE_ACC, DRAM_WR, IACC_OK, IC_ACC, IC_MDONE, IC_READ, IPTE_ACC, KOLLISION, READ, STATSIGS);
    end

endmodule
