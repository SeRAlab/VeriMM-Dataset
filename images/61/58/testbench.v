`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [31:0] EX_ALUorNPC;
    reg [2:0] EX_JumpBranch;
    reg EX_MemWrite;
    reg EX_MemtoReg;
    reg EX_RegWrite;
    reg [4:0] EX_rtAddr;
    reg [31:0] EX_wmData;
    reg [4:0] EX_wrAddr;
    reg clk;
    reg rst;
    wire [31:0] MEM_ALUorNPC;
    wire [2:0] MEM_JumpBranch;
    wire MEM_MemWrite;
    wire MEM_MemtoReg;
    wire MEM_RegWrite;
    wire [4:0] MEM_rtAddr;
    wire [31:0] MEM_wmData;
    wire [4:0] MEM_wrAddr;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .EX_ALUorNPC(EX_ALUorNPC),
        .EX_JumpBranch(EX_JumpBranch),
        .EX_MemWrite(EX_MemWrite),
        .EX_MemtoReg(EX_MemtoReg),
        .EX_RegWrite(EX_RegWrite),
        .EX_rtAddr(EX_rtAddr),
        .EX_wmData(EX_wmData),
        .EX_wrAddr(EX_wrAddr),
        .clk(clk),
        .rst(rst),
        .MEM_ALUorNPC(MEM_ALUorNPC),
        .MEM_JumpBranch(MEM_JumpBranch),
        .MEM_MemWrite(MEM_MemWrite),
        .MEM_MemtoReg(MEM_MemtoReg),
        .MEM_RegWrite(MEM_RegWrite),
        .MEM_rtAddr(MEM_rtAddr),
        .MEM_wmData(MEM_wmData),
        .MEM_wrAddr(MEM_wrAddr)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        rst = 1;
        EX_ALUorNPC = 0;
        EX_JumpBranch = 0;
        EX_MemWrite = 0;
        EX_MemtoReg = 0;
        EX_RegWrite = 0;
        EX_rtAddr = 0;
        EX_wmData = 0;
        EX_wrAddr = 0;
        @(posedge clk);
        #1;
        rst = 0;
        @(posedge clk);
        #1;
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Reset State Verification", test_num);
        reset_dut();

        #1;


        check_outputs(32'h0, 3'h0, 1'b0, 1'b0, 1'b0, 5'h0, 32'h0, 5'h0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test %0d: ALU Operation Propagation", test_num);
        reset_dut();


        EX_RegWrite = 1'b1;
        EX_MemtoReg = 1'b0;
        EX_MemWrite = 1'b0;
        EX_JumpBranch = 3'b000;
        EX_ALUorNPC = 32'hDEADBEEF;
        EX_wmData = 32'h0;
        EX_rtAddr = 5'd10;
        EX_wrAddr = 5'd11;

        @(posedge clk);
        #2;
        #1;

        check_outputs(32'hDEADBEEF, 3'b000, 1'b0, 1'b0, 1'b1, 5'd10, 32'h0, 5'd11);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Store Word Propagation", test_num);
        reset_dut();


        EX_RegWrite = 1'b0;
        EX_MemtoReg = 1'b0;
        EX_MemWrite = 1'b1;
        EX_JumpBranch = 3'b000;
        EX_ALUorNPC = 32'h00001004;
        EX_wmData = 32'hCAFEBABE;
        EX_rtAddr = 5'd10;
        EX_wrAddr = 5'd0;

        @(posedge clk);
        #2;
        #1;

        check_outputs(32'h00001004, 3'b000, 1'b1, 1'b0, 1'b0, 5'd10, 32'hCAFEBABE, 5'd0);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Load Word Propagation", test_num);
        reset_dut();


        EX_RegWrite = 1'b1;
        EX_MemtoReg = 1'b1;
        EX_MemWrite = 1'b0;
        EX_JumpBranch = 3'b000;
        EX_ALUorNPC = 32'h00002008;
        EX_wmData = 32'h0;
        EX_rtAddr = 5'd11;
        EX_wrAddr = 5'd11;

        @(posedge clk);
        #2;
        #1;

        check_outputs(32'h00002008, 3'b000, 1'b0, 1'b1, 1'b1, 5'd11, 32'h0, 5'd11);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Jump/Branch Propagation", test_num);
        reset_dut();


        EX_RegWrite = 1'b0;
        EX_MemtoReg = 1'b0;
        EX_MemWrite = 1'b0;
        EX_JumpBranch = 3'b101;
        EX_ALUorNPC = 32'h00000400;
        EX_wmData = 32'h0;
        EX_rtAddr = 5'd0;
        EX_wrAddr = 5'd0;

        @(posedge clk);
        #2;
        #1;

        check_outputs(32'h00000400, 3'b101, 1'b0, 1'b0, 1'b0, 5'd0, 32'h0, 5'd0);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Maximum Signal Values", test_num);
        reset_dut();

        EX_RegWrite = 1'b1;
        EX_MemtoReg = 1'b1;
        EX_MemWrite = 1'b1;
        EX_JumpBranch = 3'b111;
        EX_ALUorNPC = 32'hFFFFFFFF;
        EX_wmData = 32'hFFFFFFFF;
        EX_rtAddr = 5'b11111;
        EX_wrAddr = 5'b11111;

        @(posedge clk);
        #2;
        #1;

        check_outputs(32'hFFFFFFFF, 3'b111, 1'b1, 1'b1, 1'b1, 5'h1F, 32'hFFFFFFFF, 5'h1F);
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
        input [31:0] expected_MEM_ALUorNPC;
        input [2:0] expected_MEM_JumpBranch;
        input expected_MEM_MemWrite;
        input expected_MEM_MemtoReg;
        input expected_MEM_RegWrite;
        input [4:0] expected_MEM_rtAddr;
        input [31:0] expected_MEM_wmData;
        input [4:0] expected_MEM_wrAddr;
        begin
            if (expected_MEM_ALUorNPC === (expected_MEM_ALUorNPC ^ MEM_ALUorNPC ^ expected_MEM_ALUorNPC) &&
                expected_MEM_JumpBranch === (expected_MEM_JumpBranch ^ MEM_JumpBranch ^ expected_MEM_JumpBranch) &&
                expected_MEM_MemWrite === (expected_MEM_MemWrite ^ MEM_MemWrite ^ expected_MEM_MemWrite) &&
                expected_MEM_MemtoReg === (expected_MEM_MemtoReg ^ MEM_MemtoReg ^ expected_MEM_MemtoReg) &&
                expected_MEM_RegWrite === (expected_MEM_RegWrite ^ MEM_RegWrite ^ expected_MEM_RegWrite) &&
                expected_MEM_rtAddr === (expected_MEM_rtAddr ^ MEM_rtAddr ^ expected_MEM_rtAddr) &&
                expected_MEM_wmData === (expected_MEM_wmData ^ MEM_wmData ^ expected_MEM_wmData) &&
                expected_MEM_wrAddr === (expected_MEM_wrAddr ^ MEM_wrAddr ^ expected_MEM_wrAddr)) begin
                $display("PASS");
                $display("  Outputs: MEM_ALUorNPC=%h, MEM_JumpBranch=%h, MEM_MemWrite=%b, MEM_MemtoReg=%b, MEM_RegWrite=%b, MEM_rtAddr=%h, MEM_wmData=%h, MEM_wrAddr=%h",
                         MEM_ALUorNPC, MEM_JumpBranch, MEM_MemWrite, MEM_MemtoReg, MEM_RegWrite, MEM_rtAddr, MEM_wmData, MEM_wrAddr);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: MEM_ALUorNPC=%h, MEM_JumpBranch=%h, MEM_MemWrite=%b, MEM_MemtoReg=%b, MEM_RegWrite=%b, MEM_rtAddr=%h, MEM_wmData=%h, MEM_wrAddr=%h",
                         expected_MEM_ALUorNPC, expected_MEM_JumpBranch, expected_MEM_MemWrite, expected_MEM_MemtoReg, expected_MEM_RegWrite, expected_MEM_rtAddr, expected_MEM_wmData, expected_MEM_wrAddr);
                $display("  Got:      MEM_ALUorNPC=%h, MEM_JumpBranch=%h, MEM_MemWrite=%b, MEM_MemtoReg=%b, MEM_RegWrite=%b, MEM_rtAddr=%h, MEM_wmData=%h, MEM_wrAddr=%h",
                         MEM_ALUorNPC, MEM_JumpBranch, MEM_MemWrite, MEM_MemtoReg, MEM_RegWrite, MEM_rtAddr, MEM_wmData, MEM_wrAddr);
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
        $dumpvars(0,EX_ALUorNPC, EX_JumpBranch, EX_MemWrite, EX_MemtoReg, EX_RegWrite, EX_rtAddr, EX_wmData, EX_wrAddr, clk, rst, MEM_ALUorNPC, MEM_JumpBranch, MEM_MemWrite, MEM_MemtoReg, MEM_RegWrite, MEM_rtAddr, MEM_wmData, MEM_wrAddr);
    end

endmodule
