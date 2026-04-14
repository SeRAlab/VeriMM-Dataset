`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg MemStall_i;
    reg [31:0] PC_i;
    reg clk_i;
    reg flush_i;
    reg [31:0] instr_i;
    reg stall_i;
    wire [31:0] IF_ID_o;
    wire [31:0] PC_o;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .MemStall_i(MemStall_i),
        .PC_i(PC_i),
        .clk_i(clk_i),
        .flush_i(flush_i),
        .instr_i(instr_i),
        .stall_i(stall_i),
        .IF_ID_o(IF_ID_o),
        .PC_o(PC_o)
    );

    // Clock generation (10ns period)
    initial begin
        clk_i = 0;
        forever #5 clk_i = ~clk_i;
    end

        task reset_dut;

    begin
        MemStall_i = 0;
        PC_i = 0;
        flush_i = 0;
        instr_i = 0;
        stall_i = 0;
        @(posedge clk_i);
        #1;
    end
        endtask
    task testcase001;

    begin
        $display("Test Case 001: Normal Load");
        reset_dut();
        instr_i = 32'hA1A1B2B2;
        PC_i    = 32'h00000100;
        @(posedge clk_i);
        #2;
        #1;

        check_outputs(32'hA1A1B2B2, 32'h00000100);
    end
        endtask

    task testcase002;

    begin
        $display("Test Case 002: Processor Stall");
        reset_dut();

        instr_i = 32'h11111111;
        PC_i    = 32'h00000004;
        @(posedge clk_i);
        #2;

        stall_i = 1;
        instr_i = 32'hEEEEEEEE;
        PC_i    = 32'h00000008;
        @(posedge clk_i);
        #2;

        #1;


        check_outputs(32'h11111111, 32'h00000004);
    end
        endtask

    task testcase003;

    begin
        $display("Test Case 003: Memory Stall");
        reset_dut();

        instr_i = 32'h22222222;
        PC_i    = 32'h0000000C;
        @(posedge clk_i);
        #2;

        MemStall_i = 1;
        instr_i = 32'hFFFFFFFF;
        PC_i    = 32'h00000010;
        @(posedge clk_i);
        #2;

        #1;


        check_outputs(32'h22222222, 32'h0000000C);
    end
        endtask

    task testcase004;

    begin
        $display("Test Case 004: Flush Logic");
        reset_dut();

        instr_i = 32'h33333333;
        PC_i    = 32'h00000014;
        @(posedge clk_i);
        #2;

        flush_i = 1;
        instr_i = 32'h44444444;
        PC_i    = 32'h000000A0;
        @(posedge clk_i);
        #2;

        #1;


        check_outputs(32'h00000000, 32'h000000A0);
    end
        endtask

    task testcase005;

    begin
        $display("Test Case 005: Flush Priority over Stall");
        reset_dut();

        instr_i = 32'h55555555;
        PC_i    = 32'h00000020;
        @(posedge clk_i);
        #2;

        stall_i = 1;
        flush_i = 1;
        instr_i = 32'h66666666;
        PC_i    = 32'h000000B0;
        @(posedge clk_i);
        #2;

        #1;


        check_outputs(32'h00000000, 32'h000000B0);
    end
        endtask

    task testcase006;

    begin
        $display("Test Case 006: Sequential Updates");
        reset_dut();
        instr_i = 32'h00000001; PC_i = 32'h10; @(posedge clk_i);
        #1;
        instr_i = 32'h00000002; PC_i = 32'h14; @(posedge clk_i);
        #1;
        instr_i = 32'h00000003; PC_i = 32'h18; @(posedge clk_i);
        #2;
        #1;

        check_outputs(32'h00000003, 32'h18);
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
        input [31:0] expected_IF_ID_o;
        input [31:0] expected_PC_o;
        begin
            if (expected_IF_ID_o === (expected_IF_ID_o ^ IF_ID_o ^ expected_IF_ID_o) &&
                expected_PC_o === (expected_PC_o ^ PC_o ^ expected_PC_o)) begin
                $display("PASS");
                $display("  Outputs: IF_ID_o=%h, PC_o=%h",
                         IF_ID_o, PC_o);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: IF_ID_o=%h, PC_o=%h",
                         expected_IF_ID_o, expected_PC_o);
                $display("  Got:      IF_ID_o=%h, PC_o=%h",
                         IF_ID_o, PC_o);
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
        $dumpvars(0,MemStall_i, PC_i, clk_i, flush_i, instr_i, stall_i, IF_ID_o, PC_o);
    end

endmodule
