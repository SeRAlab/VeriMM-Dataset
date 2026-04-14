`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [31:0] M_ALU_Result;
    reg M_Flush;
    reg M_MemtoReg;
    reg [31:0] M_ReadData;
    reg M_RegWrite;
    reg [4:0] M_RtRd;
    reg M_Stall;
    reg [31:0] WB_ALU_Result;
    reg WB_MemtoReg;
    reg [31:0] WB_ReadData;
    reg WB_RegWrite;
    reg [4:0] WB_RtRd;
    reg WB_Stall;
    reg clock;
    reg reset;
    wire [31:0] vote_WB_ALU_Result;
    wire vote_WB_MemtoReg;
    wire [31:0] vote_WB_ReadData;
    wire vote_WB_RegWrite;
    wire [4:0] vote_WB_RtRd;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .M_ALU_Result(M_ALU_Result),
        .M_Flush(M_Flush),
        .M_MemtoReg(M_MemtoReg),
        .M_ReadData(M_ReadData),
        .M_RegWrite(M_RegWrite),
        .M_RtRd(M_RtRd),
        .M_Stall(M_Stall),
        .WB_ALU_Result(WB_ALU_Result),
        .WB_MemtoReg(WB_MemtoReg),
        .WB_ReadData(WB_ReadData),
        .WB_RegWrite(WB_RegWrite),
        .WB_RtRd(WB_RtRd),
        .WB_Stall(WB_Stall),
        .clock(clock),
        .reset(reset),
        .vote_WB_ALU_Result(vote_WB_ALU_Result),
        .vote_WB_MemtoReg(vote_WB_MemtoReg),
        .vote_WB_ReadData(vote_WB_ReadData),
        .vote_WB_RegWrite(vote_WB_RegWrite),
        .vote_WB_RtRd(vote_WB_RtRd)
    );

    // Clock generation (10ns period)
    initial begin
        clock = 0;
        forever #5 clock = ~clock;
    end

        task reset_dut;

        begin
            reset = 1;
            M_Flush = 0; M_Stall = 0; WB_Stall = 0;
            M_RegWrite = 0; M_MemtoReg = 0; M_ReadData = 0; M_ALU_Result = 0; M_RtRd = 0;
            WB_RegWrite = 0; WB_MemtoReg = 0; WB_ReadData = 0; WB_ALU_Result = 0; WB_RtRd = 0;
            @(posedge clock);
            #1;
            reset = 0;
        end
        endtask
    task testcase001;

        begin
            $display("Testcase 001: Reset");
            reset_dut();
            #1;

            check_outputs(32'h0, 0, 32'h0, 0, 5'h0);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Normal Data Propagation");
            reset_dut();
            M_RegWrite = 1; M_MemtoReg = 0;
            M_ReadData = 32'h1111_2222; M_ALU_Result = 32'hAAAA_5555; M_RtRd = 5'd10;
            M_Flush = 0; WB_Stall = 0;
            @(posedge clock);
            #1;
            #1;

            check_outputs(32'hAAAA_5555, 0, 32'h1111_2222, 1, 5'd10);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: WB_Stall (Hold)");
            reset_dut();

            M_RegWrite = 1; M_ALU_Result = 32'h1234_5678; M_RtRd = 5'd5;
            @(posedge clock); #1;


            WB_Stall = 1;
            WB_RegWrite = 1; WB_ALU_Result = 32'h1234_5678; WB_RtRd = 5'd5;
            M_ALU_Result = 32'hFFFF_FFFF; M_RtRd = 5'd31;
            @(posedge clock); #1;

            #1;


            check_outputs(32'h1234_5678, 0, 32'h0, 1, 5'd5);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: M_Flush");
            reset_dut();

            M_RegWrite = 1; M_ALU_Result = 32'h8888_9999;
            @(posedge clock); #1;


            M_Flush = 1;
            @(posedge clock); #1;
            #1;

            check_outputs(32'h0, 0, 32'h0, 0, 5'h0);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Flush priority over Stall");
            reset_dut();

            M_Flush = 1;
            WB_Stall = 1;
            WB_ALU_Result = 32'hDEAD_BEEF;
            @(posedge clock); #1;
            #1;

            check_outputs(32'h0, 0, 32'h0, 0, 5'h0);
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
        input [31:0] expected_vote_WB_ALU_Result;
        input expected_vote_WB_MemtoReg;
        input [31:0] expected_vote_WB_ReadData;
        input expected_vote_WB_RegWrite;
        input [4:0] expected_vote_WB_RtRd;
        begin
            if (expected_vote_WB_ALU_Result === (expected_vote_WB_ALU_Result ^ vote_WB_ALU_Result ^ expected_vote_WB_ALU_Result) &&
                expected_vote_WB_MemtoReg === (expected_vote_WB_MemtoReg ^ vote_WB_MemtoReg ^ expected_vote_WB_MemtoReg) &&
                expected_vote_WB_ReadData === (expected_vote_WB_ReadData ^ vote_WB_ReadData ^ expected_vote_WB_ReadData) &&
                expected_vote_WB_RegWrite === (expected_vote_WB_RegWrite ^ vote_WB_RegWrite ^ expected_vote_WB_RegWrite) &&
                expected_vote_WB_RtRd === (expected_vote_WB_RtRd ^ vote_WB_RtRd ^ expected_vote_WB_RtRd)) begin
                $display("PASS");
                $display("  Outputs: vote_WB_ALU_Result=%h, vote_WB_MemtoReg=%b, vote_WB_ReadData=%h, vote_WB_RegWrite=%b, vote_WB_RtRd=%h",
                         vote_WB_ALU_Result, vote_WB_MemtoReg, vote_WB_ReadData, vote_WB_RegWrite, vote_WB_RtRd);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: vote_WB_ALU_Result=%h, vote_WB_MemtoReg=%b, vote_WB_ReadData=%h, vote_WB_RegWrite=%b, vote_WB_RtRd=%h",
                         expected_vote_WB_ALU_Result, expected_vote_WB_MemtoReg, expected_vote_WB_ReadData, expected_vote_WB_RegWrite, expected_vote_WB_RtRd);
                $display("  Got:      vote_WB_ALU_Result=%h, vote_WB_MemtoReg=%b, vote_WB_ReadData=%h, vote_WB_RegWrite=%b, vote_WB_RtRd=%h",
                         vote_WB_ALU_Result, vote_WB_MemtoReg, vote_WB_ReadData, vote_WB_RegWrite, vote_WB_RtRd);
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
        $dumpvars(0,M_ALU_Result, M_Flush, M_MemtoReg, M_ReadData, M_RegWrite, M_RtRd, M_Stall, WB_ALU_Result, WB_MemtoReg, WB_ReadData, WB_RegWrite, WB_RtRd, WB_Stall, clock, reset, vote_WB_ALU_Result, vote_WB_MemtoReg, vote_WB_ReadData, vote_WB_RegWrite, vote_WB_RtRd);
    end

endmodule
