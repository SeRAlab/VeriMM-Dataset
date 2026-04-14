`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg id_stall;
    reg if_flush;
    reg [31:0] if_instruction;
    reg if_is_bds;
    reg [31:0] if_pc;
    reg [31:0] if_pc_add4;
    reg if_stall;
    reg rst;
    wire [31:0] id_exception_pc;
    wire [31:0] id_instruction;
    wire id_is_bds;
    wire id_is_flushed;
    wire [31:0] id_pc_add4;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .id_stall(id_stall),
        .if_flush(if_flush),
        .if_instruction(if_instruction),
        .if_is_bds(if_is_bds),
        .if_pc(if_pc),
        .if_pc_add4(if_pc_add4),
        .if_stall(if_stall),
        .rst(rst),
        .id_exception_pc(id_exception_pc),
        .id_instruction(id_instruction),
        .id_is_bds(id_is_bds),
        .id_is_flushed(id_is_flushed),
        .id_pc_add4(id_pc_add4)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            id_stall = 0;
            if_flush = 0;
            if_instruction = 32'h0;
            if_is_bds = 0;
            if_pc = 32'h0;
            if_pc_add4 = 32'h0;
            if_stall = 0;
            @(posedge clk);
            #2 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();


            #1;



            check_outputs(32'h0, 32'h0, 0, 0, 32'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            if_instruction = 32'hAABBCCDD;
            if_pc = 32'h00001000;
            if_pc_add4 = 32'h00001004;
            if_is_bds = 1;
            if_flush = 0;
            if_stall = 0;
            id_stall = 0;
            @(posedge clk);
            #2;
            #1;

            check_outputs(32'h00001000, 32'hAABBCCDD, 1, 0, 32'h00001004);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();

            if_instruction = 32'h11223344;
            if_pc = 32'h00002000;
            if_pc_add4 = 32'h00002004;
            @(posedge clk);
            #2;

            id_stall = 1;
            if_instruction = 32'hFFFFFFFF;
            if_pc = 32'h00009000;
            @(posedge clk);
            #2;

            #1;


            check_outputs(32'h00002000, 32'h11223344, 0, 0, 32'h00002004);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            if_flush = 1;
            if_instruction = 32'hDEADBEEF;
            if_pc = 32'h00003000;
            @(posedge clk);
            #2;

            #1;


            check_outputs(32'h0, 32'h0, 0, 1, 32'h0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            if_stall = 1;
            if_instruction = 32'h12345678;
            @(posedge clk);
            #2;

            #1;


            check_outputs(32'h0, 32'h0, 0, 0, 32'h0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();

            id_stall = 1;
            if_instruction = 32'h55555555;
            @(posedge clk);
            #2;

            id_stall = 0;
            if_instruction = 32'h66666666;
            if_pc = 32'h00004000;
            @(posedge clk);
            #2;
            #1;

            check_outputs(32'h00004000, 32'h66666666, 0, 0, 32'h0);
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
        input [31:0] expected_id_exception_pc;
        input [31:0] expected_id_instruction;
        input expected_id_is_bds;
        input expected_id_is_flushed;
        input [31:0] expected_id_pc_add4;
        begin
            if (expected_id_exception_pc === (expected_id_exception_pc ^ id_exception_pc ^ expected_id_exception_pc) &&
                expected_id_instruction === (expected_id_instruction ^ id_instruction ^ expected_id_instruction) &&
                expected_id_is_bds === (expected_id_is_bds ^ id_is_bds ^ expected_id_is_bds) &&
                expected_id_is_flushed === (expected_id_is_flushed ^ id_is_flushed ^ expected_id_is_flushed) &&
                expected_id_pc_add4 === (expected_id_pc_add4 ^ id_pc_add4 ^ expected_id_pc_add4)) begin
                $display("PASS");
                $display("  Outputs: id_exception_pc=%h, id_instruction=%h, id_is_bds=%b, id_is_flushed=%b, id_pc_add4=%h",
                         id_exception_pc, id_instruction, id_is_bds, id_is_flushed, id_pc_add4);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: id_exception_pc=%h, id_instruction=%h, id_is_bds=%b, id_is_flushed=%b, id_pc_add4=%h",
                         expected_id_exception_pc, expected_id_instruction, expected_id_is_bds, expected_id_is_flushed, expected_id_pc_add4);
                $display("  Got:      id_exception_pc=%h, id_instruction=%h, id_is_bds=%b, id_is_flushed=%b, id_pc_add4=%h",
                         id_exception_pc, id_instruction, id_is_bds, id_is_flushed, id_pc_add4);
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
        $dumpvars(0,clk, id_stall, if_flush, if_instruction, if_is_bds, if_pc, if_pc_add4, if_stall, rst, id_exception_pc, id_instruction, id_is_bds, id_is_flushed, id_pc_add4);
    end

endmodule
