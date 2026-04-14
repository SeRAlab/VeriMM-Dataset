`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg RegDest;
    reg RegDest_ROB;
    reg RegDest_compl;
    reg clk;
    reg complete;
    reg hazard_stall;
    reg isDispatch;
    reg [4:0] l_rd;
    reg [4:0] l_rs;
    reg [4:0] l_rt;
    reg [5:0] p_rd_compl;
    reg [5:0] p_rd_flush;
    reg [5:0] p_rd_new;
    reg recover;
    reg [4:0] recover_rd;
    reg rst;
    wire [5:0] PR_old_rd;
    wire [5:0] p_rs;
    wire p_rs_v;
    wire [5:0] p_rt;
    wire p_rt_v;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .RegDest(RegDest),
        .RegDest_ROB(RegDest_ROB),
        .RegDest_compl(RegDest_compl),
        .clk(clk),
        .complete(complete),
        .hazard_stall(hazard_stall),
        .isDispatch(isDispatch),
        .l_rd(l_rd),
        .l_rs(l_rs),
        .l_rt(l_rt),
        .p_rd_compl(p_rd_compl),
        .p_rd_flush(p_rd_flush),
        .p_rd_new(p_rd_new),
        .recover(recover),
        .recover_rd(recover_rd),
        .rst(rst),
        .PR_old_rd(PR_old_rd),
        .p_rs(p_rs),
        .p_rs_v(p_rs_v),
        .p_rt(p_rt),
        .p_rt_v(p_rt_v)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        rst = 1;
        RegDest = 0; RegDest_ROB = 0; RegDest_compl = 0;
        complete = 0; hazard_stall = 0; isDispatch = 0;
        l_rd = 0; l_rs = 0; l_rt = 0;
        p_rd_compl = 0; p_rd_flush = 0; p_rd_new = 0;
        recover = 0; recover_rd = 0;
        @(posedge clk);
        #1 rst = 0;
        @(posedge clk);
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        reset_dut();
        l_rs = 5;
        l_rt = 12;
        l_rd = 5;
        #1;


        #1;



        check_outputs(6'd5, 6'd5, 1'b1, 6'd12, 1'b1);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        reset_dut();

        isDispatch = 1;
        RegDest = 1;
        l_rd = 5;
        p_rd_new = 6'd40;
        @(posedge clk);
        #1;
        isDispatch = 0;
        l_rs = 5;

        #1;


        check_outputs(6'd40, 6'd40, 1'b0, 6'd0, 1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        reset_dut();

        isDispatch = 1; RegDest = 1; l_rd = 8; p_rd_new = 6'd45;
        @(posedge clk);
        #1;

        isDispatch = 0;
        complete = 1; RegDest_compl = 1; p_rd_compl = 6'd45;
        @(posedge clk);
        #1;
        complete = 0;
        l_rs = 8;

        #1;


        check_outputs(6'd8, 6'd45, 1'b1, 6'd0, 1'b1);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        reset_dut();

        hazard_stall = 1;
        isDispatch = 1; RegDest = 1; l_rd = 10; p_rd_new = 6'd50;
        @(posedge clk);
        #1;
        hazard_stall = 0; isDispatch = 0;
        l_rs = 10;

        #1;


        check_outputs(6'd10, 6'd10, 1'b1, 6'd0, 1'b1);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        reset_dut();

        isDispatch = 1; RegDest = 1; l_rd = 15; p_rd_new = 6'd55;
        @(posedge clk);
        #1;

        isDispatch = 0;
        recover = 1; RegDest_ROB = 1; recover_rd = 15; p_rd_flush = 6'd15;
        @(posedge clk);
        #1;
        recover = 0;
        l_rs = 15;

        #1;


        check_outputs(6'd15, 6'd15, 1'b1, 6'd0, 1'b1);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        reset_dut();

        isDispatch = 1; RegDest = 1; l_rd = 1; p_rd_new = 6'd33;
        @(posedge clk);
        #1;
        l_rd = 2; p_rd_new = 6'd34;
        @(posedge clk);
        #1;
        isDispatch = 0;
        l_rs = 1; l_rt = 2;

        #1;


        check_outputs(6'd34, 6'd33, 1'b0, 6'd34, 1'b0);
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
        input [5:0] expected_PR_old_rd;
        input [5:0] expected_p_rs;
        input expected_p_rs_v;
        input [5:0] expected_p_rt;
        input expected_p_rt_v;
        begin
            if (expected_PR_old_rd === (expected_PR_old_rd ^ PR_old_rd ^ expected_PR_old_rd) &&
                expected_p_rs === (expected_p_rs ^ p_rs ^ expected_p_rs) &&
                expected_p_rs_v === (expected_p_rs_v ^ p_rs_v ^ expected_p_rs_v) &&
                expected_p_rt === (expected_p_rt ^ p_rt ^ expected_p_rt) &&
                expected_p_rt_v === (expected_p_rt_v ^ p_rt_v ^ expected_p_rt_v)) begin
                $display("PASS");
                $display("  Outputs: PR_old_rd=%h, p_rs=%h, p_rs_v=%b, p_rt=%h, p_rt_v=%b",
                         PR_old_rd, p_rs, p_rs_v, p_rt, p_rt_v);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: PR_old_rd=%h, p_rs=%h, p_rs_v=%b, p_rt=%h, p_rt_v=%b",
                         expected_PR_old_rd, expected_p_rs, expected_p_rs_v, expected_p_rt, expected_p_rt_v);
                $display("  Got:      PR_old_rd=%h, p_rs=%h, p_rs_v=%b, p_rt=%h, p_rt_v=%b",
                         PR_old_rd, p_rs, p_rs_v, p_rt, p_rt_v);
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
        $dumpvars(0,RegDest, RegDest_ROB, RegDest_compl, clk, complete, hazard_stall, isDispatch, l_rd, l_rs, l_rt, p_rd_compl, p_rd_flush, p_rd_new, recover, recover_rd, rst, PR_old_rd, p_rs, p_rs_v, p_rt, p_rt_v);
    end

endmodule
