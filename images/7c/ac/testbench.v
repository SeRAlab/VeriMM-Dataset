`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [10:0] opcode;
    wire ALUOp0;
    wire ALUOp1;
    wire ALUSrc;
    wire Branch;
    wire MemRead;
    wire MemWrite;
    wire MemtoReg;
    wire Reg2Loc;
    wire RegWrite;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .opcode(opcode),
        .ALUOp0(ALUOp0),
        .ALUOp1(ALUOp1),
        .ALUSrc(ALUSrc),
        .Branch(Branch),
        .MemRead(MemRead),
        .MemWrite(MemWrite),
        .MemtoReg(MemtoReg),
        .Reg2Loc(Reg2Loc),
        .RegWrite(RegWrite)
    );
    task testcase001;

    begin
        $display("Test Case 001: LDUR Instruction");
        test_num = 1;
        opcode = 11'b11111000010;

        #1;


        check_outputs(1'b0, 1'b0, 1'b1, 1'b0, 1'b1, 1'b0, 1'b1, 1'b0, 1'b1);
    end
        endtask

    task testcase002;

    begin
        $display("Test Case 002: STUR Instruction");
        test_num = 2;
        opcode = 11'b11111000000;

        #1;


        check_outputs(1'b0, 1'b0, 1'b1, 1'b0, 1'b0, 1'b1, 1'b0, 1'b1, 1'b0);
    end
        endtask

    task testcase003;

    begin
        $display("Test Case 003: CBZ Instruction");
        test_num = 3;
        opcode = 11'b10110100000;

        #1;


        check_outputs(1'b1, 1'b0, 1'b0, 1'b1, 1'b0, 1'b0, 1'b0, 1'b1, 1'b0);
    end
        endtask

    task testcase004;

    begin
        $display("Test Case 004: ADD Instruction (R-type)");
        test_num = 4;
        opcode = 11'b10001011000;

        #1;


        check_outputs(1'b0, 1'b1, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b1);
    end
        endtask

    task testcase005;

    begin
        $display("Test Case 005: SUB Instruction (R-type)");
        test_num = 5;
        opcode = 11'b11001011000;

        #1;


        check_outputs(1'b0, 1'b1, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b1);
    end
        endtask

    task testcase006;

    begin
        $display("Test Case 006: AND Instruction (R-type)");
        test_num = 6;
        opcode = 11'b10001010000;

        #1;


        check_outputs(1'b0, 1'b1, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b1);
    end
        endtask

    task testcase007;

    begin
        $display("Test Case 007: ORR Instruction (R-type)");
        test_num = 7;
        opcode = 11'b10101010000;

        #1;


        check_outputs(1'b0, 1'b1, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b1);
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
        testcase007();
        
        
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
        input expected_ALUOp0;
        input expected_ALUOp1;
        input expected_ALUSrc;
        input expected_Branch;
        input expected_MemRead;
        input expected_MemWrite;
        input expected_MemtoReg;
        input expected_Reg2Loc;
        input expected_RegWrite;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_ALUOp0 === (expected_ALUOp0 ^ ALUOp0 ^ expected_ALUOp0) &&
                expected_ALUOp1 === (expected_ALUOp1 ^ ALUOp1 ^ expected_ALUOp1) &&
                expected_ALUSrc === (expected_ALUSrc ^ ALUSrc ^ expected_ALUSrc) &&
                expected_Branch === (expected_Branch ^ Branch ^ expected_Branch) &&
                expected_MemRead === (expected_MemRead ^ MemRead ^ expected_MemRead) &&
                expected_MemWrite === (expected_MemWrite ^ MemWrite ^ expected_MemWrite) &&
                expected_MemtoReg === (expected_MemtoReg ^ MemtoReg ^ expected_MemtoReg) &&
                expected_Reg2Loc === (expected_Reg2Loc ^ Reg2Loc ^ expected_Reg2Loc) &&
                expected_RegWrite === (expected_RegWrite ^ RegWrite ^ expected_RegWrite)) begin
                $display("PASS");
                $display("  Outputs: ALUOp0=%b, ALUOp1=%b, ALUSrc=%b, Branch=%b, MemRead=%b, MemWrite=%b, MemtoReg=%b, Reg2Loc=%b, RegWrite=%b",
                         ALUOp0, ALUOp1, ALUSrc, Branch, MemRead, MemWrite, MemtoReg, Reg2Loc, RegWrite);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ALUOp0=%b, ALUOp1=%b, ALUSrc=%b, Branch=%b, MemRead=%b, MemWrite=%b, MemtoReg=%b, Reg2Loc=%b, RegWrite=%b",
                         expected_ALUOp0, expected_ALUOp1, expected_ALUSrc, expected_Branch, expected_MemRead, expected_MemWrite, expected_MemtoReg, expected_Reg2Loc, expected_RegWrite);
                $display("  Got:      ALUOp0=%b, ALUOp1=%b, ALUSrc=%b, Branch=%b, MemRead=%b, MemWrite=%b, MemtoReg=%b, Reg2Loc=%b, RegWrite=%b",
                         ALUOp0, ALUOp1, ALUSrc, Branch, MemRead, MemWrite, MemtoReg, Reg2Loc, RegWrite);
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

endmodule
