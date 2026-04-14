`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [31:0] ALU_in;
    reg [1:0] M_in;
    reg [31:0] RDdata2_in;
    reg [1:0] WB_in;
    reg clk;
    reg hold_i;
    reg [4:0] instruction_mux_in;
    reg reset;
    wire [31:0] ALU_out;
    wire MemRead;
    wire MemWrite;
    wire [31:0] RDdata2_out;
    wire [1:0] WB_out;
    wire [4:0] instruction_mux_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ALU_in(ALU_in),
        .M_in(M_in),
        .RDdata2_in(RDdata2_in),
        .WB_in(WB_in),
        .clk(clk),
        .hold_i(hold_i),
        .instruction_mux_in(instruction_mux_in),
        .reset(reset),
        .ALU_out(ALU_out),
        .MemRead(MemRead),
        .MemWrite(MemWrite),
        .RDdata2_out(RDdata2_out),
        .WB_out(WB_out),
        .instruction_mux_out(instruction_mux_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        reset = 1;
        hold_i = 0;
        ALU_in = 32'b0;
        M_in = 2'b0;
        RDdata2_in = 32'b0;
        WB_in = 2'b0;
        instruction_mux_in = 5'b0;
        @(posedge clk);
        #2 reset = 0;
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %0d: Verifying Reset State", test_num);
        reset_dut();


        #1;



        check_outputs(32'h0, 1'b0, 1'b0, 32'h0, 2'b0, 5'h0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %0d: Normal Data Transfer (MemRead active)", test_num);
        reset_dut();


        ALU_in = 32'hA5A5_5A5A;
        M_in = 2'b10;
        RDdata2_in = 32'h1234_5678;
        WB_in = 2'b11;
        instruction_mux_in = 5'h10;
        hold_i = 0;

        @(posedge clk);
        #2;
        #1;

        check_outputs(32'hA5A5_5A5A, 1'b1, 1'b0, 32'h1234_5678, 2'b11, 5'h10);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %0d: Normal Data Transfer (MemWrite active)", test_num);
        reset_dut();

        ALU_in = 32'hFFFF_0000;
        M_in = 2'b01;
        RDdata2_in = 32'hCAFE_BABE;
        WB_in = 2'b01;
        instruction_mux_in = 5'h1F;
        hold_i = 0;

        @(posedge clk);
        #2;
        #1;

        check_outputs(32'hFFFF_0000, 1'b0, 1'b1, 32'hCAFE_BABE, 2'b01, 5'h1F);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %0d: Verify Hold (hold_i = 1)", test_num);
        reset_dut();


        ALU_in = 32'h1111_1111;
        M_in = 2'b11;
        RDdata2_in = 32'h2222_2222;
        WB_in = 2'b10;
        instruction_mux_in = 5'h05;
        hold_i = 0;
        @(posedge clk);
        #2;


        hold_i = 1;
        ALU_in = 32'hEEEE_EEEE;
        M_in = 2'b00;
        RDdata2_in = 32'hDDDD_DDDD;
        WB_in = 2'b11;
        instruction_mux_in = 5'h1A;

        @(posedge clk);
        #2;

        #1;


        check_outputs(32'h1111_1111, 1'b1, 1'b1, 32'h2222_2222, 2'b10, 5'h05);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %0d: Recovery from Hold", test_num);
        reset_dut();


        hold_i = 1;
        ALU_in = 32'h8888_8888;
        M_in = 2'b10;
        RDdata2_in = 32'h7777_7777;
        WB_in = 2'b11;
        instruction_mux_in = 5'h0C;
        @(posedge clk);
        #2;



        hold_i = 0;
        @(posedge clk);
        #2;

        #1;


        check_outputs(32'h8888_8888, 1'b1, 1'b0, 32'h7777_7777, 2'b11, 5'h0C);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %0d: All Bits High", test_num);
        reset_dut();

        ALU_in = 32'hFFFF_FFFF;
        M_in = 2'b11;
        RDdata2_in = 32'hFFFF_FFFF;
        WB_in = 2'b11;
        instruction_mux_in = 5'h1F;
        hold_i = 0;

        @(posedge clk);
        #2;
        #1;

        check_outputs(32'hFFFF_FFFF, 1'b1, 1'b1, 32'hFFFF_FFFF, 2'b11, 5'h1F);
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
        input [31:0] expected_ALU_out;
        input expected_MemRead;
        input expected_MemWrite;
        input [31:0] expected_RDdata2_out;
        input [1:0] expected_WB_out;
        input [4:0] expected_instruction_mux_out;
        begin
            if (expected_ALU_out === (expected_ALU_out ^ ALU_out ^ expected_ALU_out) &&
                expected_MemRead === (expected_MemRead ^ MemRead ^ expected_MemRead) &&
                expected_MemWrite === (expected_MemWrite ^ MemWrite ^ expected_MemWrite) &&
                expected_RDdata2_out === (expected_RDdata2_out ^ RDdata2_out ^ expected_RDdata2_out) &&
                expected_WB_out === (expected_WB_out ^ WB_out ^ expected_WB_out) &&
                expected_instruction_mux_out === (expected_instruction_mux_out ^ instruction_mux_out ^ expected_instruction_mux_out)) begin
                $display("PASS");
                $display("  Outputs: ALU_out=%h, MemRead=%b, MemWrite=%b, RDdata2_out=%h, WB_out=%h, instruction_mux_out=%h",
                         ALU_out, MemRead, MemWrite, RDdata2_out, WB_out, instruction_mux_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ALU_out=%h, MemRead=%b, MemWrite=%b, RDdata2_out=%h, WB_out=%h, instruction_mux_out=%h",
                         expected_ALU_out, expected_MemRead, expected_MemWrite, expected_RDdata2_out, expected_WB_out, expected_instruction_mux_out);
                $display("  Got:      ALU_out=%h, MemRead=%b, MemWrite=%b, RDdata2_out=%h, WB_out=%h, instruction_mux_out=%h",
                         ALU_out, MemRead, MemWrite, RDdata2_out, WB_out, instruction_mux_out);
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
        $dumpvars(0,ALU_in, M_in, RDdata2_in, WB_in, clk, hold_i, instruction_mux_in, reset, ALU_out, MemRead, MemWrite, RDdata2_out, WB_out, instruction_mux_out);
    end

endmodule
