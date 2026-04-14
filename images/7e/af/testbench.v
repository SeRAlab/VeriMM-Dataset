`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [5:0] Op;
    wire ALUOp1;
    wire ALUOp2;
    wire ALUSrc;
    wire Branch;
    wire MemRead;
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
        .Op(Op),
        .ALUOp1(ALUOp1),
        .ALUOp2(ALUOp2),
        .ALUSrc(ALUSrc),
        .Branch(Branch),
        .MemRead(MemRead),
        .MemWrite(MemWrite),
        .MemtoReg(MemtoReg),
        .RegDst(RegDst),
        .RegWrite(RegWrite)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Test %0d: R-format instruction (Op = 6'b000000)", test_num);
        Op = 6'b000000;


        #1;



        check_outputs(1, 0, 0, 0, 0, 0, 0, 1, 1);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test %0d: Load Word (lw) instruction (Op = 6'b100011)", test_num);
        Op = 6'b100011;


        #1;



        check_outputs(0, 0, 1, 0, 1, 0, 1, 0, 1);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test %0d: Store Word (sw) instruction (Op = 6'b101011)", test_num);
        Op = 6'b101011;


        #1;



        check_outputs(0, 0, 1, 0, 0, 1, 0, 0, 0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test %0d: Branch Equal (beq) instruction (Op = 6'b000100)", test_num);
        Op = 6'b000100;


        #1;



        check_outputs(0, 1, 0, 1, 0, 0, 0, 0, 0);
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
        input expected_ALUOp1;
        input expected_ALUOp2;
        input expected_ALUSrc;
        input expected_Branch;
        input expected_MemRead;
        input expected_MemWrite;
        input expected_MemtoReg;
        input expected_RegDst;
        input expected_RegWrite;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_ALUOp1 === (expected_ALUOp1 ^ ALUOp1 ^ expected_ALUOp1) &&
                expected_ALUOp2 === (expected_ALUOp2 ^ ALUOp2 ^ expected_ALUOp2) &&
                expected_ALUSrc === (expected_ALUSrc ^ ALUSrc ^ expected_ALUSrc) &&
                expected_Branch === (expected_Branch ^ Branch ^ expected_Branch) &&
                expected_MemRead === (expected_MemRead ^ MemRead ^ expected_MemRead) &&
                expected_MemWrite === (expected_MemWrite ^ MemWrite ^ expected_MemWrite) &&
                expected_MemtoReg === (expected_MemtoReg ^ MemtoReg ^ expected_MemtoReg) &&
                expected_RegDst === (expected_RegDst ^ RegDst ^ expected_RegDst) &&
                expected_RegWrite === (expected_RegWrite ^ RegWrite ^ expected_RegWrite)) begin
                $display("PASS");
                $display("  Outputs: ALUOp1=%b, ALUOp2=%b, ALUSrc=%b, Branch=%b, MemRead=%b, MemWrite=%b, MemtoReg=%b, RegDst=%b, RegWrite=%b",
                         ALUOp1, ALUOp2, ALUSrc, Branch, MemRead, MemWrite, MemtoReg, RegDst, RegWrite);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ALUOp1=%b, ALUOp2=%b, ALUSrc=%b, Branch=%b, MemRead=%b, MemWrite=%b, MemtoReg=%b, RegDst=%b, RegWrite=%b",
                         expected_ALUOp1, expected_ALUOp2, expected_ALUSrc, expected_Branch, expected_MemRead, expected_MemWrite, expected_MemtoReg, expected_RegDst, expected_RegWrite);
                $display("  Got:      ALUOp1=%b, ALUOp2=%b, ALUSrc=%b, Branch=%b, MemRead=%b, MemWrite=%b, MemtoReg=%b, RegDst=%b, RegWrite=%b",
                         ALUOp1, ALUOp2, ALUSrc, Branch, MemRead, MemWrite, MemtoReg, RegDst, RegWrite);
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
