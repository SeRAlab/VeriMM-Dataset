`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [5:0] op;
    wire [1:0] ALUOp;
    wire ALUSrc;
    wire Branch;
    wire MemWrite;
    wire MemtoReg;
    wire RegDst;
    wire RegWrite;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .op(op),
        .ALUOp(ALUOp),
        .ALUSrc(ALUSrc),
        .Branch(Branch),
        .MemWrite(MemWrite),
        .MemtoReg(MemtoReg),
        .RegDst(RegDst),
        .RegWrite(RegWrite)
    );
    task testcase001;

        begin
            $display("\nRunning Testcase 001: R-type Instruction (Opcode 000000)");
            op = 6'b000000;

            #1;


            check_outputs(2'b10, 1'b0, 1'b0, 1'b0, 1'b0, 1'b1, 1'b1);
        end
        endtask

    task testcase002;

        begin
            $display("\nRunning Testcase 002: Load Word Instruction (Opcode 100011)");
            op = 6'b100011;

            #1;


            check_outputs(2'b00, 1'b1, 1'b0, 1'b0, 1'b1, 1'b0, 1'b1);
        end
        endtask

    task testcase003;

        begin
            $display("\nRunning Testcase 003: Store Word Instruction (Opcode 101011)");
            op = 6'b101011;

            #1;


            check_outputs(2'b00, 1'b1, 1'b0, 1'b1, 1'b0, 1'b0, 1'b0);
        end
        endtask

    task testcase004;

        begin
            $display("\nRunning Testcase 004: Branch Equal Instruction (Opcode 000100)");
            op = 6'b000100;

            #1;


            check_outputs(2'b01, 1'b0, 1'b1, 1'b0, 1'b0, 1'b0, 1'b0);
        end
        endtask

    task testcase005;

        begin
            $display("\nRunning Testcase 005: Optional - Add Immediate Instruction (Opcode 001000)");
            op = 6'b001000;

            #1;


            check_outputs(2'b00, 1'b1, 1'b0, 1'b0, 1'b0, 1'b0, 1'b1);
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
        input [1:0] expected_ALUOp;
        input expected_ALUSrc;
        input expected_Branch;
        input expected_MemWrite;
        input expected_MemtoReg;
        input expected_RegDst;
        input expected_RegWrite;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_ALUOp === (expected_ALUOp ^ ALUOp ^ expected_ALUOp) &&
                expected_ALUSrc === (expected_ALUSrc ^ ALUSrc ^ expected_ALUSrc) &&
                expected_Branch === (expected_Branch ^ Branch ^ expected_Branch) &&
                expected_MemWrite === (expected_MemWrite ^ MemWrite ^ expected_MemWrite) &&
                expected_MemtoReg === (expected_MemtoReg ^ MemtoReg ^ expected_MemtoReg) &&
                expected_RegDst === (expected_RegDst ^ RegDst ^ expected_RegDst) &&
                expected_RegWrite === (expected_RegWrite ^ RegWrite ^ expected_RegWrite)) begin
                $display("PASS");
                $display("  Outputs: ALUOp=%h, ALUSrc=%b, Branch=%b, MemWrite=%b, MemtoReg=%b, RegDst=%b, RegWrite=%b",
                         ALUOp, ALUSrc, Branch, MemWrite, MemtoReg, RegDst, RegWrite);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ALUOp=%h, ALUSrc=%b, Branch=%b, MemWrite=%b, MemtoReg=%b, RegDst=%b, RegWrite=%b",
                         expected_ALUOp, expected_ALUSrc, expected_Branch, expected_MemWrite, expected_MemtoReg, expected_RegDst, expected_RegWrite);
                $display("  Got:      ALUOp=%h, ALUSrc=%b, Branch=%b, MemWrite=%b, MemtoReg=%b, RegDst=%b, RegWrite=%b",
                         ALUOp, ALUSrc, Branch, MemWrite, MemtoReg, RegDst, RegWrite);
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
