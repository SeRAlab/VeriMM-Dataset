`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [31:0] MEM_PC;
    reg [1:0] MEM_RegSrc;
    reg MEM_RegWrite;
    reg [4:0] MEM_WriteReg;
    reg [31:0] MEM_aluResult;
    reg [31:0] MEM_dmOut;
    reg clk;
    reg rst;
    wire [31:0] WB_PC;
    wire [1:0] WB_RegSrc;
    wire WB_RegWrite;
    wire [4:0] WB_WriteReg;
    wire [31:0] WB_aluResult;
    wire [31:0] WB_dmOut;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .MEM_PC(MEM_PC),
        .MEM_RegSrc(MEM_RegSrc),
        .MEM_RegWrite(MEM_RegWrite),
        .MEM_WriteReg(MEM_WriteReg),
        .MEM_aluResult(MEM_aluResult),
        .MEM_dmOut(MEM_dmOut),
        .clk(clk),
        .rst(rst),
        .WB_PC(WB_PC),
        .WB_RegSrc(WB_RegSrc),
        .WB_RegWrite(WB_RegWrite),
        .WB_WriteReg(WB_WriteReg),
        .WB_aluResult(WB_aluResult),
        .WB_dmOut(WB_dmOut)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        rst = 1;
        MEM_PC = 0;
        MEM_RegSrc = 0;
        MEM_RegWrite = 0;
        MEM_WriteReg = 0;
        MEM_aluResult = 0;
        MEM_dmOut = 0;
        @(posedge clk);
        #1 rst = 0;
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        reset_dut();


        #1;



        check_outputs(32'h0, 2'b00, 1'b0, 5'h0, 32'h0, 32'h0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        reset_dut();

        MEM_RegWrite = 1'b1;
        MEM_WriteReg = 5'd15;
        MEM_RegSrc   = 2'b00;
        MEM_aluResult= 32'hDEADBEEF;
        MEM_dmOut    = 32'h0;
        MEM_PC       = 32'h00000004;

        @(posedge clk);
        #2;
        #1;

        check_outputs(32'h00000004, 2'b00, 1'b1, 5'd15, 32'hDEADBEEF, 32'h0);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        reset_dut();

        MEM_RegWrite = 1'b1;
        MEM_WriteReg = 2;
        MEM_RegSrc   = 2'b01;
        MEM_aluResult= 32'h1000FF00;
        MEM_dmOut    = 32'hABCDEF01;
        MEM_PC       = 32'h00000008;

        @(posedge clk);
        #2;
        #1;

        check_outputs(32'h00000008, 2'b01, 1'b1, 5'd2, 32'h1000FF00, 32'hABCDEF01);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        reset_dut();

        MEM_RegWrite = 1'b0;
        MEM_WriteReg = 5'd31;
        MEM_RegSrc   = 2'b10;
        MEM_aluResult= 32'h12345678;
        MEM_dmOut    = 32'h87654321;
        MEM_PC       = 32'h0000000C;

        @(posedge clk);
        #2;
        #1;

        check_outputs(32'h0000000C, 2'b10, 1'b0, 5'd31, 32'h12345678, 32'h87654321);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        reset_dut();

        MEM_RegWrite = 1'b1;
        MEM_WriteReg = 5'b11111;
        MEM_RegSrc   = 2'b11;
        MEM_aluResult= 32'hFFFFFFFF;
        MEM_dmOut    = 32'hFFFFFFFF;
        MEM_PC       = 32'hFFFFFFFF;

        @(posedge clk);
        #2;
        #1;

        check_outputs(32'hFFFFFFFF, 2'b11, 1'b1, 5'b11111, 32'hFFFFFFFF, 32'hFFFFFFFF);
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
        input [31:0] expected_WB_PC;
        input [1:0] expected_WB_RegSrc;
        input expected_WB_RegWrite;
        input [4:0] expected_WB_WriteReg;
        input [31:0] expected_WB_aluResult;
        input [31:0] expected_WB_dmOut;
        begin
            if (expected_WB_PC === (expected_WB_PC ^ WB_PC ^ expected_WB_PC) &&
                expected_WB_RegSrc === (expected_WB_RegSrc ^ WB_RegSrc ^ expected_WB_RegSrc) &&
                expected_WB_RegWrite === (expected_WB_RegWrite ^ WB_RegWrite ^ expected_WB_RegWrite) &&
                expected_WB_WriteReg === (expected_WB_WriteReg ^ WB_WriteReg ^ expected_WB_WriteReg) &&
                expected_WB_aluResult === (expected_WB_aluResult ^ WB_aluResult ^ expected_WB_aluResult) &&
                expected_WB_dmOut === (expected_WB_dmOut ^ WB_dmOut ^ expected_WB_dmOut)) begin
                $display("PASS");
                $display("  Outputs: WB_PC=%h, WB_RegSrc=%h, WB_RegWrite=%b, WB_WriteReg=%h, WB_aluResult=%h, WB_dmOut=%h",
                         WB_PC, WB_RegSrc, WB_RegWrite, WB_WriteReg, WB_aluResult, WB_dmOut);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: WB_PC=%h, WB_RegSrc=%h, WB_RegWrite=%b, WB_WriteReg=%h, WB_aluResult=%h, WB_dmOut=%h",
                         expected_WB_PC, expected_WB_RegSrc, expected_WB_RegWrite, expected_WB_WriteReg, expected_WB_aluResult, expected_WB_dmOut);
                $display("  Got:      WB_PC=%h, WB_RegSrc=%h, WB_RegWrite=%b, WB_WriteReg=%h, WB_aluResult=%h, WB_dmOut=%h",
                         WB_PC, WB_RegSrc, WB_RegWrite, WB_WriteReg, WB_aluResult, WB_dmOut);
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
        $dumpvars(0,MEM_PC, MEM_RegSrc, MEM_RegWrite, MEM_WriteReg, MEM_aluResult, MEM_dmOut, clk, rst, WB_PC, WB_RegSrc, WB_RegWrite, WB_WriteReg, WB_aluResult, WB_dmOut);
    end

endmodule
