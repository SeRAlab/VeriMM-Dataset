`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clock;
    reg enable;
    reg [63:0] i_oneMinusUz_2;
    reg [63:0] i_sa2_2;
    reg [31:0] i_ux_transmitted;
    reg [31:0] i_uy_transmitted;
    reg [31:0] i_uz2;
    reg [63:0] i_uz2_2;
    reg [63:0] i_uz_2;
    reg reset;
    wire [63:0] o_oneMinusUz_2;
    wire [63:0] o_sa2_2;
    wire [31:0] o_ux_transmitted;
    wire [31:0] o_uy_transmitted;
    wire [31:0] o_uz2;
    wire [63:0] o_uz2_2;
    wire [63:0] o_uz_2;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clock(clock),
        .enable(enable),
        .i_oneMinusUz_2(i_oneMinusUz_2),
        .i_sa2_2(i_sa2_2),
        .i_ux_transmitted(i_ux_transmitted),
        .i_uy_transmitted(i_uy_transmitted),
        .i_uz2(i_uz2),
        .i_uz2_2(i_uz2_2),
        .i_uz_2(i_uz_2),
        .reset(reset),
        .o_oneMinusUz_2(o_oneMinusUz_2),
        .o_sa2_2(o_sa2_2),
        .o_ux_transmitted(o_ux_transmitted),
        .o_uy_transmitted(o_uy_transmitted),
        .o_uz2(o_uz2),
        .o_uz2_2(o_uz2_2),
        .o_uz_2(o_uz_2)
    );

    // Clock generation (10ns period)
    initial begin
        clock = 0;
        forever #5 clock = ~clock;
    end

        task reset_dut;

        begin
            reset = 1;
            enable = 0;
            i_oneMinusUz_2 = 64'h0;
            i_sa2_2 = 64'h0;
            i_ux_transmitted = 32'h0;
            i_uy_transmitted = 32'h0;
            i_uz2 = 32'h0;
            i_uz2_2 = 64'h0;
            i_uz_2 = 64'h0;
            @(posedge clock);
            #1 reset = 0;
            @(posedge clock);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Reset Behavior", test_num);
            reset_dut();

            #1;


            check_outputs(64'h0, 64'h0, 32'h0, 32'h0, 32'h0, 64'h0, 64'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Normal Data Transfer (Enable=1)", test_num);
            reset_dut();

            enable = 1;
            i_oneMinusUz_2   = 64'hAAAA_BBBB_CCCC_DDDD;
            i_sa2_2          = 64'h1111_2222_3333_4444;
            i_ux_transmitted = 32'h5555_6666;
            i_uy_transmitted = 32'h7777_8888;
            i_uz2            = 32'h9999_0000;
            i_uz2_2          = 64'hEEEE_FFFF_0000_1111;
            i_uz_2           = 64'h1234_5678_9ABC_DEF0;

            @(posedge clock);
            #2;

            #1;


            check_outputs(
                64'hAAAA_BBBB_CCCC_DDDD,
                64'h1111_2222_3333_4444,
                32'h5555_6666,
                32'h7777_8888,
                32'h9999_0000,
                64'hEEEE_FFFF_0000_1111,
                64'h1234_5678_9ABC_DEF0
            );
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Enable Control (Enable=0)", test_num);
            reset_dut();


            enable = 1;
            i_oneMinusUz_2   = 64'h0000_0000_0000_0001;
            i_sa2_2          = 64'h0000_0000_0000_0002;
            i_ux_transmitted = 32'h0000_0003;
            i_uy_transmitted = 32'h0000_0004;
            i_uz2            = 32'h0000_0005;
            i_uz2_2          = 64'h0000_0000_0000_0006;
            i_uz_2           = 64'h0000_0000_0000_0007;
            @(posedge clock);
            #1;


            enable = 0;
            i_oneMinusUz_2   = 64'hFFFF_FFFF_FFFF_FFFF;
            i_sa2_2          = 64'hFFFF_FFFF_FFFF_FFFF;
            i_ux_transmitted = 32'hFFFF_FFFF;
            i_uy_transmitted = 32'hFFFF_FFFF;
            i_uz2            = 32'hFFFF_FFFF;
            i_uz2_2          = 64'hFFFF_FFFF_FFFF_FFFF;
            i_uz_2           = 64'hFFFF_FFFF_FFFF_FFFF;

            @(posedge clock);
            #2;


            #1;



            check_outputs(
                64'h0000_0000_0000_0001,
                64'h0000_0000_0000_0002,
                32'h0000_0003,
                32'h0000_0004,
                32'h0000_0005,
                64'h0000_0000_0000_0006,
                64'h0000_0000_0000_0007
            );
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Alternating Values", test_num);
            reset_dut();

            enable = 1;
            i_oneMinusUz_2   = 64'hFEDC_BA98_7654_3210;
            i_sa2_2          = 64'h0123_4567_89AB_CDEF;
            i_ux_transmitted = 32'hDEAD_BEEF;
            i_uy_transmitted = 32'hCAFE_BABE;
            i_uz2            = 32'hBAAD_F00D;
            i_uz2_2          = 64'h1357_2468_A0B1_C2D3;
            i_uz_2           = 64'h4E61_6D65_5465_7374;

            @(posedge clock);
            #2;

            #1;


            check_outputs(
                64'hFEDC_BA98_7654_3210,
                64'h0123_4567_89AB_CDEF,
                32'hDEAD_BEEF,
                32'hCAFE_BABE,
                32'hBAAD_F00D,
                64'h1357_2468_A0B1_C2D3,
                64'h4E61_6D65_5465_7374
            );
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
        input [63:0] expected_o_oneMinusUz_2;
        input [63:0] expected_o_sa2_2;
        input [31:0] expected_o_ux_transmitted;
        input [31:0] expected_o_uy_transmitted;
        input [31:0] expected_o_uz2;
        input [63:0] expected_o_uz2_2;
        input [63:0] expected_o_uz_2;
        begin
            if (expected_o_oneMinusUz_2 === (expected_o_oneMinusUz_2 ^ o_oneMinusUz_2 ^ expected_o_oneMinusUz_2) &&
                expected_o_sa2_2 === (expected_o_sa2_2 ^ o_sa2_2 ^ expected_o_sa2_2) &&
                expected_o_ux_transmitted === (expected_o_ux_transmitted ^ o_ux_transmitted ^ expected_o_ux_transmitted) &&
                expected_o_uy_transmitted === (expected_o_uy_transmitted ^ o_uy_transmitted ^ expected_o_uy_transmitted) &&
                expected_o_uz2 === (expected_o_uz2 ^ o_uz2 ^ expected_o_uz2) &&
                expected_o_uz2_2 === (expected_o_uz2_2 ^ o_uz2_2 ^ expected_o_uz2_2) &&
                expected_o_uz_2 === (expected_o_uz_2 ^ o_uz_2 ^ expected_o_uz_2)) begin
                $display("PASS");
                $display("  Outputs: o_oneMinusUz_2=%h, o_sa2_2=%h, o_ux_transmitted=%h, o_uy_transmitted=%h, o_uz2=%h, o_uz2_2=%h, o_uz_2=%h",
                         o_oneMinusUz_2, o_sa2_2, o_ux_transmitted, o_uy_transmitted, o_uz2, o_uz2_2, o_uz_2);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: o_oneMinusUz_2=%h, o_sa2_2=%h, o_ux_transmitted=%h, o_uy_transmitted=%h, o_uz2=%h, o_uz2_2=%h, o_uz_2=%h",
                         expected_o_oneMinusUz_2, expected_o_sa2_2, expected_o_ux_transmitted, expected_o_uy_transmitted, expected_o_uz2, expected_o_uz2_2, expected_o_uz_2);
                $display("  Got:      o_oneMinusUz_2=%h, o_sa2_2=%h, o_ux_transmitted=%h, o_uy_transmitted=%h, o_uz2=%h, o_uz2_2=%h, o_uz_2=%h",
                         o_oneMinusUz_2, o_sa2_2, o_ux_transmitted, o_uy_transmitted, o_uz2, o_uz2_2, o_uz_2);
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
        $dumpvars(0,clock, enable, i_oneMinusUz_2, i_sa2_2, i_ux_transmitted, i_uy_transmitted, i_uz2, i_uz2_2, i_uz_2, reset, o_oneMinusUz_2, o_sa2_2, o_ux_transmitted, o_uy_transmitted, o_uz2, o_uz2_2, o_uz_2);
    end

endmodule
