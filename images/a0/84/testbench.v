`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [31:0] c_di;
    reg c_en;
    reg [8:0] c_offset;
    reg [1:0] c_page;
    reg c_w_en;
    reg count_rst;
    reg sys_clk;
    wire [6:0] a_addr;
    wire [6:0] b_addr;
    wire [31:0] c_do;
    wire [3:0] opcode;
    wire [10:0] pc;
    wire [6:0] w_addr;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .c_di(c_di),
        .c_en(c_en),
        .c_offset(c_offset),
        .c_page(c_page),
        .c_w_en(c_w_en),
        .count_rst(count_rst),
        .sys_clk(sys_clk),
        .a_addr(a_addr),
        .b_addr(b_addr),
        .c_do(c_do),
        .opcode(opcode),
        .pc(pc),
        .w_addr(w_addr)
    );

    // Clock generation (10ns period)
    initial begin
        sys_clk = 0;
        forever #5 sys_clk = ~sys_clk;
    end

        task reset_dut;

        begin
            count_rst = 1;
            c_en = 0;
            c_w_en = 0;
            c_di = 0;
            c_page = 0;
            c_offset = 0;
            #10;
            @(posedge sys_clk);
            #2;
            count_rst = 0;
            @(posedge sys_clk);
            #2;
        end
        endtask
    task testcase001;

    begin
        reset_dut();
        test_num = 1;



        c_en = 1;
        c_w_en = 1;
        c_page = 2'h0;
        c_offset = 9'h010;
        c_di = 32'h1040C200;
        @(posedge sys_clk);
        #2;


        c_w_en = 0;

        @(posedge sys_clk);
        #2;


        #1;



        check_outputs(7'h04, 7'h03, 32'h1040C200, 4'h1, 11'h002, 7'h02);
    end
        endtask

    task testcase002;

    begin
        reset_dut();
        test_num = 2;



        c_en = 1;
        c_w_en = 1;
        c_page = 2'h0;
        c_offset = 9'h000;
        c_di = 32'hA2081800;
        @(posedge sys_clk);
        #2;


        c_en = 0;
        c_w_en = 0;
        count_rst = 1;
        @(posedge sys_clk);
        #2;
        count_rst = 0;


        @(posedge sys_clk);
        #2;


        #1;



        check_outputs(7'h30, 7'h20, 32'hA2081800, 4'hA, 11'h001, 7'h10);
    end
        endtask

    task testcase003;

    begin
        reset_dut();
        test_num = 3;


        c_en = 1;
        c_w_en = 1;

        c_page = 2'h0; c_offset = 9'h001; c_di = 32'h30C18480;
        @(posedge sys_clk); #2;

        c_offset = 9'h002; c_di = 32'h41020600;
        @(posedge sys_clk); #2;


        c_en = 0;
        c_w_en = 0;
        count_rst = 1;
        @(posedge sys_clk);
        #2;
        count_rst = 0;

        @(posedge sys_clk); #2;
        @(posedge sys_clk); #2;


        #1;



        check_outputs(7'h09, 7'h06, 32'h30C18480, 4'h3, 11'h002, 7'h06);
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
        input [6:0] expected_a_addr;
        input [6:0] expected_b_addr;
        input [31:0] expected_c_do;
        input [3:0] expected_opcode;
        input [10:0] expected_pc;
        input [6:0] expected_w_addr;
        begin
            if (expected_a_addr === (expected_a_addr ^ a_addr ^ expected_a_addr) &&
                expected_b_addr === (expected_b_addr ^ b_addr ^ expected_b_addr) &&
                expected_c_do === (expected_c_do ^ c_do ^ expected_c_do) &&
                expected_opcode === (expected_opcode ^ opcode ^ expected_opcode) &&
                expected_pc === (expected_pc ^ pc ^ expected_pc) &&
                expected_w_addr === (expected_w_addr ^ w_addr ^ expected_w_addr)) begin
                $display("PASS");
                $display("  Outputs: a_addr=%h, b_addr=%h, c_do=%h, opcode=%h, pc=%h, w_addr=%h",
                         a_addr, b_addr, c_do, opcode, pc, w_addr);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: a_addr=%h, b_addr=%h, c_do=%h, opcode=%h, pc=%h, w_addr=%h",
                         expected_a_addr, expected_b_addr, expected_c_do, expected_opcode, expected_pc, expected_w_addr);
                $display("  Got:      a_addr=%h, b_addr=%h, c_do=%h, opcode=%h, pc=%h, w_addr=%h",
                         a_addr, b_addr, c_do, opcode, pc, w_addr);
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
        $dumpvars(0,c_di, c_en, c_offset, c_page, c_w_en, count_rst, sys_clk, a_addr, b_addr, c_do, opcode, pc, w_addr);
    end

endmodule
