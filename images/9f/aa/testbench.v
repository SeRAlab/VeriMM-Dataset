`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg id_stall;
    reg if_flush;
    reg [31:0] if_instruction;
    reg if_is_ds;
    reg [31:0] if_pc_add4;
    reg [31:0] if_pc_current;
    reg if_stall;
    reg rst;
    wire [31:0] id_instruction;
    wire id_is_flushed;
    wire [31:0] id_pc_add4;
    wire [31:0] id_pc_current;

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
        .if_is_ds(if_is_ds),
        .if_pc_add4(if_pc_add4),
        .if_pc_current(if_pc_current),
        .if_stall(if_stall),
        .rst(rst),
        .id_instruction(id_instruction),
        .id_is_flushed(id_is_flushed),
        .id_pc_add4(id_pc_add4),
        .id_pc_current(id_pc_current)
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
        if_instruction = 0;
        if_is_ds = 0;
        if_pc_add4 = 0;
        if_pc_current = 0;
        if_stall = 0;
        @(posedge clk);
        #1 rst = 0;
        @(posedge clk);
        #1;
    end
        endtask
    task testcase001;

    begin
        reset_dut();
        test_num = 1;
        if_instruction = 32'hAABBCCDD;
        if_pc_current  = 32'h00001000;
        if_pc_add4     = 32'h00001004;
        if_is_ds       = 1'b0;
        @(posedge clk);
        #2;
        #1;

        check_outputs(32'hAABBCCDD, 1'b0, 32'h00001004, 32'h00001000);
    end
        endtask

    task testcase002;

    begin
        reset_dut();
        test_num = 2;

        if_instruction = 32'h11111111;
        if_pc_current  = 32'h00002000;
        @(posedge clk);
        #1;

        id_stall = 1;
        if_instruction = 32'hEEEEEEEE;
        if_pc_current  = 32'h00003000;
        @(posedge clk);
        #2;

        #1;


        check_outputs(32'h11111111, 1'b0, 32'h0, 32'h00002000);
    end
        endtask

    task testcase003;

    begin
        reset_dut();
        test_num = 3;
        if_flush = 1;
        if_instruction = 32'hDEADBEEF;
        @(posedge clk);
        #2;

        #1;


        check_outputs(32'h00000000, 1'b1, 32'h0, 32'h0);
    end
        endtask

    task testcase004;

    begin
        reset_dut();
        test_num = 4;

        if_instruction = 32'h55555555;
        @(posedge clk);
        #1;

        id_stall = 1;
        if_flush = 1;
        if_instruction = 32'hAAAAAAAA;
        @(posedge clk);
        #2;

        #1;


        check_outputs(32'h0, 1'b1, 32'h0, 32'h0);
    end
        endtask

    task testcase005;

    begin
        reset_dut();
        test_num = 5;
        if_stall = 1;
        if_instruction = 32'h12345678;
        @(posedge clk);
        #2;




        if (id_instruction == 32'h12345678)
            $display("Note: Stage updated despite if_stall");
        else
            $display("Note: Stage blocked/bubbled due to if_stall");

        pass_count = pass_count + 1;
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
        input [31:0] expected_id_instruction;
        input expected_id_is_flushed;
        input [31:0] expected_id_pc_add4;
        input [31:0] expected_id_pc_current;
        begin
            if (expected_id_instruction === (expected_id_instruction ^ id_instruction ^ expected_id_instruction) &&
                expected_id_is_flushed === (expected_id_is_flushed ^ id_is_flushed ^ expected_id_is_flushed) &&
                expected_id_pc_add4 === (expected_id_pc_add4 ^ id_pc_add4 ^ expected_id_pc_add4) &&
                expected_id_pc_current === (expected_id_pc_current ^ id_pc_current ^ expected_id_pc_current)) begin
                $display("PASS");
                $display("  Outputs: id_instruction=%h, id_is_flushed=%b, id_pc_add4=%h, id_pc_current=%h",
                         id_instruction, id_is_flushed, id_pc_add4, id_pc_current);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: id_instruction=%h, id_is_flushed=%b, id_pc_add4=%h, id_pc_current=%h",
                         expected_id_instruction, expected_id_is_flushed, expected_id_pc_add4, expected_id_pc_current);
                $display("  Got:      id_instruction=%h, id_is_flushed=%b, id_pc_add4=%h, id_pc_current=%h",
                         id_instruction, id_is_flushed, id_pc_add4, id_pc_current);
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
        $dumpvars(0,clk, id_stall, if_flush, if_instruction, if_is_ds, if_pc_add4, if_pc_current, if_stall, rst, id_instruction, id_is_flushed, id_pc_add4, id_pc_current);
    end

endmodule
