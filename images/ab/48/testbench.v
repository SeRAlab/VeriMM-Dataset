`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [5:0] Funct;
    reg [5:0] OpCode;
    wire [3:0] ALUOp;
    wire ALUSrc1;
    wire ALUSrc2;
    wire Branch;
    wire ExtOp;
    wire LuOp;
    wire MemRead;
    wire MemWrite;
    wire [1:0] MemtoReg;
    wire [1:0] PCSrc;
    wire [1:0] RegDst;
    wire RegWrite;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .Funct(Funct),
        .OpCode(OpCode),
        .ALUOp(ALUOp),
        .ALUSrc1(ALUSrc1),
        .ALUSrc2(ALUSrc2),
        .Branch(Branch),
        .ExtOp(ExtOp),
        .LuOp(LuOp),
        .MemRead(MemRead),
        .MemWrite(MemWrite),
        .MemtoReg(MemtoReg),
        .PCSrc(PCSrc),
        .RegDst(RegDst),
        .RegWrite(RegWrite)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: R-type Instruction (ADD)", test_num);
            OpCode = 6'b000000;
            Funct = 6'b100000;
            #1;

            check_outputs(4'b1000, 1'b0, 1'b0, 1'b0, 1'bx, 1'b0, 1'b0, 1'b0, 2'b00, 2'b00, 2'b01, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Load Word (LW)", test_num);
            OpCode = 6'b100011;
            Funct = 6'bxxxxxx;
            #1;

            check_outputs(4'b0000, 1'b0, 1'b1, 1'b0, 1'b1, 1'b0, 1'b1, 1'b0, 2'b01, 2'b00, 2'b00, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Store Word (SW)", test_num);
            OpCode = 6'b101011;
            Funct = 6'bxxxxxx;
            #1;

            check_outputs(4'b0000, 1'b0, 1'b1, 1'b0, 1'b1, 1'b0, 1'b0, 1'b1, 2'bxx, 2'b00, 2'bxx, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Branch If Equal (BEQ)", test_num);
            OpCode = 6'b000100;
            Funct = 6'bxxxxxx;
            #1;

            check_outputs(4'b0001, 1'b0, 1'b0, 1'b1, 1'b1, 1'b0, 1'b0, 1'b0, 2'bxx, 2'b01, 2'bxx, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Jump (J)", test_num);
            OpCode = 6'b000010;
            Funct = 6'bxxxxxx;
            #1;

            check_outputs(4'bxxxx, 1'bx, 1'bx, 1'b0, 1'bx, 1'b0, 1'b0, 1'b0, 2'bxx, 2'b10, 2'bxx, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Add Immediate (ADDI)", test_num);
            OpCode = 6'b001000;
            Funct = 6'bxxxxxx;
            #1;

            check_outputs(4'b0000, 1'b0, 1'b1, 1'b0, 1'b1, 1'b0, 1'b0, 1'b0, 2'b00, 2'b00, 2'b00, 1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Load Upper Immediate (LUI)", test_num);
            OpCode = 6'b001111;
            Funct = 6'bxxxxxx;
            #1;

            check_outputs(4'bxxxx, 1'bx, 1'b1, 1'b0, 1'bx, 1'b1, 1'b0, 1'b0, 2'b00, 2'b00, 2'b00, 1'b1);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Jump and Link (JAL)", test_num);
            OpCode = 6'b000011;
            Funct = 6'bxxxxxx;
            #1;

            check_outputs(4'bxxxx, 1'bx, 1'bx, 1'b0, 1'bx, 1'b0, 1'b0, 1'b0, 2'b10, 2'b10, 2'b10, 1'b1);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: ORI Instruction", test_num);
            OpCode = 6'b001101;
            Funct = 6'bxxxxxx;
            #1;

            check_outputs(4'b0011, 1'b0, 1'b1, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 2'b00, 2'b00, 2'b00, 1'b1);
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
        input [3:0] expected_ALUOp;
        input expected_ALUSrc1;
        input expected_ALUSrc2;
        input expected_Branch;
        input expected_ExtOp;
        input expected_LuOp;
        input expected_MemRead;
        input expected_MemWrite;
        input [1:0] expected_MemtoReg;
        input [1:0] expected_PCSrc;
        input [1:0] expected_RegDst;
        input expected_RegWrite;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_ALUOp === (expected_ALUOp ^ ALUOp ^ expected_ALUOp) &&
                expected_ALUSrc1 === (expected_ALUSrc1 ^ ALUSrc1 ^ expected_ALUSrc1) &&
                expected_ALUSrc2 === (expected_ALUSrc2 ^ ALUSrc2 ^ expected_ALUSrc2) &&
                expected_Branch === (expected_Branch ^ Branch ^ expected_Branch) &&
                expected_ExtOp === (expected_ExtOp ^ ExtOp ^ expected_ExtOp) &&
                expected_LuOp === (expected_LuOp ^ LuOp ^ expected_LuOp) &&
                expected_MemRead === (expected_MemRead ^ MemRead ^ expected_MemRead) &&
                expected_MemWrite === (expected_MemWrite ^ MemWrite ^ expected_MemWrite) &&
                expected_MemtoReg === (expected_MemtoReg ^ MemtoReg ^ expected_MemtoReg) &&
                expected_PCSrc === (expected_PCSrc ^ PCSrc ^ expected_PCSrc) &&
                expected_RegDst === (expected_RegDst ^ RegDst ^ expected_RegDst) &&
                expected_RegWrite === (expected_RegWrite ^ RegWrite ^ expected_RegWrite)) begin
                $display("PASS");
                $display("  Outputs: ALUOp=%h, ALUSrc1=%b, ALUSrc2=%b, Branch=%b, ExtOp=%b, LuOp=%b, MemRead=%b, MemWrite=%b, MemtoReg=%h, PCSrc=%h, RegDst=%h, RegWrite=%b",
                         ALUOp, ALUSrc1, ALUSrc2, Branch, ExtOp, LuOp, MemRead, MemWrite, MemtoReg, PCSrc, RegDst, RegWrite);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ALUOp=%h, ALUSrc1=%b, ALUSrc2=%b, Branch=%b, ExtOp=%b, LuOp=%b, MemRead=%b, MemWrite=%b, MemtoReg=%h, PCSrc=%h, RegDst=%h, RegWrite=%b",
                         expected_ALUOp, expected_ALUSrc1, expected_ALUSrc2, expected_Branch, expected_ExtOp, expected_LuOp, expected_MemRead, expected_MemWrite, expected_MemtoReg, expected_PCSrc, expected_RegDst, expected_RegWrite);
                $display("  Got:      ALUOp=%h, ALUSrc1=%b, ALUSrc2=%b, Branch=%b, ExtOp=%b, LuOp=%b, MemRead=%b, MemWrite=%b, MemtoReg=%h, PCSrc=%h, RegDst=%h, RegWrite=%b",
                         ALUOp, ALUSrc1, ALUSrc2, Branch, ExtOp, LuOp, MemRead, MemWrite, MemtoReg, PCSrc, RegDst, RegWrite);
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
