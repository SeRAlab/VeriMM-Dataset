`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg _0_t;
    reg clk_sys;
    reg clockta;
    reg clocktb;
    reg clocktc;
    reg [39:0] k;
    reg m_1;
    reg t_1_d;
    reg taa;
    reg tab;
    reg trb;
    wire [40:0] t;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        ._0_t(_0_t),
        .clk_sys(clk_sys),
        .clockta(clockta),
        .clocktb(clocktb),
        .clocktc(clocktc),
        .k(k),
        .m_1(m_1),
        .t_1_d(t_1_d),
        .taa(taa),
        .tab(tab),
        .trb(trb),
        .t(t)
    );

    // Clock generation (10ns period)
    initial begin
        _0_t = 0;
        forever #5 _0_t = ~_0_t;
    end

        task reset_dut;

    begin

        _0_t = 0;
        clk_sys = 0;
        clockta = 0;
        clocktb = 0;
        clocktc = 0;
        taa = 0;
        tab = 0;
        trb = 0;
        k = 40'h0;
        m_1 = 0;
        t_1_d = 0;
        #20;
        _0_t = 1;
        #20;
    end
        endtask
    task testcase001;

    begin
        reset_dut();
        test_num = 1;

        #1;


        check_outputs(41'h0_0000_0000_00);
    end
        endtask

    task testcase002;

    begin
        reset_dut();
        test_num = 2;


        k = 40'hABCD_0000_00;
        taa = 1;
        #10 clockta = 1;
        #10 clockta = 0;
        #10;
        #1;

        check_outputs(41'h0_ABCD_0000_00);
    end
        endtask

    task testcase003;

    begin
        reset_dut();
        test_num = 3;


        k = 40'h0000_1234_00;
        tab = 1;
        #10 clocktb = 1;
        #10 clocktb = 0;
        #10;
        #1;

        check_outputs(41'h0_0000_1234_00);
    end
        endtask

    task testcase004;

    begin
        reset_dut();
        test_num = 4;


        k = 40'h0000_0000_EF;
        trb = 1;
        #10 clocktc = 1;
        #10 clocktc = 0;
        #10;
        #1;

        check_outputs(41'h0_0000_0000_EF);
    end
        endtask

    task testcase005;

    begin
        reset_dut();
        test_num = 5;

        k = 40'h5555_AAAA_C3;
        taa = 1; tab = 1; trb = 1;
        #10;
        clockta = 1; clocktb = 1; clocktc = 1;
        #10;
        clockta = 0; clocktb = 0; clocktc = 0;
        #10;
        #1;

        check_outputs(41'h0_5555_AAAA_C3);
    end
        endtask

    task testcase006;

    begin
        reset_dut();
        test_num = 6;

        t_1_d = 1;
        k = 40'hFFFF_FFFF_FF;
        taa = 1; tab = 1; trb = 1;
        #10;
        clockta = 1; clocktb = 1; clocktc = 1;
        #10;
        clockta = 0; clocktb = 0; clocktc = 0;
        #10;

        #1;


        check_outputs(41'h1_FFFF_FFFF_FF);
    end
        endtask

    task testcase007;

    begin
        reset_dut();
        test_num = 7;

        k = 40'hAAAA_BBBB_CC;
        m_1 = 1;
        taa = 0; tab = 0; trb = 0;
        #10;
        clockta = 1; clocktb = 1; clocktc = 1;
        #10;
        clockta = 0; clocktb = 0; clocktc = 0;
        #10;

        #1;


        check_outputs(41'h0_0000_0000_00);
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
        input [40:0] expected_t;
        begin
            if (expected_t === (expected_t ^ t ^ expected_t)) begin
                $display("PASS");
                $display("  Outputs: t=%h",
                         t);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: t=%h",
                         expected_t);
                $display("  Got:      t=%h",
                         t);
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
        $dumpvars(0,_0_t, clk_sys, clockta, clocktb, clocktc, k, m_1, t_1_d, taa, tab, trb, t);
    end

endmodule
