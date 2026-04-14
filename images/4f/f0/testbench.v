`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] a_to_clk_levm3;
    reg [7:0] b_to_clk_levm1;
    reg [7:0] c_com_levs10;
    reg clk;
    reg [7:0] d_to_clk_levm2;
    reg [7:0] one;
    wire [7:0] m_from_clk_lev1_r;
    wire [7:0] n_from_clk_lev2;
    wire [7:0] o_from_com_levs11;
    wire [7:0] o_from_comandclk_levs12;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a_to_clk_levm3(a_to_clk_levm3),
        .b_to_clk_levm1(b_to_clk_levm1),
        .c_com_levs10(c_com_levs10),
        .clk(clk),
        .d_to_clk_levm2(d_to_clk_levm2),
        .one(one),
        .m_from_clk_lev1_r(m_from_clk_lev1_r),
        .n_from_clk_lev2(n_from_clk_lev2),
        .o_from_com_levs11(o_from_com_levs11),
        .o_from_comandclk_levs12(o_from_comandclk_levs12)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        a_to_clk_levm3 = 8'h0;
        b_to_clk_levm1 = 8'h0;
        c_com_levs10   = 8'h0;
        d_to_clk_levm2 = 8'h0;
        one            = 8'h0;
        repeat (10) @(posedge clk);
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        reset_dut();
        a_to_clk_levm3 = 8'd10;
        b_to_clk_levm1 = 8'd20;
        d_to_clk_levm2 = 8'd30;
        c_com_levs10   = 8'd40;
        one            = 8'd1;

        repeat (10) @(posedge clk);

        #1;


        check_outputs(8'd60, 8'd60, 8'd41, 8'd41);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        reset_dut();
        a_to_clk_levm3 = 8'd0;
        b_to_clk_levm1 = 8'd0;
        d_to_clk_levm2 = 8'd0;
        c_com_levs10   = 8'd0;
        one            = 8'd0;
        repeat (10) @(posedge clk);
        #1;

        check_outputs(8'd0, 8'd0, 8'd0, 8'd0);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        reset_dut();
        a_to_clk_levm3 = 8'd100;
        b_to_clk_levm1 = 8'd100;
        d_to_clk_levm2 = 8'd100;
        c_com_levs10   = 8'd50;
        one            = 8'd10;
        repeat (10) @(posedge clk);


        #1;



        check_outputs(8'd44, 8'd44, 8'd60, 8'd60);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        reset_dut();
        a_to_clk_levm3 = 8'd1;
        b_to_clk_levm1 = 8'd1;
        d_to_clk_levm2 = 8'd1;
        c_com_levs10   = 8'd255;
        one            = 8'd1;
        repeat (10) @(posedge clk);


        #1;



        check_outputs(8'd3, 8'd3, 8'd0, 8'd0);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        reset_dut();
        a_to_clk_levm3 = 8'h80;
        b_to_clk_levm1 = 8'h40;
        d_to_clk_levm2 = 8'h20;
        c_com_levs10   = 8'h0A;
        one            = 8'h05;
        repeat (10) @(posedge clk);


        #1;



        check_outputs(8'hE0, 8'hE0, 8'h0F, 8'h0F);
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
        input [7:0] expected_m_from_clk_lev1_r;
        input [7:0] expected_n_from_clk_lev2;
        input [7:0] expected_o_from_com_levs11;
        input [7:0] expected_o_from_comandclk_levs12;
        begin
            if (expected_m_from_clk_lev1_r === (expected_m_from_clk_lev1_r ^ m_from_clk_lev1_r ^ expected_m_from_clk_lev1_r) &&
                expected_n_from_clk_lev2 === (expected_n_from_clk_lev2 ^ n_from_clk_lev2 ^ expected_n_from_clk_lev2) &&
                expected_o_from_com_levs11 === (expected_o_from_com_levs11 ^ o_from_com_levs11 ^ expected_o_from_com_levs11) &&
                expected_o_from_comandclk_levs12 === (expected_o_from_comandclk_levs12 ^ o_from_comandclk_levs12 ^ expected_o_from_comandclk_levs12)) begin
                $display("PASS");
                $display("  Outputs: m_from_clk_lev1_r=%h, n_from_clk_lev2=%h, o_from_com_levs11=%h, o_from_comandclk_levs12=%h",
                         m_from_clk_lev1_r, n_from_clk_lev2, o_from_com_levs11, o_from_comandclk_levs12);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: m_from_clk_lev1_r=%h, n_from_clk_lev2=%h, o_from_com_levs11=%h, o_from_comandclk_levs12=%h",
                         expected_m_from_clk_lev1_r, expected_n_from_clk_lev2, expected_o_from_com_levs11, expected_o_from_comandclk_levs12);
                $display("  Got:      m_from_clk_lev1_r=%h, n_from_clk_lev2=%h, o_from_com_levs11=%h, o_from_comandclk_levs12=%h",
                         m_from_clk_lev1_r, n_from_clk_lev2, o_from_com_levs11, o_from_comandclk_levs12);
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
        $dumpvars(0,a_to_clk_levm3, b_to_clk_levm1, c_com_levs10, clk, d_to_clk_levm2, one, m_from_clk_lev1_r, n_from_clk_lev2, o_from_com_levs11, o_from_comandclk_levs12);
    end

endmodule
