`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [1:0] apat_1;
    reg bc_co;
    reg cr_pulse;
    reg de_clk;
    reg hb_clk;
    reg [31:0] mf_dorg_2;
    reg [31:0] mf_sorg_2;
    reg prst;
    reg [1:0] ps_sel_2;
    reg sd_selector;
    wire de_ca_rdy;
    wire [31:0] de_dorg_2;
    wire [31:0] de_sorg_2;
    wire [27:0] dorg_2;
    wire hb_ca_rdy;
    wire or_apat_1;
    wire prst_1;
    wire ps16s_2;
    wire ps565s_2;
    wire [27:0] sorg_2;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .apat_1(apat_1),
        .bc_co(bc_co),
        .cr_pulse(cr_pulse),
        .de_clk(de_clk),
        .hb_clk(hb_clk),
        .mf_dorg_2(mf_dorg_2),
        .mf_sorg_2(mf_sorg_2),
        .prst(prst),
        .ps_sel_2(ps_sel_2),
        .sd_selector(sd_selector),
        .de_ca_rdy(de_ca_rdy),
        .de_dorg_2(de_dorg_2),
        .de_sorg_2(de_sorg_2),
        .dorg_2(dorg_2),
        .hb_ca_rdy(hb_ca_rdy),
        .or_apat_1(or_apat_1),
        .prst_1(prst_1),
        .ps16s_2(ps16s_2),
        .ps565s_2(ps565s_2),
        .sorg_2(sorg_2)
    );

    // Clock generation (10ns period)
    initial begin
        de_clk = 0;
        forever #5 de_clk = ~de_clk;
    end

        task reset_dut;

        begin
            @(posedge de_clk);
            prst = 1'b1;
            apat_1 = 2'b0;
            bc_co = 1'b0;
            cr_pulse = 1'b0;
            mf_dorg_2 = 32'h0;
            mf_sorg_2 = 32'h0;
            ps_sel_2 = 2'b0;
            sd_selector = 1'b0;
            repeat (2) @(posedge de_clk);
            prst = 1'b0;
            @(posedge de_clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Reset Behavior", test_num);
            reset_dut();


            #1;



            check_outputs(1'b1, 32'h0, 32'h0, 28'h0, 1'b1, 1'b0, 1'b0, 1'b0, 1'b0, 28'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: 16-bit Selection (ps_sel_2=01)", test_num);
            reset_dut();

            ps_sel_2 = 2'b01;
            mf_sorg_2 = 32'hAAAA_BBBB;
            mf_dorg_2 = 32'hCCCC_DDDD;
            sd_selector = 1'b0;

            @(posedge de_clk);
            #1;


            #1;



            check_outputs(1'b1, 32'hCCCC_DDDD, 32'hAAAA_BBBB, 28'hCCC_DDDD, 1'b1, 1'b0, 1'b0, 1'b1, 1'b0, 28'hAAA_BBBB);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: 565 Selection (ps_sel_2=10)", test_num);
            reset_dut();

            ps_sel_2 = 2'b10;
            mf_sorg_2 = 32'h1234_5678;
            mf_dorg_2 = 32'h8765_4321;

            @(posedge de_clk);
            #1;


            #1;



            check_outputs(1'b1, 32'h8765_4321, 32'h1234_5678, 28'h765_4321, 1'b1, 1'b0, 1'b0, 1'b0, 1'b1, 28'h234_5678);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Selector Routing (sd_selector=1)", test_num);
            reset_dut();

            sd_selector = 1'b1;
            mf_sorg_2 = 32'hFFFF_0000;
            mf_dorg_2 = 32'h0000_FFFF;

            @(posedge de_clk);
            #1;


            #1;



            check_outputs(1'b1, 32'h0000_FFFF, 32'hFFFF_0000, 28'h000_FFFF, 1'b1, 1'b0, 1'b0, 1'b0, 1'b0, 28'hFFF_0000);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: apat_1 OR logic", test_num);
            reset_dut();

            apat_1 = 2'b10;

            @(posedge de_clk);
            #1;


            #1;



            check_outputs(1'b1, 32'h0, 32'h0, 28'h0, 1'b1, 1'b1, 1'b0, 1'b0, 1'b0, 28'h0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: ps_sel_2 = 0", test_num);
            reset_dut();

            ps_sel_2 = 2'b00;
            apat_1 = 2'b00;

            @(posedge de_clk);
            #1;


            #1;



            check_outputs(1'b1, 32'h0, 32'h0, 28'h0, 1'b1, 1'b0, 1'b0, 1'b0, 1'b0, 28'h0);
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
        input expected_de_ca_rdy;
        input [31:0] expected_de_dorg_2;
        input [31:0] expected_de_sorg_2;
        input [27:0] expected_dorg_2;
        input expected_hb_ca_rdy;
        input expected_or_apat_1;
        input expected_prst_1;
        input expected_ps16s_2;
        input expected_ps565s_2;
        input [27:0] expected_sorg_2;
        begin
            if (expected_de_ca_rdy === (expected_de_ca_rdy ^ de_ca_rdy ^ expected_de_ca_rdy) &&
                expected_de_dorg_2 === (expected_de_dorg_2 ^ de_dorg_2 ^ expected_de_dorg_2) &&
                expected_de_sorg_2 === (expected_de_sorg_2 ^ de_sorg_2 ^ expected_de_sorg_2) &&
                expected_dorg_2 === (expected_dorg_2 ^ dorg_2 ^ expected_dorg_2) &&
                expected_hb_ca_rdy === (expected_hb_ca_rdy ^ hb_ca_rdy ^ expected_hb_ca_rdy) &&
                expected_or_apat_1 === (expected_or_apat_1 ^ or_apat_1 ^ expected_or_apat_1) &&
                expected_prst_1 === (expected_prst_1 ^ prst_1 ^ expected_prst_1) &&
                expected_ps16s_2 === (expected_ps16s_2 ^ ps16s_2 ^ expected_ps16s_2) &&
                expected_ps565s_2 === (expected_ps565s_2 ^ ps565s_2 ^ expected_ps565s_2) &&
                expected_sorg_2 === (expected_sorg_2 ^ sorg_2 ^ expected_sorg_2)) begin
                $display("PASS");
                $display("  Outputs: de_ca_rdy=%b, de_dorg_2=%h, de_sorg_2=%h, dorg_2=%h, hb_ca_rdy=%b, or_apat_1=%b, prst_1=%b, ps16s_2=%b, ps565s_2=%b, sorg_2=%h",
                         de_ca_rdy, de_dorg_2, de_sorg_2, dorg_2, hb_ca_rdy, or_apat_1, prst_1, ps16s_2, ps565s_2, sorg_2);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: de_ca_rdy=%b, de_dorg_2=%h, de_sorg_2=%h, dorg_2=%h, hb_ca_rdy=%b, or_apat_1=%b, prst_1=%b, ps16s_2=%b, ps565s_2=%b, sorg_2=%h",
                         expected_de_ca_rdy, expected_de_dorg_2, expected_de_sorg_2, expected_dorg_2, expected_hb_ca_rdy, expected_or_apat_1, expected_prst_1, expected_ps16s_2, expected_ps565s_2, expected_sorg_2);
                $display("  Got:      de_ca_rdy=%b, de_dorg_2=%h, de_sorg_2=%h, dorg_2=%h, hb_ca_rdy=%b, or_apat_1=%b, prst_1=%b, ps16s_2=%b, ps565s_2=%b, sorg_2=%h",
                         de_ca_rdy, de_dorg_2, de_sorg_2, dorg_2, hb_ca_rdy, or_apat_1, prst_1, ps16s_2, ps565s_2, sorg_2);
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
        $dumpvars(0,apat_1, bc_co, cr_pulse, de_clk, hb_clk, mf_dorg_2, mf_sorg_2, prst, ps_sel_2, sd_selector, de_ca_rdy, de_dorg_2, de_sorg_2, dorg_2, hb_ca_rdy, or_apat_1, prst_1, ps16s_2, ps565s_2, sorg_2);
    end

endmodule
