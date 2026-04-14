`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [31:0] alu_in_0;
    reg [31:0] alu_in_1;
    reg [3:0] alu_op;
    reg br_flag;
    reg clk;
    reg [2:0] ctrl_op;
    reg [4:0] dst_addr;
    reg [3:0] exp_code;
    reg flush;
    reg gpr_we_;
    reg if_en;
    reg [31:0] if_pc;
    reg [1:0] mem_op;
    reg [31:0] mem_wr_data;
    reg reset;
    reg stall;
    wire [31:0] id_alu_in_0;
    wire [31:0] id_alu_in_1;
    wire [3:0] id_alu_op;
    wire id_br_flag;
    wire [2:0] id_ctrl_op;
    wire [4:0] id_dst_addr;
    wire id_en;
    wire [3:0] id_exp_code;
    wire id_gpr_we_;
    wire [1:0] id_mem_op;
    wire [31:0] id_mem_wr_data;
    wire [31:0] id_pc;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .alu_in_0(alu_in_0),
        .alu_in_1(alu_in_1),
        .alu_op(alu_op),
        .br_flag(br_flag),
        .clk(clk),
        .ctrl_op(ctrl_op),
        .dst_addr(dst_addr),
        .exp_code(exp_code),
        .flush(flush),
        .gpr_we_(gpr_we_),
        .if_en(if_en),
        .if_pc(if_pc),
        .mem_op(mem_op),
        .mem_wr_data(mem_wr_data),
        .reset(reset),
        .stall(stall),
        .id_alu_in_0(id_alu_in_0),
        .id_alu_in_1(id_alu_in_1),
        .id_alu_op(id_alu_op),
        .id_br_flag(id_br_flag),
        .id_ctrl_op(id_ctrl_op),
        .id_dst_addr(id_dst_addr),
        .id_en(id_en),
        .id_exp_code(id_exp_code),
        .id_gpr_we_(id_gpr_we_),
        .id_mem_op(id_mem_op),
        .id_mem_wr_data(id_mem_wr_data),
        .id_pc(id_pc)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            stall = 0;
            flush = 0;
            alu_in_0 = 32'h0;
            alu_in_1 = 32'h0;
            alu_op = 4'h0;
            br_flag = 0;
            mem_op = 2'b00;
            mem_wr_data = 32'h0;
            ctrl_op = 3'b000;
            dst_addr = 5'h0;
            gpr_we_ = 0;
            exp_code = 4'h0;
            if_pc = 32'h0;
            if_en = 0;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            $display("Running Testcase 001: Basic Data Load");
            reset_dut();

            alu_in_0 = 32'hAAAA_BBBB;
            alu_in_1 = 32'hCCCC_DDDD;
            alu_op = 4'h5;
            br_flag = 1;
            mem_op = 2'b10;
            mem_wr_data = 32'h1234_5678;
            ctrl_op = 3'b011;
            dst_addr = 5'h1F;
            gpr_we_ = 1;
            exp_code = 4'hE;
            if_pc = 32'h0000_1000;
            if_en = 1;

            @(posedge clk);
            #2;

            #1;


            check_outputs(32'hAAAA_BBBB, 32'hCCCC_DDDD, 4'h5, 1, 3'b011, 5'h1F, 1, 4'hE, 1, 2'b10, 32'h1234_5678, 32'h0000_1000);
        end
        endtask

    task testcase002;

        begin
            $display("Running Testcase 002: Stall Functionality");
            reset_dut();


            alu_in_0 = 32'h1111_1111;
            if_pc = 32'h0000_2000;
            if_en = 1;
            @(posedge clk);
            #1;


            stall = 1;
            alu_in_0 = 32'hEEEE_EEEE;
            if_pc = 32'hFFFF_FFFF;
            @(posedge clk);
            #2;


            #1;



            check_outputs(32'h1111_1111, 32'h0, 4'h0, 0, 3'h0, 5'h0, 1, 4'h0, 0, 2'h0, 32'h0, 32'h0000_2000);
        end
        endtask

    task testcase003;

        begin
            $display("Running Testcase 003: Flush Functionality");
            reset_dut();


            alu_in_0 = 32'h8888_8888;
            if_pc = 32'h0000_3000;
            if_en = 1;
            @(posedge clk);
            #1;


            flush = 1;
            alu_in_0 = 32'h9999_9999;
            @(posedge clk);
            #2;


            #1;



            check_outputs(32'h0, 32'h0, 4'h0, 0, 3'h0, 5'h0, 0, 4'h0, 0, 2'h0, 32'h0, 32'h0);
        end
        endtask

    task testcase004;

        begin
            $display("Running Testcase 004: Priority Check (Flush vs Stall)");
            reset_dut();


            alu_in_0 = 32'h5555_5555;
            @(posedge clk);
            #1;


            stall = 1;
            flush = 1;
            alu_in_0 = 32'hFFFF_FFFF;
            @(posedge clk);
            #2;


            #1;



            check_outputs(32'h0, 32'h0, 4'h0, 0, 3'h0, 5'h0, 0, 4'h0, 0, 2'h0, 32'h0, 32'h0);
        end
        endtask

    task testcase005;

        begin
            $display("Running Testcase 005: Reset Priority");
            reset_dut();


            alu_in_0 = 32'h1234_4321;
            @(posedge clk);
            #1;


            reset = 1;
            alu_in_0 = 32'h0;
            @(posedge clk);
            #2;


            #1;



            check_outputs(32'h0, 32'h0, 4'h0, 0, 3'h0, 5'h0, 0, 4'h0, 0, 2'h0, 32'h0, 32'h0);
        end
        endtask

    task testcase006;

        begin
            $display("Running Testcase 006: Recovery from Stall");
            reset_dut();


            stall = 1;
            alu_in_0 = 32'hDEAD_BEEF;
            @(posedge clk);
            #1;


            stall = 0;
            alu_in_0 = 32'hCAFE_BABE;
            @(posedge clk);
            #2;


            #1;



            check_outputs(32'hCAFE_BABE, 32'h0, 4'h0, 0, 3'h0, 5'h0, 0, 4'h0, 0, 2'h0, 32'h0, 32'h0);
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
        input [31:0] expected_id_alu_in_0;
        input [31:0] expected_id_alu_in_1;
        input [3:0] expected_id_alu_op;
        input expected_id_br_flag;
        input [2:0] expected_id_ctrl_op;
        input [4:0] expected_id_dst_addr;
        input expected_id_en;
        input [3:0] expected_id_exp_code;
        input expected_id_gpr_we_;
        input [1:0] expected_id_mem_op;
        input [31:0] expected_id_mem_wr_data;
        input [31:0] expected_id_pc;
        begin
            if (expected_id_alu_in_0 === (expected_id_alu_in_0 ^ id_alu_in_0 ^ expected_id_alu_in_0) &&
                expected_id_alu_in_1 === (expected_id_alu_in_1 ^ id_alu_in_1 ^ expected_id_alu_in_1) &&
                expected_id_alu_op === (expected_id_alu_op ^ id_alu_op ^ expected_id_alu_op) &&
                expected_id_br_flag === (expected_id_br_flag ^ id_br_flag ^ expected_id_br_flag) &&
                expected_id_ctrl_op === (expected_id_ctrl_op ^ id_ctrl_op ^ expected_id_ctrl_op) &&
                expected_id_dst_addr === (expected_id_dst_addr ^ id_dst_addr ^ expected_id_dst_addr) &&
                expected_id_en === (expected_id_en ^ id_en ^ expected_id_en) &&
                expected_id_exp_code === (expected_id_exp_code ^ id_exp_code ^ expected_id_exp_code) &&
                expected_id_gpr_we_ === (expected_id_gpr_we_ ^ id_gpr_we_ ^ expected_id_gpr_we_) &&
                expected_id_mem_op === (expected_id_mem_op ^ id_mem_op ^ expected_id_mem_op) &&
                expected_id_mem_wr_data === (expected_id_mem_wr_data ^ id_mem_wr_data ^ expected_id_mem_wr_data) &&
                expected_id_pc === (expected_id_pc ^ id_pc ^ expected_id_pc)) begin
                $display("PASS");
                $display("  Outputs: id_alu_in_0=%h, id_alu_in_1=%h, id_alu_op=%h, id_br_flag=%b, id_ctrl_op=%h, id_dst_addr=%h, id_en=%b, id_exp_code=%h, id_gpr_we_=%b, id_mem_op=%h, id_mem_wr_data=%h, id_pc=%h",
                         id_alu_in_0, id_alu_in_1, id_alu_op, id_br_flag, id_ctrl_op, id_dst_addr, id_en, id_exp_code, id_gpr_we_, id_mem_op, id_mem_wr_data, id_pc);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: id_alu_in_0=%h, id_alu_in_1=%h, id_alu_op=%h, id_br_flag=%b, id_ctrl_op=%h, id_dst_addr=%h, id_en=%b, id_exp_code=%h, id_gpr_we_=%b, id_mem_op=%h, id_mem_wr_data=%h, id_pc=%h",
                         expected_id_alu_in_0, expected_id_alu_in_1, expected_id_alu_op, expected_id_br_flag, expected_id_ctrl_op, expected_id_dst_addr, expected_id_en, expected_id_exp_code, expected_id_gpr_we_, expected_id_mem_op, expected_id_mem_wr_data, expected_id_pc);
                $display("  Got:      id_alu_in_0=%h, id_alu_in_1=%h, id_alu_op=%h, id_br_flag=%b, id_ctrl_op=%h, id_dst_addr=%h, id_en=%b, id_exp_code=%h, id_gpr_we_=%b, id_mem_op=%h, id_mem_wr_data=%h, id_pc=%h",
                         id_alu_in_0, id_alu_in_1, id_alu_op, id_br_flag, id_ctrl_op, id_dst_addr, id_en, id_exp_code, id_gpr_we_, id_mem_op, id_mem_wr_data, id_pc);
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
        $dumpvars(0,alu_in_0, alu_in_1, alu_op, br_flag, clk, ctrl_op, dst_addr, exp_code, flush, gpr_we_, if_en, if_pc, mem_op, mem_wr_data, reset, stall, id_alu_in_0, id_alu_in_1, id_alu_op, id_br_flag, id_ctrl_op, id_dst_addr, id_en, id_exp_code, id_gpr_we_, id_mem_op, id_mem_wr_data, id_pc);
    end

endmodule
