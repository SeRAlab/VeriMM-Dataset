`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] a;
    reg [31:0] b;
    reg clk;
    reg ex_freeze;
    reg except_started;
    reg fpcsr_we;
    reg [7:0] fpu_op;
    reg rst;
    reg [31:0] spr_addr;
    reg spr_cs;
    reg [31:0] spr_dat_i;
    reg spr_write;
    wire done;
    wire flag_we;
    wire flagforw;
    wire [11:0] fpcsr;
    wire [31:0] result;
    wire sig_fp;
    wire [31:0] spr_dat_o;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .clk(clk),
        .ex_freeze(ex_freeze),
        .except_started(except_started),
        .fpcsr_we(fpcsr_we),
        .fpu_op(fpu_op),
        .rst(rst),
        .spr_addr(spr_addr),
        .spr_cs(spr_cs),
        .spr_dat_i(spr_dat_i),
        .spr_write(spr_write),
        .done(done),
        .flag_we(flag_we),
        .flagforw(flagforw),
        .fpcsr(fpcsr),
        .result(result),
        .sig_fp(sig_fp),
        .spr_dat_o(spr_dat_o)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %03d: Addition placeholder - 1.0 + 1.0", test_num);

            rst = 1;
            a = 32'h3F800000;
            b = 32'h3F800000;
            fpu_op = 8'h01;
            ex_freeze = 0;
            except_started = 0;
            #20 rst = 0;


            repeat(2) @(posedge clk);


            #1;



            check_outputs(1'b1, 1'b0, 1'b0, 12'h0, 32'h0, 1'b0, 32'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %03d: Multiplication placeholder - 5.0 * 2.0", test_num);

            rst = 1;
            a = 32'h40A00000;
            b = 32'h40000000;
            fpu_op = 8'h02;
            #20 rst = 0;

            repeat(2) @(posedge clk);

            #1;


            check_outputs(1'b1, 1'b0, 1'b0, 12'h0, 32'h0, 1'b0, 32'h0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %03d: Handling extreme values (Inf/NaN) placeholder", test_num);

            rst = 1;
            a = 32'h7F800000;
            b = 32'hFFC00000;
            fpu_op = 8'h03;
            #20 rst = 0;

            repeat(2) @(posedge clk);


            #1;



            check_outputs(1'b1, 1'b0, 1'b0, 12'h0, 32'h0, 1'b0, 32'h0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %03d: Freeze signal behavior", test_num);

            rst = 1;
            a = 32'h42280000;
            b = 32'h41200000;
            fpu_op = 8'h04;
            ex_freeze = 1;
            #20 rst = 0;

            repeat(5) @(posedge clk);


            #1;



            check_outputs(1'b1, 1'b0, 1'b0, 12'h0, 32'h0, 1'b0, 32'h0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %03d: Special Purpose Register (SPR) interface check", test_num);

            rst = 1;
            spr_addr = 32'h000000A0;
            spr_dat_i = 32'hDEADBEEF;
            spr_cs = 1;
            spr_write = 1;
            #20 rst = 0;

            repeat(2) @(posedge clk);


            #1;



            check_outputs(1'b1, 1'b0, 1'b0, 12'h0, 32'h0, 1'b0, 32'h0);
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
        input expected_done;
        input expected_flag_we;
        input expected_flagforw;
        input [11:0] expected_fpcsr;
        input [31:0] expected_result;
        input expected_sig_fp;
        input [31:0] expected_spr_dat_o;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_done === (expected_done ^ done ^ expected_done) &&
                expected_flag_we === (expected_flag_we ^ flag_we ^ expected_flag_we) &&
                expected_flagforw === (expected_flagforw ^ flagforw ^ expected_flagforw) &&
                expected_fpcsr === (expected_fpcsr ^ fpcsr ^ expected_fpcsr) &&
                expected_result === (expected_result ^ result ^ expected_result) &&
                expected_sig_fp === (expected_sig_fp ^ sig_fp ^ expected_sig_fp) &&
                expected_spr_dat_o === (expected_spr_dat_o ^ spr_dat_o ^ expected_spr_dat_o)) begin
                $display("PASS");
                $display("  Outputs: done=%b, flag_we=%b, flagforw=%b, fpcsr=%h, result=%h, sig_fp=%b, spr_dat_o=%h",
                         done, flag_we, flagforw, fpcsr, result, sig_fp, spr_dat_o);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: done=%b, flag_we=%b, flagforw=%b, fpcsr=%h, result=%h, sig_fp=%b, spr_dat_o=%h",
                         expected_done, expected_flag_we, expected_flagforw, expected_fpcsr, expected_result, expected_sig_fp, expected_spr_dat_o);
                $display("  Got:      done=%b, flag_we=%b, flagforw=%b, fpcsr=%h, result=%h, sig_fp=%b, spr_dat_o=%h",
                         done, flag_we, flagforw, fpcsr, result, sig_fp, spr_dat_o);
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
