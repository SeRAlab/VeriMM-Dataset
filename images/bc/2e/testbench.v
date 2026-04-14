`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] instr;
    wire [4:0] ALUOp;
    wire ALUSrc;
    wire Branch;
    wire ExtOp;
    wire MemToReg;
    wire MemWr;
    wire RegDst;
    wire RegWr;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .instr(instr),
        .ALUOp(ALUOp),
        .ALUSrc(ALUSrc),
        .Branch(Branch),
        .ExtOp(ExtOp),
        .MemToReg(MemToReg),
        .MemWr(MemWr),
        .RegDst(RegDst),
        .RegWr(RegWr)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test Case 001: Instruction 0x00000000");
        instr = 32'h0000_0000;


        #1;



        check_outputs(5'h00, 1'b0, 1'b0, 1'b1, 1'b0, 1'b0, 1'b0, 1'b1);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case 002: Instruction with RegDst bit set (0x00100000)");
        instr = 32'h0010_0000;

        #1;


        check_outputs(5'h00, 1'b0, 1'b0, 1'b1, 1'b0, 1'b0, 1'b1, 1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test Case 003: Instruction with ALUOp bits set (0x00000015)");
        instr = 32'h0000_0015;

        #1;


        check_outputs(5'h15, 1'b0, 1'b0, 1'b1, 1'b0, 1'b0, 1'b0, 1'b1);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test Case 004: Instruction 0xFFFFFFFF");
        instr = 32'hFFFF_FFFF;

        #1;


        check_outputs(5'h1F, 1'b0, 1'b0, 1'b1, 1'b0, 1'b0, 1'b1, 1'b1);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test Case 005: Alternating bit pattern (0x55555555)");
        instr = 32'h5555_5555;

        #1;


        check_outputs(5'h15, 1'b0, 1'b0, 1'b1, 1'b0, 1'b0, 1'b1, 1'b1);
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
        input [4:0] expected_ALUOp;
        input expected_ALUSrc;
        input expected_Branch;
        input expected_ExtOp;
        input expected_MemToReg;
        input expected_MemWr;
        input expected_RegDst;
        input expected_RegWr;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_ALUOp === (expected_ALUOp ^ ALUOp ^ expected_ALUOp) &&
                expected_ALUSrc === (expected_ALUSrc ^ ALUSrc ^ expected_ALUSrc) &&
                expected_Branch === (expected_Branch ^ Branch ^ expected_Branch) &&
                expected_ExtOp === (expected_ExtOp ^ ExtOp ^ expected_ExtOp) &&
                expected_MemToReg === (expected_MemToReg ^ MemToReg ^ expected_MemToReg) &&
                expected_MemWr === (expected_MemWr ^ MemWr ^ expected_MemWr) &&
                expected_RegDst === (expected_RegDst ^ RegDst ^ expected_RegDst) &&
                expected_RegWr === (expected_RegWr ^ RegWr ^ expected_RegWr)) begin
                $display("PASS");
                $display("  Outputs: ALUOp=%h, ALUSrc=%b, Branch=%b, ExtOp=%b, MemToReg=%b, MemWr=%b, RegDst=%b, RegWr=%b",
                         ALUOp, ALUSrc, Branch, ExtOp, MemToReg, MemWr, RegDst, RegWr);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ALUOp=%h, ALUSrc=%b, Branch=%b, ExtOp=%b, MemToReg=%b, MemWr=%b, RegDst=%b, RegWr=%b",
                         expected_ALUOp, expected_ALUSrc, expected_Branch, expected_ExtOp, expected_MemToReg, expected_MemWr, expected_RegDst, expected_RegWr);
                $display("  Got:      ALUOp=%h, ALUSrc=%b, Branch=%b, ExtOp=%b, MemToReg=%b, MemWr=%b, RegDst=%b, RegWr=%b",
                         ALUOp, ALUSrc, Branch, ExtOp, MemToReg, MemWr, RegDst, RegWr);
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
