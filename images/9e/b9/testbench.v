`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [5:0] opcode;
    wire ALUop0;
    wire ALUop1;
    wire ALUsrcB;
    wire Branch;
    wire JMP;
    wire MemToReg;
    wire MemWrite;
    wire RegDst;
    wire WriteReg;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .opcode(opcode),
        .ALUop0(ALUop0),
        .ALUop1(ALUop1),
        .ALUsrcB(ALUsrcB),
        .Branch(Branch),
        .JMP(JMP),
        .MemToReg(MemToReg),
        .MemWrite(MemWrite),
        .RegDst(RegDst),
        .WriteReg(WriteReg)
    );
    task testcase001;

        begin
            $display("\nTest Case 001: R-type Instruction");
            opcode = 6'b000000;

            #1;


            check_outputs(1'b0, 1'b1, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b1, 1'b1);
        end
        endtask

    task testcase002;

        begin
            $display("\nTest Case 002: Load Word (LW) Instruction");
            opcode = 6'b100011;

            #1;


            check_outputs(1'b0, 1'b0, 1'b1, 1'b0, 1'b0, 1'b1, 1'b0, 1'b0, 1'b1);
        end
        endtask

    task testcase003;

        begin
            $display("\nTest Case 003: Store Word (SW) Instruction");
            opcode = 6'b101011;

            #1;


            check_outputs(1'b0, 1'b0, 1'b1, 1'b0, 1'b0, 1'b0, 1'b1, 1'b0, 1'b0);
        end
        endtask

    task testcase004;

        begin
            $display("\nTest Case 004: Branch Equal (BEQ) Instruction");
            opcode = 6'b000100;

            #1;


            check_outputs(1'b1, 1'b0, 1'b0, 1'b1, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0);
        end
        endtask

    task testcase005;

        begin
            $display("\nTest Case 005: Jump (J) Instruction");
            opcode = 6'b000010;

            #1;


            check_outputs(1'b0, 1'b0, 1'b0, 1'b0, 1'b1, 1'b0, 1'b0, 1'b0, 1'b0);
        end
        endtask

    task testcase006;

        begin
            $display("\nTest Case 006: Default/Unknown Instruction");
            opcode = 6'b111111;

            #1;


            check_outputs(1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0);
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
        input expected_ALUop0;
        input expected_ALUop1;
        input expected_ALUsrcB;
        input expected_Branch;
        input expected_JMP;
        input expected_MemToReg;
        input expected_MemWrite;
        input expected_RegDst;
        input expected_WriteReg;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_ALUop0 === (expected_ALUop0 ^ ALUop0 ^ expected_ALUop0) &&
                expected_ALUop1 === (expected_ALUop1 ^ ALUop1 ^ expected_ALUop1) &&
                expected_ALUsrcB === (expected_ALUsrcB ^ ALUsrcB ^ expected_ALUsrcB) &&
                expected_Branch === (expected_Branch ^ Branch ^ expected_Branch) &&
                expected_JMP === (expected_JMP ^ JMP ^ expected_JMP) &&
                expected_MemToReg === (expected_MemToReg ^ MemToReg ^ expected_MemToReg) &&
                expected_MemWrite === (expected_MemWrite ^ MemWrite ^ expected_MemWrite) &&
                expected_RegDst === (expected_RegDst ^ RegDst ^ expected_RegDst) &&
                expected_WriteReg === (expected_WriteReg ^ WriteReg ^ expected_WriteReg)) begin
                $display("PASS");
                $display("  Outputs: ALUop0=%b, ALUop1=%b, ALUsrcB=%b, Branch=%b, JMP=%b, MemToReg=%b, MemWrite=%b, RegDst=%b, WriteReg=%b",
                         ALUop0, ALUop1, ALUsrcB, Branch, JMP, MemToReg, MemWrite, RegDst, WriteReg);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ALUop0=%b, ALUop1=%b, ALUsrcB=%b, Branch=%b, JMP=%b, MemToReg=%b, MemWrite=%b, RegDst=%b, WriteReg=%b",
                         expected_ALUop0, expected_ALUop1, expected_ALUsrcB, expected_Branch, expected_JMP, expected_MemToReg, expected_MemWrite, expected_RegDst, expected_WriteReg);
                $display("  Got:      ALUop0=%b, ALUop1=%b, ALUsrcB=%b, Branch=%b, JMP=%b, MemToReg=%b, MemWrite=%b, RegDst=%b, WriteReg=%b",
                         ALUop0, ALUop1, ALUsrcB, Branch, JMP, MemToReg, MemWrite, RegDst, WriteReg);
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
