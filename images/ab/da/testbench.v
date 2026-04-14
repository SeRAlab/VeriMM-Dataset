`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [4:0] opcode;
    wire [1:0] ALUOp;
    wire ALUSrc;
    wire Branch;
    wire JAL;
    wire JALR;
    wire MemRead;
    wire MemToReg;
    wire MemWrite;
    wire RegWrite;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .opcode(opcode),
        .ALUOp(ALUOp),
        .ALUSrc(ALUSrc),
        .Branch(Branch),
        .JAL(JAL),
        .JALR(JALR),
        .MemRead(MemRead),
        .MemToReg(MemToReg),
        .MemWrite(MemWrite),
        .RegWrite(RegWrite)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: R-type Instruction (01100)", test_num);
        opcode = 5'b01100;

        #1;


        check_outputs(2'b10, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b1);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: I-type ALU Instruction (00100)", test_num);
        opcode = 5'b00100;

        #1;


        check_outputs(2'b10, 1'b1, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Load Instruction (00000)", test_num);
        opcode = 5'b00000;

        #1;


        check_outputs(2'b00, 1'b1, 1'b0, 1'b0, 1'b0, 1'b1, 1'b1, 1'b0, 1'b1);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Store Instruction (01000)", test_num);
        opcode = 5'b01000;

        #1;


        check_outputs(2'b00, 1'b1, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b1, 1'b0);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Branch Instruction (11000)", test_num);
        opcode = 5'b11000;

        #1;


        check_outputs(2'b01, 1'b0, 1'b1, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: JAL Instruction (11011)", test_num);
        opcode = 5'b11011;

        #1;


        check_outputs(2'b00, 1'b0, 1'b0, 1'b1, 1'b0, 1'b0, 1'b0, 1'b0, 1'b1);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: JALR Instruction (11001)", test_num);
        opcode = 5'b11001;

        #1;


        check_outputs(2'b00, 1'b1, 1'b0, 1'b0, 1'b1, 1'b0, 1'b0, 1'b0, 1'b1);
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
        input [1:0] expected_ALUOp;
        input expected_ALUSrc;
        input expected_Branch;
        input expected_JAL;
        input expected_JALR;
        input expected_MemRead;
        input expected_MemToReg;
        input expected_MemWrite;
        input expected_RegWrite;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_ALUOp === (expected_ALUOp ^ ALUOp ^ expected_ALUOp) &&
                expected_ALUSrc === (expected_ALUSrc ^ ALUSrc ^ expected_ALUSrc) &&
                expected_Branch === (expected_Branch ^ Branch ^ expected_Branch) &&
                expected_JAL === (expected_JAL ^ JAL ^ expected_JAL) &&
                expected_JALR === (expected_JALR ^ JALR ^ expected_JALR) &&
                expected_MemRead === (expected_MemRead ^ MemRead ^ expected_MemRead) &&
                expected_MemToReg === (expected_MemToReg ^ MemToReg ^ expected_MemToReg) &&
                expected_MemWrite === (expected_MemWrite ^ MemWrite ^ expected_MemWrite) &&
                expected_RegWrite === (expected_RegWrite ^ RegWrite ^ expected_RegWrite)) begin
                $display("PASS");
                $display("  Outputs: ALUOp=%h, ALUSrc=%b, Branch=%b, JAL=%b, JALR=%b, MemRead=%b, MemToReg=%b, MemWrite=%b, RegWrite=%b",
                         ALUOp, ALUSrc, Branch, JAL, JALR, MemRead, MemToReg, MemWrite, RegWrite);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ALUOp=%h, ALUSrc=%b, Branch=%b, JAL=%b, JALR=%b, MemRead=%b, MemToReg=%b, MemWrite=%b, RegWrite=%b",
                         expected_ALUOp, expected_ALUSrc, expected_Branch, expected_JAL, expected_JALR, expected_MemRead, expected_MemToReg, expected_MemWrite, expected_RegWrite);
                $display("  Got:      ALUOp=%h, ALUSrc=%b, Branch=%b, JAL=%b, JALR=%b, MemRead=%b, MemToReg=%b, MemWrite=%b, RegWrite=%b",
                         ALUOp, ALUSrc, Branch, JAL, JALR, MemRead, MemToReg, MemWrite, RegWrite);
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
