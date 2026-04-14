`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg clk_in;
    reg ddd;
    reg ddd0;
    reg pa;
    reg pb;
    reg pc;
    reg rst;
    reg [1:0] sell;
    wire clk0;
    wire clk1;
    wire clk2;
    wire clk3;
    wire df;
    wire df_0;
    wire p0;
    wire p00;
    wire p01;
    wire p02;
    wire p1;
    wire p2;
    wire pd;
    wire ph;
    wire ps;
    wire rst0;
    wire rst1;
    wire rst2;
    wire rst3;
    wire [1:0] sel_o;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk_in(clk_in),
        .ddd(ddd),
        .ddd0(ddd0),
        .pa(pa),
        .pb(pb),
        .pc(pc),
        .rst(rst),
        .sell(sell),
        .clk0(clk0),
        .clk1(clk1),
        .clk2(clk2),
        .clk3(clk3),
        .df(df),
        .df_0(df_0),
        .p0(p0),
        .p00(p00),
        .p01(p01),
        .p02(p02),
        .p1(p1),
        .p2(p2),
        .pd(pd),
        .ph(ph),
        .ps(ps),
        .rst0(rst0),
        .rst1(rst1),
        .rst2(rst2),
        .rst3(rst3),
        .sel_o(sel_o)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %0d: Testing Selection 0 (clk0 and rst0 active)", test_num);

        rst = 1; clk_in = 0; sell = 2'b00; pa = 0; pb = 0; pc = 0; ddd = 0; ddd0 = 0;
        #10;

        rst = 0; sell = 2'b00; clk_in = 1; pa = 1; pb = 0; pc = 1; ddd = 1; ddd0 = 0;
        #10;


        #1;



        check_outputs(1, 0, 0, 0, 1, 0, 1, 1, 0, 1, 0, 1, 0, 1, 1, 0, 1, 1, 1, 2'b00);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %0d: Testing Selection 1 (clk1 and rst1 active)", test_num);

        rst = 1; clk_in = 0; sell = 2'b01; pa = 0; pb = 0; pc = 0; ddd = 0; ddd0 = 0;
        #10;

        rst = 0; sell = 2'b01; clk_in = 1; pa = 0; pb = 1; pc = 0; ddd = 0; ddd0 = 1;
        #10;

        #1;


        check_outputs(0, 1, 0, 0, 0, 1, 0, 0, 1, 0, 1, 0, 1, 0, 0, 1, 0, 1, 1, 2'b01);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %0d: Testing Selection 2 (clk2 and rst2 active)", test_num);

        rst = 1; clk_in = 0; sell = 2'b10; pa = 0; pb = 0; pc = 0; ddd = 0; ddd0 = 0;
        #10;

        rst = 0; sell = 2'b10; clk_in = 1; pa = 1; pb = 1; pc = 1; ddd = 1; ddd0 = 1;
        #10;

        #1;


        check_outputs(0, 0, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 2'b10);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %0d: Testing Selection 3 (clk3 and rst3 active)", test_num);

        rst = 1; clk_in = 0; sell = 2'b11; pa = 0; pb = 0; pc = 0; ddd = 0; ddd0 = 0;
        #10;

        rst = 0; sell = 2'b11; clk_in = 1; pa = 1; pb = 0; pc = 0; ddd = 0; ddd0 = 0;
        #10;

        #1;


        check_outputs(0, 0, 0, 1, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 0, 2'b11);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %0d: Testing Global Reset propagation", test_num);

        rst = 1; clk_in = 0; sell = 2'b00; pa = 1; pb = 1; pc = 1; ddd = 1; ddd0 = 1;
        #10;

        rst = 1; sell = 2'b00; clk_in = 1;
        #10;

        #1;


        check_outputs(0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 2'b00);
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
        input expected_clk0;
        input expected_clk1;
        input expected_clk2;
        input expected_clk3;
        input expected_df;
        input expected_df_0;
        input expected_p0;
        input expected_p00;
        input expected_p01;
        input expected_p02;
        input expected_p1;
        input expected_p2;
        input expected_pd;
        input expected_ph;
        input expected_ps;
        input expected_rst0;
        input expected_rst1;
        input expected_rst2;
        input expected_rst3;
        input [1:0] expected_sel_o;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_clk0 === (expected_clk0 ^ clk0 ^ expected_clk0) &&
                expected_clk1 === (expected_clk1 ^ clk1 ^ expected_clk1) &&
                expected_clk2 === (expected_clk2 ^ clk2 ^ expected_clk2) &&
                expected_clk3 === (expected_clk3 ^ clk3 ^ expected_clk3) &&
                expected_df === (expected_df ^ df ^ expected_df) &&
                expected_df_0 === (expected_df_0 ^ df_0 ^ expected_df_0) &&
                expected_p0 === (expected_p0 ^ p0 ^ expected_p0) &&
                expected_p00 === (expected_p00 ^ p00 ^ expected_p00) &&
                expected_p01 === (expected_p01 ^ p01 ^ expected_p01) &&
                expected_p02 === (expected_p02 ^ p02 ^ expected_p02) &&
                expected_p1 === (expected_p1 ^ p1 ^ expected_p1) &&
                expected_p2 === (expected_p2 ^ p2 ^ expected_p2) &&
                expected_pd === (expected_pd ^ pd ^ expected_pd) &&
                expected_ph === (expected_ph ^ ph ^ expected_ph) &&
                expected_ps === (expected_ps ^ ps ^ expected_ps) &&
                expected_rst0 === (expected_rst0 ^ rst0 ^ expected_rst0) &&
                expected_rst1 === (expected_rst1 ^ rst1 ^ expected_rst1) &&
                expected_rst2 === (expected_rst2 ^ rst2 ^ expected_rst2) &&
                expected_rst3 === (expected_rst3 ^ rst3 ^ expected_rst3) &&
                expected_sel_o === (expected_sel_o ^ sel_o ^ expected_sel_o)) begin
                $display("PASS");
                $display("  Outputs: clk0=%b, clk1=%b, clk2=%b, clk3=%b, df=%b, df_0=%b, p0=%b, p00=%b, p01=%b, p02=%b, p1=%b, p2=%b, pd=%b, ph=%b, ps=%b, rst0=%b, rst1=%b, rst2=%b, rst3=%b, sel_o=%h",
                         clk0, clk1, clk2, clk3, df, df_0, p0, p00, p01, p02, p1, p2, pd, ph, ps, rst0, rst1, rst2, rst3, sel_o);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: clk0=%b, clk1=%b, clk2=%b, clk3=%b, df=%b, df_0=%b, p0=%b, p00=%b, p01=%b, p02=%b, p1=%b, p2=%b, pd=%b, ph=%b, ps=%b, rst0=%b, rst1=%b, rst2=%b, rst3=%b, sel_o=%h",
                         expected_clk0, expected_clk1, expected_clk2, expected_clk3, expected_df, expected_df_0, expected_p0, expected_p00, expected_p01, expected_p02, expected_p1, expected_p2, expected_pd, expected_ph, expected_ps, expected_rst0, expected_rst1, expected_rst2, expected_rst3, expected_sel_o);
                $display("  Got:      clk0=%b, clk1=%b, clk2=%b, clk3=%b, df=%b, df_0=%b, p0=%b, p00=%b, p01=%b, p02=%b, p1=%b, p2=%b, pd=%b, ph=%b, ps=%b, rst0=%b, rst1=%b, rst2=%b, rst3=%b, sel_o=%h",
                         clk0, clk1, clk2, clk3, df, df_0, p0, p00, p01, p02, p1, p2, pd, ph, ps, rst0, rst1, rst2, rst3, sel_o);
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
