`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [5:0] op;
    wire aluSrc;
    wire [1:0] alu_op;
    wire branch;
    wire memRead;
    wire memToReg;
    wire memWrite;
    wire regDst;
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
        .memRead(memRead),
        .memToReg(memToReg),
        .memWrite(memWrite),
        .regDst(regDst),
        .regWrite(regWrite)
    );
    task testcase001;

        begin
            $display("\nTest 001: R-type instruction (op=000000)");
            op = 6'b000000;

            #1;


            check_outputs(1'b0, 2'b10, 1'b0, 1'b0, 1'b0, 1'b0, 1'b1, 1'b1);
        end
        endtask

    task testcase002;

        begin
            $display("\nTest 002: LW instruction (op=100011)");
            op = 6'b100011;
            #1;

            check_outputs(1'b1, 2'b00, 1'b0, 1'b1, 1'b1, 1'b0, 1'b0, 1'b1);
        end
        endtask

    task testcase003;

        begin
            $display("\nTest 003: SW instruction (op=101011)");
            op = 6'b101011;
            #1;

            check_outputs(1'b1, 2'b00, 1'b0, 1'b0, 1'b0, 1'b1, 1'b0, 1'b0);
        end
        endtask

    task testcase004;

        begin
            $display("\nTest 004: BEQ instruction (op=000100)");
            op = 6'b000100;
            #1;

            check_outputs(1'b0, 2'b01, 1'b1, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0);
        end
        endtask

    task testcase005;

        begin
            $display("\nTest 005: ADDI instruction (op=001000)");
            op = 6'b001000;
            #1;

            check_outputs(1'b1, 2'b00, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b1);
        end
        endtask

    task testcase006;

        begin
            $display("\nTest 006: Undefined instruction (op=111111)");
            op = 6'b111111;
            #1;

            check_outputs(1'b0, 2'b00, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0);
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
        input expected_aluSrc;
        input [1:0] expected_alu_op;
        input expected_branch;
        input expected_memRead;
        input expected_memToReg;
        input expected_memWrite;
        input expected_regDst;
        input expected_regWrite;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_aluSrc === (expected_aluSrc ^ aluSrc ^ expected_aluSrc) &&
                expected_alu_op === (expected_alu_op ^ alu_op ^ expected_alu_op) &&
                expected_branch === (expected_branch ^ branch ^ expected_branch) &&
                expected_memRead === (expected_memRead ^ memRead ^ expected_memRead) &&
                expected_memToReg === (expected_memToReg ^ memToReg ^ expected_memToReg) &&
                expected_memWrite === (expected_memWrite ^ memWrite ^ expected_memWrite) &&
                expected_regDst === (expected_regDst ^ regDst ^ expected_regDst) &&
                expected_regWrite === (expected_regWrite ^ regWrite ^ expected_regWrite)) begin
                $display("PASS");
                $display("  Outputs: aluSrc=%b, alu_op=%h, branch=%b, memRead=%b, memToReg=%b, memWrite=%b, regDst=%b, regWrite=%b",
                         aluSrc, alu_op, branch, memRead, memToReg, memWrite, regDst, regWrite);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: aluSrc=%b, alu_op=%h, branch=%b, memRead=%b, memToReg=%b, memWrite=%b, regDst=%b, regWrite=%b",
                         expected_aluSrc, expected_alu_op, expected_branch, expected_memRead, expected_memToReg, expected_memWrite, expected_regDst, expected_regWrite);
                $display("  Got:      aluSrc=%b, alu_op=%h, branch=%b, memRead=%b, memToReg=%b, memWrite=%b, regDst=%b, regWrite=%b",
                         aluSrc, alu_op, branch, memRead, memToReg, memWrite, regDst, regWrite);
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
