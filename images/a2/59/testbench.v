`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg _0_v;
    reg carry;
    reg cleg;
    reg clk_sys;
    reg exx;
    reg exy;
    reg lrp;
    reg s0;
    reg s_1;
    reg strob1b;
    reg ust_mc;
    reg ust_v;
    reg ust_x;
    reg ust_y;
    reg ust_z;
    reg vg;
    reg vl;
    reg [15:0] w;
    reg w_legy;
    reg w_zmvc;
    reg zer;
    reg zs;
    wire [15:0] r0;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        ._0_v(_0_v),
        .carry(carry),
        .cleg(cleg),
        .clk_sys(clk_sys),
        .exx(exx),
        .exy(exy),
        .lrp(lrp),
        .s0(s0),
        .s_1(s_1),
        .strob1b(strob1b),
        .ust_mc(ust_mc),
        .ust_v(ust_v),
        .ust_x(ust_x),
        .ust_y(ust_y),
        .ust_z(ust_z),
        .vg(vg),
        .vl(vl),
        .w(w),
        .w_legy(w_legy),
        .w_zmvc(w_zmvc),
        .zer(zer),
        .zs(zs),
        .r0(r0)
    );

    // Clock generation (10ns period)
    initial begin
        clk_sys = 0;
        forever #5 clk_sys = ~clk_sys;
    end

        task reset_dut;

        begin
            zer = 1;
            strob1b = 0;
            w = 16'h0000;
            lrp = 0;
            ust_z = 0; ust_v = 0; ust_mc = 0; ust_y = 0; ust_x = 0;
            w_zmvc = 0; w_legy = 0;
            zs = 0; carry = 0; vl = 0; vg = 0; exy = 0; exx = 0;
            cleg = 0; s0 = 0; s_1 = 0; _0_v = 0;
            #15;
            zer = 0;
            #10;
        end
        endtask
    task testcase001;

        begin
            reset_dut();

            #1;


            check_outputs(16'h0000);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            w = 16'hACE0;
            strob1b = 1;
            lrp = 1;
            @(posedge clk_sys);
            #2;
            #1;

            check_outputs(16'hACE0);
        end
        endtask

    task testcase003;

        begin
            reset_dut();

            w = 16'h0000;
            strob1b = 1;
            lrp = 1;
            @(posedge clk_sys);
            #2;

            lrp = 0;
            ust_z = 1;
            zs = 1;
            @(posedge clk_sys);
            #2;


            if (r0 != 16'h0000) begin
                pass_count = pass_count + 1;
                $display("Test 003: PASS (Z bit updated)");
            end else begin
                fail_count = fail_count + 1;
                $display("Test 003: FAIL (Z bit not updated)");
            end
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            w = 16'hF0F0;
            strob1b = 1;
            w_zmvc = 1;
            @(posedge clk_sys);
            #2;


            if (r0 != 16'h0000) begin
                pass_count = pass_count + 1;
                $display("Test 004: PASS (ZMVC bits updated)");
            end else begin
                fail_count = fail_count + 1;
                $display("Test 004: FAIL (ZMVC bits not updated)");
            end
        end
        endtask

    task testcase005;

        begin
            reset_dut();

            w = 16'hFFFF;
            strob1b = 1;
            lrp = 1;
            @(posedge clk_sys);
            #2;

            lrp = 0;
            cleg = 1;
            @(posedge clk_sys);
            #2;

            if (r0 != 16'hFFFF) begin
                pass_count = pass_count + 1;
                $display("Test 005: PASS (cleg modification detected)");
            end else begin
                fail_count = fail_count + 1;
                $display("Test 005: FAIL (cleg had no effect)");
            end
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
        input [15:0] expected_r0;
        begin
            if (expected_r0 === (expected_r0 ^ r0 ^ expected_r0)) begin
                $display("PASS");
                $display("  Outputs: r0=%h",
                         r0);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: r0=%h",
                         expected_r0);
                $display("  Got:      r0=%h",
                         r0);
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
        $dumpvars(0,_0_v, carry, cleg, clk_sys, exx, exy, lrp, s0, s_1, strob1b, ust_mc, ust_v, ust_x, ust_y, ust_z, vg, vl, w, w_legy, w_zmvc, zer, zs, r0);
    end

endmodule
