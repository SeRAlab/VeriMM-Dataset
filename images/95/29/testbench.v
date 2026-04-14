`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [31:0] ALUResult;
    reg EX_Branch;
    reg EX_MemRead;
    reg EX_MemToReg;
    reg EX_MemWrite;
    reg EX_RegWrite;
    reg [31:0] EX_instruction;
    reg [31:0] ForwardBOut;
    reg [4:0] RegWriteAddress;
    reg Zero;
    reg bneOne;
    reg [31:0] branch_address;
    reg clock;
    wire [31:0] MEM_ALUResult;
    wire MEM_Branch;
    wire [31:0] MEM_ForwardBOut;
    wire MEM_MemRead;
    wire MEM_MemToReg;
    wire MEM_MemWrite;
    wire MEM_RegWrite;
    wire [4:0] MEM_RegWriteAddress;
    wire MEM_Zero;
    wire MEM_bneOne;
    wire [31:0] MEM_branch_address;
    wire [31:0] MEM_instruction;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ALUResult(ALUResult),
        .EX_Branch(EX_Branch),
        .EX_MemRead(EX_MemRead),
        .EX_MemToReg(EX_MemToReg),
        .EX_MemWrite(EX_MemWrite),
        .EX_RegWrite(EX_RegWrite),
        .EX_instruction(EX_instruction),
        .ForwardBOut(ForwardBOut),
        .RegWriteAddress(RegWriteAddress),
        .Zero(Zero),
        .bneOne(bneOne),
        .branch_address(branch_address),
        .clock(clock),
        .MEM_ALUResult(MEM_ALUResult),
        .MEM_Branch(MEM_Branch),
        .MEM_ForwardBOut(MEM_ForwardBOut),
        .MEM_MemRead(MEM_MemRead),
        .MEM_MemToReg(MEM_MemToReg),
        .MEM_MemWrite(MEM_MemWrite),
        .MEM_RegWrite(MEM_RegWrite),
        .MEM_RegWriteAddress(MEM_RegWriteAddress),
        .MEM_Zero(MEM_Zero),
        .MEM_bneOne(MEM_bneOne),
        .MEM_branch_address(MEM_branch_address),
        .MEM_instruction(MEM_instruction)
    );

    // Clock generation (10ns period)
    initial begin
        clock = 0;
        forever #5 clock = ~clock;
    end

        task reset_dut;

        begin
            ALUResult = 32'h0;
            EX_Branch = 1'b0;
            EX_MemRead = 1'b0;
            EX_MemToReg = 1'b0;
            EX_MemWrite = 1'b0;
            EX_RegWrite = 1'b0;
            EX_instruction = 32'h0;
            ForwardBOut = 32'h0;
            RegWriteAddress = 5'h0;
            Zero = 1'b0;
            bneOne = 1'b0;
            branch_address = 32'h0;
            @(posedge clock);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Testcase %0d: All Zeros", test_num);

            ALUResult = 32'h0;
            EX_Branch = 1'b0;
            EX_MemRead = 1'b0;
            EX_MemToReg = 1'b0;
            EX_MemWrite = 1'b0;
            EX_RegWrite = 1'b0;
            EX_instruction = 32'h0;
            ForwardBOut = 32'h0;
            RegWriteAddress = 5'h0;
            Zero = 1'b0;
            bneOne = 1'b0;
            branch_address = 32'h0;

            @(posedge clock);
            #1;
            #1;

            check_outputs(32'h0, 1'b0, 32'h0, 1'b0, 1'b0, 1'b0, 1'b0, 5'h0, 1'b0, 1'b0, 32'h0, 32'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Testcase %0d: R-type Instruction Path", test_num);

            EX_instruction = 32'h00af8020;
            ALUResult = 32'hABCD1234;
            ForwardBOut = 32'h0000FFFF;
            RegWriteAddress = 5'd16;
            EX_RegWrite = 1'b1;
            EX_MemRead = 1'b0;
            EX_MemWrite = 1'b0;
            EX_MemToReg = 1'b0;
            EX_Branch = 1'b0;
            Zero = 1'b0;
            bneOne = 1'b0;
            branch_address = 32'h0;

            @(posedge clock);
            #1;
            #1;

            check_outputs(32'hABCD1234, 1'b0, 32'h0000FFFF, 1'b0, 1'b0, 1'b0, 1'b1, 5'd16, 1'b0, 1'b0, 32'h0, 32'h00af8020);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Testcase %0d: Branch Logic Path", test_num);

            EX_instruction = 32'h11090005;
            branch_address = 32'h00000040;
            Zero = 1'b1;
            EX_Branch = 1'b1;
            bneOne = 1'b0;


            ALUResult = 32'h0;
            ForwardBOut = 32'h12345678;
            RegWriteAddress = 5'h0;
            EX_RegWrite = 1'b0;
            EX_MemRead = 1'b0;
            EX_MemWrite = 1'b0;
            EX_MemToReg = 1'b0;

            @(posedge clock);
            #1;
            #1;

            check_outputs(32'h0, 1'b1, 32'h12345678, 1'b0, 1'b0, 1'b0, 1'b0, 5'h0, 1'b1, 1'b0, 32'h00000040, 32'h11090005);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Testcase %0d: Load/Store Path", test_num);

            EX_instruction = 32'h8C420004;
            ALUResult = 32'h10000004;
            ForwardBOut = 32'h0;
            RegWriteAddress = 5'd2;
            EX_RegWrite = 1'b1;
            EX_MemRead = 1'b1;
            EX_MemWrite = 1'b0;
            EX_MemToReg = 1'b1;
            EX_Branch = 1'b0;
            Zero = 1'b0;
            bneOne = 1'b0;

            @(posedge clock);
            #1;
            #1;

            check_outputs(32'h10000004, 1'b0, 32'h0, 1'b1, 1'b1, 1'b0, 1'b1, 5'd2, 1'b0, 1'b0, 32'h0, 32'h8C420004);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Testcase %0d: Maximum Values and Bit Patterns", test_num);

            EX_instruction = 32'hFFFFFFFF;
            ALUResult = 32'hAAAAAAAA;
            ForwardBOut = 32'h55555555;
            branch_address = 32'hF0F0F0F0;
            RegWriteAddress = 5'h1F;
            EX_RegWrite = 1'b1;
            EX_MemRead = 1'b1;
            EX_MemWrite = 1'b1;
            EX_MemToReg = 1'b1;
            EX_Branch = 1'b1;
            Zero = 1'b1;
            bneOne = 1'b1;

            @(posedge clock);
            #1;
            #1;

            check_outputs(32'hAAAAAAAA, 1'b1, 32'h55555555, 1'b1, 1'b1, 1'b1, 1'b1, 5'h1F, 1'b1, 1'b1, 32'hF0F0F0F0, 32'hFFFFFFFF);
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
        input [31:0] expected_MEM_ALUResult;
        input expected_MEM_Branch;
        input [31:0] expected_MEM_ForwardBOut;
        input expected_MEM_MemRead;
        input expected_MEM_MemToReg;
        input expected_MEM_MemWrite;
        input expected_MEM_RegWrite;
        input [4:0] expected_MEM_RegWriteAddress;
        input expected_MEM_Zero;
        input expected_MEM_bneOne;
        input [31:0] expected_MEM_branch_address;
        input [31:0] expected_MEM_instruction;
        begin
            if (expected_MEM_ALUResult === (expected_MEM_ALUResult ^ MEM_ALUResult ^ expected_MEM_ALUResult) &&
                expected_MEM_Branch === (expected_MEM_Branch ^ MEM_Branch ^ expected_MEM_Branch) &&
                expected_MEM_ForwardBOut === (expected_MEM_ForwardBOut ^ MEM_ForwardBOut ^ expected_MEM_ForwardBOut) &&
                expected_MEM_MemRead === (expected_MEM_MemRead ^ MEM_MemRead ^ expected_MEM_MemRead) &&
                expected_MEM_MemToReg === (expected_MEM_MemToReg ^ MEM_MemToReg ^ expected_MEM_MemToReg) &&
                expected_MEM_MemWrite === (expected_MEM_MemWrite ^ MEM_MemWrite ^ expected_MEM_MemWrite) &&
                expected_MEM_RegWrite === (expected_MEM_RegWrite ^ MEM_RegWrite ^ expected_MEM_RegWrite) &&
                expected_MEM_RegWriteAddress === (expected_MEM_RegWriteAddress ^ MEM_RegWriteAddress ^ expected_MEM_RegWriteAddress) &&
                expected_MEM_Zero === (expected_MEM_Zero ^ MEM_Zero ^ expected_MEM_Zero) &&
                expected_MEM_bneOne === (expected_MEM_bneOne ^ MEM_bneOne ^ expected_MEM_bneOne) &&
                expected_MEM_branch_address === (expected_MEM_branch_address ^ MEM_branch_address ^ expected_MEM_branch_address) &&
                expected_MEM_instruction === (expected_MEM_instruction ^ MEM_instruction ^ expected_MEM_instruction)) begin
                $display("PASS");
                $display("  Outputs: MEM_ALUResult=%h, MEM_Branch=%b, MEM_ForwardBOut=%h, MEM_MemRead=%b, MEM_MemToReg=%b, MEM_MemWrite=%b, MEM_RegWrite=%b, MEM_RegWriteAddress=%h, MEM_Zero=%b, MEM_bneOne=%b, MEM_branch_address=%h, MEM_instruction=%h",
                         MEM_ALUResult, MEM_Branch, MEM_ForwardBOut, MEM_MemRead, MEM_MemToReg, MEM_MemWrite, MEM_RegWrite, MEM_RegWriteAddress, MEM_Zero, MEM_bneOne, MEM_branch_address, MEM_instruction);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: MEM_ALUResult=%h, MEM_Branch=%b, MEM_ForwardBOut=%h, MEM_MemRead=%b, MEM_MemToReg=%b, MEM_MemWrite=%b, MEM_RegWrite=%b, MEM_RegWriteAddress=%h, MEM_Zero=%b, MEM_bneOne=%b, MEM_branch_address=%h, MEM_instruction=%h",
                         expected_MEM_ALUResult, expected_MEM_Branch, expected_MEM_ForwardBOut, expected_MEM_MemRead, expected_MEM_MemToReg, expected_MEM_MemWrite, expected_MEM_RegWrite, expected_MEM_RegWriteAddress, expected_MEM_Zero, expected_MEM_bneOne, expected_MEM_branch_address, expected_MEM_instruction);
                $display("  Got:      MEM_ALUResult=%h, MEM_Branch=%b, MEM_ForwardBOut=%h, MEM_MemRead=%b, MEM_MemToReg=%b, MEM_MemWrite=%b, MEM_RegWrite=%b, MEM_RegWriteAddress=%h, MEM_Zero=%b, MEM_bneOne=%b, MEM_branch_address=%h, MEM_instruction=%h",
                         MEM_ALUResult, MEM_Branch, MEM_ForwardBOut, MEM_MemRead, MEM_MemToReg, MEM_MemWrite, MEM_RegWrite, MEM_RegWriteAddress, MEM_Zero, MEM_bneOne, MEM_branch_address, MEM_instruction);
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
        $dumpvars(0,ALUResult, EX_Branch, EX_MemRead, EX_MemToReg, EX_MemWrite, EX_RegWrite, EX_instruction, ForwardBOut, RegWriteAddress, Zero, bneOne, branch_address, clock, MEM_ALUResult, MEM_Branch, MEM_ForwardBOut, MEM_MemRead, MEM_MemToReg, MEM_MemWrite, MEM_RegWrite, MEM_RegWriteAddress, MEM_Zero, MEM_bneOne, MEM_branch_address, MEM_instruction);
    end

endmodule
