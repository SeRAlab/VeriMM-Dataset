`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [31:0] MEM_ALUResult;
    reg MEM_MemToReg;
    reg MEM_RegWrite;
    reg [4:0] MEM_RegWriteAddress;
    reg [31:0] MEM_instruction;
    reg [31:0] MemReadData;
    reg clock;
    wire [31:0] WB_ALUResult;
    wire [31:0] WB_MemReadData;
    wire WB_MemToReg;
    wire WB_RegWrite;
    wire [4:0] WB_RegWriteAddress;
    wire [31:0] WB_instruction;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .MEM_ALUResult(MEM_ALUResult),
        .MEM_MemToReg(MEM_MemToReg),
        .MEM_RegWrite(MEM_RegWrite),
        .MEM_RegWriteAddress(MEM_RegWriteAddress),
        .MEM_instruction(MEM_instruction),
        .MemReadData(MemReadData),
        .clock(clock),
        .WB_ALUResult(WB_ALUResult),
        .WB_MemReadData(WB_MemReadData),
        .WB_MemToReg(WB_MemToReg),
        .WB_RegWrite(WB_RegWrite),
        .WB_RegWriteAddress(WB_RegWriteAddress),
        .WB_instruction(WB_instruction)
    );

    // Clock generation (10ns period)
    initial begin
        clock = 0;
        forever #5 clock = ~clock;
    end

        task reset_dut;

    begin
        MEM_ALUResult = 32'h0;
        MEM_MemToReg = 1'b0;
        MEM_RegWrite = 1'b0;
        MEM_RegWriteAddress = 5'h0;
        MEM_instruction = 32'h0;
        MemReadData = 32'h0;
        @(posedge clock);
        #1;
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        reset_dut();


        MEM_instruction     = 32'h00A50533;
        MEM_ALUResult       = 32'h0000002A;
        MemReadData         = 32'h00000000;
        MEM_RegWriteAddress = 5'd10;
        MEM_RegWrite        = 1'b1;
        MEM_MemToReg        = 1'b0;


        @(posedge clock);
        #2;

        #1;


        check_outputs(32'h0000002A, 32'h00000000, 1'b0, 1'b1, 5'd10, 32'h00A50533);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        reset_dut();


        MEM_instruction     = 32'h00452583;
        MEM_ALUResult       = 32'h10000004;
        MemReadData         = 32'hABCDEFFF;
        MEM_RegWriteAddress = 5'd11;
        MEM_RegWrite        = 1'b1;
        MEM_MemToReg        = 1'b1;

        @(posedge clock);
        #2;

        #1;


        check_outputs(32'h10000004, 32'hABCDEFFF, 1'b1, 1'b1, 5'd11, 32'h00452583);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        reset_dut();

        MEM_instruction     = 32'hFFFFFFFF;
        MEM_ALUResult       = 32'hFFFFFFFF;
        MemReadData         = 32'hFFFFFFFF;
        MEM_RegWriteAddress = 5'h1F;
        MEM_RegWrite        = 1'b1;
        MEM_MemToReg        = 1'b1;

        @(posedge clock);
        #2;

        #1;


        check_outputs(32'hFFFFFFFF, 32'hFFFFFFFF, 1'b1, 1'b1, 5'h1F, 32'hFFFFFFFF);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        reset_dut();

        MEM_instruction     = 32'h55555555;
        MEM_ALUResult       = 32'hAAAAAAAA;
        MemReadData         = 32'h55555555;
        MEM_RegWriteAddress = 5'h0A;
        MEM_RegWrite        = 1'b0;
        MEM_MemToReg        = 1'b1;

        @(posedge clock);
        #2;

        #1;


        check_outputs(32'hAAAAAAAA, 32'h55555555, 1'b1, 1'b0, 5'h0A, 32'h55555555);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        reset_dut();

        MEM_instruction     = 32'h0;
        MEM_ALUResult       = 32'h0;
        MemReadData         = 32'h0;
        MEM_RegWriteAddress = 5'd31;
        MEM_RegWrite        = 1'b0;
        MEM_MemToReg        = 1'b0;

        @(posedge clock);
        #2;

        #1;


        check_outputs(32'h0, 32'h0, 1'b0, 1'b0, 5'd31, 32'h0);
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
        input [31:0] expected_WB_ALUResult;
        input [31:0] expected_WB_MemReadData;
        input expected_WB_MemToReg;
        input expected_WB_RegWrite;
        input [4:0] expected_WB_RegWriteAddress;
        input [31:0] expected_WB_instruction;
        begin
            if (expected_WB_ALUResult === (expected_WB_ALUResult ^ WB_ALUResult ^ expected_WB_ALUResult) &&
                expected_WB_MemReadData === (expected_WB_MemReadData ^ WB_MemReadData ^ expected_WB_MemReadData) &&
                expected_WB_MemToReg === (expected_WB_MemToReg ^ WB_MemToReg ^ expected_WB_MemToReg) &&
                expected_WB_RegWrite === (expected_WB_RegWrite ^ WB_RegWrite ^ expected_WB_RegWrite) &&
                expected_WB_RegWriteAddress === (expected_WB_RegWriteAddress ^ WB_RegWriteAddress ^ expected_WB_RegWriteAddress) &&
                expected_WB_instruction === (expected_WB_instruction ^ WB_instruction ^ expected_WB_instruction)) begin
                $display("PASS");
                $display("  Outputs: WB_ALUResult=%h, WB_MemReadData=%h, WB_MemToReg=%b, WB_RegWrite=%b, WB_RegWriteAddress=%h, WB_instruction=%h",
                         WB_ALUResult, WB_MemReadData, WB_MemToReg, WB_RegWrite, WB_RegWriteAddress, WB_instruction);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: WB_ALUResult=%h, WB_MemReadData=%h, WB_MemToReg=%b, WB_RegWrite=%b, WB_RegWriteAddress=%h, WB_instruction=%h",
                         expected_WB_ALUResult, expected_WB_MemReadData, expected_WB_MemToReg, expected_WB_RegWrite, expected_WB_RegWriteAddress, expected_WB_instruction);
                $display("  Got:      WB_ALUResult=%h, WB_MemReadData=%h, WB_MemToReg=%b, WB_RegWrite=%b, WB_RegWriteAddress=%h, WB_instruction=%h",
                         WB_ALUResult, WB_MemReadData, WB_MemToReg, WB_RegWrite, WB_RegWriteAddress, WB_instruction);
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
        $dumpvars(0,MEM_ALUResult, MEM_MemToReg, MEM_RegWrite, MEM_RegWriteAddress, MEM_instruction, MemReadData, clock, WB_ALUResult, WB_MemReadData, WB_MemToReg, WB_RegWrite, WB_RegWriteAddress, WB_instruction);
    end

endmodule
