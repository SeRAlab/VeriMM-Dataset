`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] instr;
    wire ALUSrc;
    wire MemToReg;
    wire MemWrite;
    wire RegDst;
    wire RegWrite;
    wire branch;
    wire jump;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .instr(instr),
        .ALUSrc(ALUSrc),
        .MemToReg(MemToReg),
        .MemWrite(MemWrite),
        .RegDst(RegDst),
        .RegWrite(RegWrite),
        .branch(branch),
        .jump(jump)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: R-type Instruction", test_num);
            instr = 32'b000000_00001_00010_00011_00000_100000;

            #1;


            check_outputs(0, 0, 0, 1, 1, 0, 0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: LW Instruction", test_num);
            instr = 32'b100011_00001_00010_0000000000000100;

            #1;


            check_outputs(1, 1, 0, 0, 1, 0, 0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: SW Instruction", test_num);
            instr = 32'b101011_00001_00010_0000000000000100;

            #1;


            check_outputs(1, 0, 1, 0, 0, 0, 0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: BEQ Instruction", test_num);
            instr = 32'b000100_00001_00010_0000000000000100;

            #1;


            check_outputs(0, 0, 0, 0, 0, 1, 0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Jump Instruction", test_num);
            instr = 32'b000010_00000000000000000000001111;

            #1;


            check_outputs(0, 0, 0, 0, 0, 0, 1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: ADDI Instruction", test_num);
            instr = 32'b001000_00001_00010_0000000000000101;

            #1;


            check_outputs(1, 0, 0, 0, 1, 0, 0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Unknown Opcode", test_num);
            instr = 32'b111111_00000000000000000000000000;

            #1;


            check_outputs(0, 0, 0, 0, 0, 0, 0);
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
        input expected_ALUSrc;
        input expected_MemToReg;
        input expected_MemWrite;
        input expected_RegDst;
        input expected_RegWrite;
        input expected_branch;
        input expected_jump;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_ALUSrc === (expected_ALUSrc ^ ALUSrc ^ expected_ALUSrc) &&
                expected_MemToReg === (expected_MemToReg ^ MemToReg ^ expected_MemToReg) &&
                expected_MemWrite === (expected_MemWrite ^ MemWrite ^ expected_MemWrite) &&
                expected_RegDst === (expected_RegDst ^ RegDst ^ expected_RegDst) &&
                expected_RegWrite === (expected_RegWrite ^ RegWrite ^ expected_RegWrite) &&
                expected_branch === (expected_branch ^ branch ^ expected_branch) &&
                expected_jump === (expected_jump ^ jump ^ expected_jump)) begin
                $display("PASS");
                $display("  Outputs: ALUSrc=%b, MemToReg=%b, MemWrite=%b, RegDst=%b, RegWrite=%b, branch=%b, jump=%b",
                         ALUSrc, MemToReg, MemWrite, RegDst, RegWrite, branch, jump);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ALUSrc=%b, MemToReg=%b, MemWrite=%b, RegDst=%b, RegWrite=%b, branch=%b, jump=%b",
                         expected_ALUSrc, expected_MemToReg, expected_MemWrite, expected_RegDst, expected_RegWrite, expected_branch, expected_jump);
                $display("  Got:      ALUSrc=%b, MemToReg=%b, MemWrite=%b, RegDst=%b, RegWrite=%b, branch=%b, jump=%b",
                         ALUSrc, MemToReg, MemWrite, RegDst, RegWrite, branch, jump);
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
