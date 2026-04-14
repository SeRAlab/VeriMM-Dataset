`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [12:0] ai_in;
    reg [12:0] aq_in;
    reg [12:0] bi_in;
    reg [12:0] bq_in;
    reg bunch_strb;
    reg [12:0] ci_in;
    reg clk;
    reg [12:0] cq_in;
    reg dac_cond;
    reg [1:0] sel;
    wire [16:0] bpm1_i_reg_int_a;
    wire [16:0] bpm1_q_reg_int_a;
    wire [16:0] bpm2_i_reg_int_a;
    wire [16:0] bpm2_q_reg_int_a;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ai_in(ai_in),
        .aq_in(aq_in),
        .bi_in(bi_in),
        .bq_in(bq_in),
        .bunch_strb(bunch_strb),
        .ci_in(ci_in),
        .clk(clk),
        .cq_in(cq_in),
        .dac_cond(dac_cond),
        .sel(sel),
        .bpm1_i_reg_int_a(bpm1_i_reg_int_a),
        .bpm1_q_reg_int_a(bpm1_q_reg_int_a),
        .bpm2_i_reg_int_a(bpm2_i_reg_int_a),
        .bpm2_q_reg_int_a(bpm2_q_reg_int_a)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            dac_cond = 1;
            bunch_strb = 0;
            sel = 0;
            ai_in = 0; aq_in = 0;
            bi_in = 0; bq_in = 0;
            ci_in = 0; cq_in = 0;
            repeat(2) @(posedge clk);
            #1 dac_cond = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("Running testcase001: Reset Verification");
            reset_dut();


            sel = 2'b00;
            ai_in = 13'sd100; aq_in = 13'sd100;
            bi_in = 13'sd200; bq_in = 13'sd200;
            bunch_strb = 1;
            repeat(5) @(posedge clk);


            #1 dac_cond = 1;
            @(posedge clk);
            #1 dac_cond = 0;


            #1;



            check_outputs(17'sd0, 17'sd0, 17'sd0, 17'sd0);
        end
        endtask

    task testcase002;

        begin
            $display("Running testcase002: Basic Accumulation sel=0");
            reset_dut();

            sel = 2'b00;
            ai_in = 13'sd500; aq_in = 13'sd250;
            bi_in = 13'sd100; bq_in = 13'sd50;
            bunch_strb = 1;

            @(posedge clk);
            #1 bunch_strb = 0;

            #1;


            check_outputs(17'sd500, 17'sd250, 17'sd100, 17'sd50);
        end
        endtask

    task testcase003;

        begin
            $display("Running testcase003: Routing sel=1");
            reset_dut();

            sel = 2'b01;
            bi_in = 13'sd1000; bq_in = 13'sd1100;
            ci_in = 13'sd1200; cq_in = 13'sd1300;
            bunch_strb = 1;

            @(posedge clk);
            #1 bunch_strb = 0;



            #1;




            check_outputs(17'sd1000, 17'sd1100, 17'sd1200, 17'sd1300);
        end
        endtask

    task testcase004;

        begin
            $display("Running testcase004: Enable Gating");
            reset_dut();

            sel = 2'b00;
            ai_in = 13'sd400; aq_in = 13'sd400;
            bunch_strb = 0;

            repeat(5) @(posedge clk);

            #1;


            check_outputs(17'sd0, 17'sd0, 17'sd0, 17'sd0);
        end
        endtask

    task testcase005;

        begin
            $display("Running testcase005: Negative Summation");
            reset_dut();

            sel = 2'b00;
            ai_in = -13'sd1000; aq_in = -13'sd500;
            bi_in = -13'sd2000; bq_in = -13'sd100;
            bunch_strb = 1;

            @(posedge clk);
            #1 bunch_strb = 0;

            #1;


            check_outputs(-17'sd1000, -17'sd500, -17'sd2000, -17'sd100);
        end
        endtask

    task testcase006;

        begin
            $display("Running testcase006: Multiple Cycles");
            reset_dut();

            sel = 2'b00;
            ai_in = 13'sd1000; aq_in = 13'sd1000;
            bi_in = 13'sd500;  bq_in = 13'sd500;
            bunch_strb = 1;

            repeat(4) @(posedge clk);
            #1 bunch_strb = 0;

            #1;


            check_outputs(17'sd4000, 17'sd4000, 17'sd2000, 17'sd2000);
        end
        endtask

    task testcase007;

        begin
            $display("Running testcase007: Max Range");
            reset_dut();

            sel = 2'b10;
            ci_in = 13'sd4095; cq_in = -13'sd4096;
            ai_in = 13'sd4095; aq_in = -13'sd4096;
            bunch_strb = 1;

            @(posedge clk);
            #1 bunch_strb = 0;

            #1;


            check_outputs(17'sd4095, -17'sd4096, 17'sd4095, -17'sd4096);
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
        input [16:0] expected_bpm1_i_reg_int_a;
        input [16:0] expected_bpm1_q_reg_int_a;
        input [16:0] expected_bpm2_i_reg_int_a;
        input [16:0] expected_bpm2_q_reg_int_a;
        begin
            if (expected_bpm1_i_reg_int_a === (expected_bpm1_i_reg_int_a ^ bpm1_i_reg_int_a ^ expected_bpm1_i_reg_int_a) &&
                expected_bpm1_q_reg_int_a === (expected_bpm1_q_reg_int_a ^ bpm1_q_reg_int_a ^ expected_bpm1_q_reg_int_a) &&
                expected_bpm2_i_reg_int_a === (expected_bpm2_i_reg_int_a ^ bpm2_i_reg_int_a ^ expected_bpm2_i_reg_int_a) &&
                expected_bpm2_q_reg_int_a === (expected_bpm2_q_reg_int_a ^ bpm2_q_reg_int_a ^ expected_bpm2_q_reg_int_a)) begin
                $display("PASS");
                $display("  Outputs: bpm1_i_reg_int_a=%h, bpm1_q_reg_int_a=%h, bpm2_i_reg_int_a=%h, bpm2_q_reg_int_a=%h",
                         bpm1_i_reg_int_a, bpm1_q_reg_int_a, bpm2_i_reg_int_a, bpm2_q_reg_int_a);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: bpm1_i_reg_int_a=%h, bpm1_q_reg_int_a=%h, bpm2_i_reg_int_a=%h, bpm2_q_reg_int_a=%h",
                         expected_bpm1_i_reg_int_a, expected_bpm1_q_reg_int_a, expected_bpm2_i_reg_int_a, expected_bpm2_q_reg_int_a);
                $display("  Got:      bpm1_i_reg_int_a=%h, bpm1_q_reg_int_a=%h, bpm2_i_reg_int_a=%h, bpm2_q_reg_int_a=%h",
                         bpm1_i_reg_int_a, bpm1_q_reg_int_a, bpm2_i_reg_int_a, bpm2_q_reg_int_a);
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
        $dumpvars(0,ai_in, aq_in, bi_in, bq_in, bunch_strb, ci_in, clk, cq_in, dac_cond, sel, bpm1_i_reg_int_a, bpm1_q_reg_int_a, bpm2_i_reg_int_a, bpm2_q_reg_int_a);
    end

endmodule
