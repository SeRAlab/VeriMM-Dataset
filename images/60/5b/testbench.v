`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [5:0] op;
    wire aluSrc;
    wire [2:0] alu_op;
    wire branch;
    wire branch_ne;
    wire jump;
    wire memRead;
    wire memToReg0;
    wire memToReg1;
    wire memWrite;
    wire regDst0;
    wire regDst1;
    wire regWrite;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .op(op),
        .aluSrc(aluSrc),
        .alu_op(alu_op),
        .branch(branch),
        .branch_ne(branch_ne),
        .jump(jump),
        .memRead(memRead),
        .memToReg0(memToReg0),
        .memToReg1(memToReg1),
        .memWrite(memWrite),
        .regDst0(regDst0),
        .regDst1(regDst1),
        .regWrite(regWrite)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("\nTestcase %0d: R-type Instruction", test_num);
        op = 6'b000000;

        #1;


        check_outputs(0, 3'b010, 0, 0, 0, 0, 0, 0, 0, 1, 0, 1);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("\nTestcase %0d: Load Word (lw)", test_num);
        op = 6'b100011;
        #1;

        check_outputs(1, 3'b000, 0, 0, 0, 1, 1, 0, 0, 0, 0, 1);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("\nTestcase %0d: Store Word (sw)", test_num);
        op = 6'b101011;
        #1;

        check_outputs(1, 3'b000, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("\nTestcase %0d: Branch Equal (beq)", test_num);
        op = 6'b000100;
        #1;

        check_outputs(0, 3'b001, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("\nTestcase %0d: Branch Not Equal (bne)", test_num);
        op = 6'b000101;
        #1;

        check_outputs(0, 3'b001, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("\nTestcase %0d: Add Immediate (addi)", test_num);
        op = 6'b001000;
        #1;

        check_outputs(1, 3'b000, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("\nTestcase %0d: Jump (j)", test_num);
        op = 6'b000010;
        #1;

        check_outputs(0, 3'b000, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("\nTestcase %0d: Jump and Link (jal)", test_num);
        op = 6'b000011;
        #1;

        check_outputs(0, 3'b000, 0, 0, 1, 0, 0, 1, 0, 0, 1, 1);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        $display("\nTestcase %0d: Undefined Opcode", test_num);
        op = 6'b111111;
        #1;

        check_outputs(0, 3'b000, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);
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
        testcase008();
        testcase009();
        
        
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
        input expected_aluSrc;
        input [2:0] expected_alu_op;
        input expected_branch;
        input expected_branch_ne;
        input expected_jump;
        input expected_memRead;
        input expected_memToReg0;
        input expected_memToReg1;
        input expected_memWrite;
        input expected_regDst0;
        input expected_regDst1;
        input expected_regWrite;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_aluSrc === (expected_aluSrc ^ aluSrc ^ expected_aluSrc) &&
                expected_alu_op === (expected_alu_op ^ alu_op ^ expected_alu_op) &&
                expected_branch === (expected_branch ^ branch ^ expected_branch) &&
                expected_branch_ne === (expected_branch_ne ^ branch_ne ^ expected_branch_ne) &&
                expected_jump === (expected_jump ^ jump ^ expected_jump) &&
                expected_memRead === (expected_memRead ^ memRead ^ expected_memRead) &&
                expected_memToReg0 === (expected_memToReg0 ^ memToReg0 ^ expected_memToReg0) &&
                expected_memToReg1 === (expected_memToReg1 ^ memToReg1 ^ expected_memToReg1) &&
                expected_memWrite === (expected_memWrite ^ memWrite ^ expected_memWrite) &&
                expected_regDst0 === (expected_regDst0 ^ regDst0 ^ expected_regDst0) &&
                expected_regDst1 === (expected_regDst1 ^ regDst1 ^ expected_regDst1) &&
                expected_regWrite === (expected_regWrite ^ regWrite ^ expected_regWrite)) begin
                $display("PASS");
                $display("  Outputs: aluSrc=%b, alu_op=%h, branch=%b, branch_ne=%b, jump=%b, memRead=%b, memToReg0=%b, memToReg1=%b, memWrite=%b, regDst0=%b, regDst1=%b, regWrite=%b",
                         aluSrc, alu_op, branch, branch_ne, jump, memRead, memToReg0, memToReg1, memWrite, regDst0, regDst1, regWrite);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: aluSrc=%b, alu_op=%h, branch=%b, branch_ne=%b, jump=%b, memRead=%b, memToReg0=%b, memToReg1=%b, memWrite=%b, regDst0=%b, regDst1=%b, regWrite=%b",
                         expected_aluSrc, expected_alu_op, expected_branch, expected_branch_ne, expected_jump, expected_memRead, expected_memToReg0, expected_memToReg1, expected_memWrite, expected_regDst0, expected_regDst1, expected_regWrite);
                $display("  Got:      aluSrc=%b, alu_op=%h, branch=%b, branch_ne=%b, jump=%b, memRead=%b, memToReg0=%b, memToReg1=%b, memWrite=%b, regDst0=%b, regDst1=%b, regWrite=%b",
                         aluSrc, alu_op, branch, branch_ne, jump, memRead, memToReg0, memToReg1, memWrite, regDst0, regDst1, regWrite);
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
