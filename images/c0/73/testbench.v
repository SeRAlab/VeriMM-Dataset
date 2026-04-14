`timescale 1ns/1ps

module MEMWB_Stage_tb;

    // Testbench signals (sequential circuit)
    reg [31:0] M_ALU_Result;
    reg M_Flush;
    reg M_MemtoReg;
    reg [31:0] M_ReadData;
    reg M_RegWrite;
    reg [4:0] M_RtRd;
    reg M_Stall;
    reg WB_Stall;
    reg clock;
    reg reset;
    wire [31:0] WB_ALU_Result;
    wire WB_MemtoReg;
    wire [31:0] WB_ReadData;
    wire WB_RegWrite;
    wire [4:0] WB_RtRd;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    MEMWB_Stage dut (
        .M_ALU_Result(M_ALU_Result),
        .M_Flush(M_Flush),
        .M_MemtoReg(M_MemtoReg),
        .M_ReadData(M_ReadData),
        .M_RegWrite(M_RegWrite),
        .M_RtRd(M_RtRd),
        .M_Stall(M_Stall),
        .WB_Stall(WB_Stall),
        .clock(clock),
        .reset(reset),
        .WB_ALU_Result(WB_ALU_Result),
        .WB_MemtoReg(WB_MemtoReg),
        .WB_ReadData(WB_ReadData),
        .WB_RegWrite(WB_RegWrite),
        .WB_RtRd(WB_RtRd)
    );

    // Clock generation (10ns period)
    initial begin
        clock = 0;
        forever #5 clock = ~clock;
    end

    task reset_dut;
    //define reset task
    endtask
    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("MEMWB_Stage Testbench");
        $display("========================================");


        
        
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
        input [31:0] expected_WB_ALU_Result;
        input expected_WB_MemtoReg;
        input [31:0] expected_WB_ReadData;
        input expected_WB_RegWrite;
        input [4:0] expected_WB_RtRd;
        begin
            if (expected_WB_ALU_Result === (expected_WB_ALU_Result ^ WB_ALU_Result ^ expected_WB_ALU_Result) &&
                expected_WB_MemtoReg === (expected_WB_MemtoReg ^ WB_MemtoReg ^ expected_WB_MemtoReg) &&
                expected_WB_ReadData === (expected_WB_ReadData ^ WB_ReadData ^ expected_WB_ReadData) &&
                expected_WB_RegWrite === (expected_WB_RegWrite ^ WB_RegWrite ^ expected_WB_RegWrite) &&
                expected_WB_RtRd === (expected_WB_RtRd ^ WB_RtRd ^ expected_WB_RtRd)) begin
                $display("PASS");
                $display("  Outputs: WB_ALU_Result=%h, WB_MemtoReg=%b, WB_ReadData=%h, WB_RegWrite=%b, WB_RtRd=%h",
                         WB_ALU_Result, WB_MemtoReg, WB_ReadData, WB_RegWrite, WB_RtRd);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: WB_ALU_Result=%h, WB_MemtoReg=%b, WB_ReadData=%h, WB_RegWrite=%b, WB_RtRd=%h",
                         expected_WB_ALU_Result, expected_WB_MemtoReg, expected_WB_ReadData, expected_WB_RegWrite, expected_WB_RtRd);
                $display("  Got:      WB_ALU_Result=%h, WB_MemtoReg=%b, WB_ReadData=%h, WB_RegWrite=%b, WB_RtRd=%h",
                         WB_ALU_Result, WB_MemtoReg, WB_ReadData, WB_RegWrite, WB_RtRd);
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
        $dumpvars(0,M_ALU_Result, M_Flush, M_MemtoReg, M_ReadData, M_RegWrite, M_RtRd, M_Stall, WB_Stall, clock, reset, WB_ALU_Result, WB_MemtoReg, WB_ReadData, WB_RegWrite, WB_RtRd);
    end

endmodule
