`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg aux_reset_in;
    reg dcm_locked;
    reg ext_reset_in;
    reg mb_debug_sys_rst;
    reg slowest_sync_clk;
    wire [4:0] lpf_int;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .aux_reset_in(aux_reset_in),
        .dcm_locked(dcm_locked),
        .ext_reset_in(ext_reset_in),
        .mb_debug_sys_rst(mb_debug_sys_rst),
        .slowest_sync_clk(slowest_sync_clk),
        .lpf_int(lpf_int)
    );

    // Clock generation (10ns period)
    initial begin
        slowest_sync_clk = 0;
        forever #5 slowest_sync_clk = ~slowest_sync_clk;
    end

        task reset_dut;

    begin
        ext_reset_in = 1'b1;
        mb_debug_sys_rst = 1'b1;
        aux_reset_in = 1'b1;
        dcm_locked = 1'b0;
        repeat(5) @(posedge slowest_sync_clk);
        #1;
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase 001: Reset active state");
        reset_dut();

        repeat(5) @(posedge slowest_sync_clk);
        #1;

        check_outputs(5'h00);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase 002: Accumulation partial (8 cycles)");
        reset_dut();

        ext_reset_in = 0;
        mb_debug_sys_rst = 0;
        aux_reset_in = 0;
        dcm_locked = 1;

        repeat(8) @(posedge slowest_sync_clk);
        #1;
        #1;

        check_outputs(5'h08);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase 003: Full accumulation (16+ cycles)");
        reset_dut();
        ext_reset_in = 0;
        mb_debug_sys_rst = 0;
        aux_reset_in = 0;
        dcm_locked = 1;

        repeat(20) @(posedge slowest_sync_clk);
        #1;
        #1;

        check_outputs(5'h10);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase 004: External Reset interruption");
        reset_dut();
        ext_reset_in = 0;
        mb_debug_sys_rst = 0;
        aux_reset_in = 0;
        dcm_locked = 1;
        repeat(20) @(posedge slowest_sync_clk);

        ext_reset_in = 1;
        @(posedge slowest_sync_clk);
        #1;
        #1;

        check_outputs(5'h00);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase 005: Aux Reset interruption");
        reset_dut();
        ext_reset_in = 0;
        mb_debug_sys_rst = 0;
        aux_reset_in = 0;
        dcm_locked = 1;
        repeat(20) @(posedge slowest_sync_clk);

        aux_reset_in = 1;
        @(posedge slowest_sync_clk);
        #1;
        #1;

        check_outputs(5'h00);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase 006: DCM Unlock interruption");
        reset_dut();
        ext_reset_in = 0;
        mb_debug_sys_rst = 0;
        aux_reset_in = 0;
        dcm_locked = 1;
        repeat(20) @(posedge slowest_sync_clk);

        dcm_locked = 0;
        @(posedge slowest_sync_clk);
        #1;
        #1;

        check_outputs(5'h00);
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
        input [4:0] expected_lpf_int;
        begin
            if (expected_lpf_int === (expected_lpf_int ^ lpf_int ^ expected_lpf_int)) begin
                $display("PASS");
                $display("  Outputs: lpf_int=%h",
                         lpf_int);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: lpf_int=%h",
                         expected_lpf_int);
                $display("  Got:      lpf_int=%h",
                         lpf_int);
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
        $dumpvars(0,aux_reset_in, dcm_locked, ext_reset_in, mb_debug_sys_rst, slowest_sync_clk, lpf_int);
    end

endmodule
