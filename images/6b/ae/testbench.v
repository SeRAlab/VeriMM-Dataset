`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg clken;
    reg [19:0] i_cur_pc;
    reg [31:0] i_instr;
    reg [19:0] i_pre_des;
    reg i_pre_jum_en;
    wire [19:0] o_cur_pc;
    wire [31:0] o_instr;
    wire [19:0] o_pre_des;
    wire o_pre_jum_en;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .clken(clken),
        .i_cur_pc(i_cur_pc),
        .i_instr(i_instr),
        .i_pre_des(i_pre_des),
        .i_pre_jum_en(i_pre_jum_en),
        .o_cur_pc(o_cur_pc),
        .o_instr(o_instr),
        .o_pre_des(o_pre_des),
        .o_pre_jum_en(o_pre_jum_en)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            clken = 0;
            i_instr = 32'h0;
            i_cur_pc = 20'h0;
            i_pre_des = 20'h0;
            i_pre_jum_en = 1'b0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("Running testcase001: Basic latching with clken=1");
            reset_dut();

            clken = 1'b1;
            i_instr = 32'h12345678;
            i_cur_pc = 20'hABCDE;
            i_pre_des = 20'h54321;
            i_pre_jum_en = 1'b1;

            @(posedge clk);
            #2;

            #1;


            check_outputs(20'hABCDE, 32'h12345678, 20'h54321, 1'b1);
        end
        endtask

    task testcase002;

        begin
            $display("Running testcase002: Clock enable disabled check");
            reset_dut();


            clken = 1'b1;
            i_instr = 32'hAAAA_AAAA;
            i_cur_pc = 20'h11111;
            i_pre_des = 20'h22222;
            i_pre_jum_en = 1'b0;
            @(posedge clk);
            #2;


            clken = 1'b0;
            i_instr = 32'hBBBB_BBBB;
            i_cur_pc = 20'h33333;
            i_pre_des = 20'h44444;
            i_pre_jum_en = 1'b1;
            @(posedge clk);
            #2;


            #1;



            check_outputs(20'h11111, 32'hAAAA_AAAA, 20'h22222, 1'b0);
        end
        endtask

    task testcase003;

        begin
            $display("Running testcase003: Re-enabling clken");
            reset_dut();


            clken = 1'b0;
            i_instr = 32'hDEAD_BEEF;
            @(posedge clk);
            #2;


            clken = 1'b1;
            i_instr = 32'hCAFE_BABE;
            i_cur_pc = 20'hFFFFF;
            i_pre_des = 20'h00000;
            i_pre_jum_en = 1'b1;
            @(posedge clk);
            #2;

            #1;


            check_outputs(20'hFFFFF, 32'hCAFE_BABE, 20'h00000, 1'b1);
        end
        endtask

    task testcase004;

        begin
            $display("Running testcase004: Rapid consecutive updates");
            reset_dut();

            clken = 1'b1;


            i_instr = 32'h1; i_cur_pc = 20'h1; i_pre_des = 20'h1; i_pre_jum_en = 1'b1;
            @(posedge clk);
            #1;


            i_instr = 32'h2; i_cur_pc = 20'h2; i_pre_des = 20'h2; i_pre_jum_en = 1'b0;
            @(posedge clk);
            #2;

            #1;


            check_outputs(20'h2, 32'h2, 20'h2, 1'b0);
        end
        endtask

    task testcase005;

        begin
            $display("Running testcase005: All ones bit pattern");
            reset_dut();

            clken = 1'b1;
            i_instr = 32'hFFFF_FFFF;
            i_cur_pc = 20'hF_FFFF;
            i_pre_des = 20'hF_FFFF;
            i_pre_jum_en = 1'b1;

            @(posedge clk);
            #2;

            #1;


            check_outputs(20'hF_FFFF, 32'hFFFF_FFFF, 20'hF_FFFF, 1'b1);
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
        input [19:0] expected_o_cur_pc;
        input [31:0] expected_o_instr;
        input [19:0] expected_o_pre_des;
        input expected_o_pre_jum_en;
        begin
            if (expected_o_cur_pc === (expected_o_cur_pc ^ o_cur_pc ^ expected_o_cur_pc) &&
                expected_o_instr === (expected_o_instr ^ o_instr ^ expected_o_instr) &&
                expected_o_pre_des === (expected_o_pre_des ^ o_pre_des ^ expected_o_pre_des) &&
                expected_o_pre_jum_en === (expected_o_pre_jum_en ^ o_pre_jum_en ^ expected_o_pre_jum_en)) begin
                $display("PASS");
                $display("  Outputs: o_cur_pc=%h, o_instr=%h, o_pre_des=%h, o_pre_jum_en=%b",
                         o_cur_pc, o_instr, o_pre_des, o_pre_jum_en);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: o_cur_pc=%h, o_instr=%h, o_pre_des=%h, o_pre_jum_en=%b",
                         expected_o_cur_pc, expected_o_instr, expected_o_pre_des, expected_o_pre_jum_en);
                $display("  Got:      o_cur_pc=%h, o_instr=%h, o_pre_des=%h, o_pre_jum_en=%b",
                         o_cur_pc, o_instr, o_pre_des, o_pre_jum_en);
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
        $dumpvars(0,clk, clken, i_cur_pc, i_instr, i_pre_des, i_pre_jum_en, o_cur_pc, o_instr, o_pre_des, o_pre_jum_en);
    end

endmodule
