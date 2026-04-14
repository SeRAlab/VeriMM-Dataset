`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [5:0] op;
    wire ALUSrc;
    wire [1:0] ALUctr;
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
        .op(op),
        .ALUSrc(ALUSrc),
        .ALUctr(ALUctr),
        .Branch(Branch),
        .MemRead(MemRead),
        .MemWrite(MemWrite),
        .MemtoReg(MemtoReg),
        .RegDst(RegDst),
        .RegWrite(RegWrite)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: R-type Instruction (op=6'b000000)", test_num);
            op = 6'b000000;

            #1;


            check_outputs(1'b0, 2'b10, 1'b0, 1'b0, 1'b0, 1'b0, 1'b1, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Load Word (lw) Instruction (op=6'b100011)", test_num);
            op = 6'b100011;

            #1;


            check_outputs(1'b1, 2'b00, 1'b0, 1'b1, 1'b0, 1'b1, 1'b0, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Store Word (sw) Instruction (op=6'b101011)", test_num);
            op = 6'b101011;

            #1;


            check_outputs(1'b1, 2'b00, 1'b0, 1'b0, 1'b1, 1'b0, 1'b0, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Branch Equal (beq) Instruction (op=6'b000100)", test_num);
            op = 6'b000100;

            #1;


            check_outputs(1'b0, 2'b01, 1'b1, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Load Upper Immediate (lui) Instruction (op=6'b001111)", test_num);
            op = 6'b001111;

            #1;


            check_outputs(1'b1, 2'b11, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Undefined Instruction (op=6'b111111)", test_num);
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
        input expected_ALUSrc;
        input [1:0] expected_ALUctr;
        input expected_Branch;
        input expected_MemRead;
        input expected_MemWrite;
        input expected_MemtoReg;
        input expected_RegDst;
        input expected_RegWrite;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_ALUSrc === (expected_ALUSrc ^ ALUSrc ^ expected_ALUSrc) &&
                expected_ALUctr === (expected_ALUctr ^ ALUctr ^ expected_ALUctr) &&
                expected_Branch === (expected_Branch ^ Branch ^ expected_Branch) &&
                expected_MemRead === (expected_MemRead ^ MemRead ^ expected_MemRead) &&
                expected_MemWrite === (expected_MemWrite ^ MemWrite ^ expected_MemWrite) &&
                expected_MemtoReg === (expected_MemtoReg ^ MemtoReg ^ expected_MemtoReg) &&
                expected_RegDst === (expected_RegDst ^ RegDst ^ expected_RegDst) &&
                expected_RegWrite === (expected_RegWrite ^ RegWrite ^ expected_RegWrite)) begin
                $display("PASS");
                $display("  Outputs: ALUSrc=%b, ALUctr=%h, Branch=%b, MemRead=%b, MemWrite=%b, MemtoReg=%b, RegDst=%b, RegWrite=%b",
                         ALUSrc, ALUctr, Branch, MemRead, MemWrite, MemtoReg, RegDst, RegWrite);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ALUSrc=%b, ALUctr=%h, Branch=%b, MemRead=%b, MemWrite=%b, MemtoReg=%b, RegDst=%b, RegWrite=%b",
                         expected_ALUSrc, expected_ALUctr, expected_Branch, expected_MemRead, expected_MemWrite, expected_MemtoReg, expected_RegDst, expected_RegWrite);
                $display("  Got:      ALUSrc=%b, ALUctr=%h, Branch=%b, MemRead=%b, MemWrite=%b, MemtoReg=%b, RegDst=%b, RegWrite=%b",
                         ALUSrc, ALUctr, Branch, MemRead, MemWrite, MemtoReg, RegDst, RegWrite);
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
