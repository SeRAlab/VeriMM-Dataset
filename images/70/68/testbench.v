`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [5:0] Op_i;
    wire [1:0] ALUOp_o;
    wire ALUSrc_o;
    wire Branch_o;
    wire Jump_o;
    wire MemRead_o;
    wire MemWrite_o;
    wire MemtoReg_o;
    wire RegDst_o;
    wire RegWrite_o;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .Op_i(Op_i),
        .ALUOp_o(ALUOp_o),
        .ALUSrc_o(ALUSrc_o),
        .Branch_o(Branch_o),
        .Jump_o(Jump_o),
        .MemRead_o(MemRead_o),
        .MemWrite_o(MemWrite_o),
        .MemtoReg_o(MemtoReg_o),
        .RegDst_o(RegDst_o),
        .RegWrite_o(RegWrite_o)
    );
    task testcase001;

        begin
            $display("Running Testcase 001: R-type Instruction");
            Op_i = 6'b000000;

            #1;


            check_outputs(2'b10, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b1, 1'b1);
        end
        endtask

    task testcase002;

        begin
            $display("Running Testcase 002: Load Word (LW)");
            Op_i = 6'b100011;

            #1;


            check_outputs(2'b00, 1'b1, 1'b0, 1'b0, 1'b1, 1'b0, 1'b1, 1'b0, 1'b1);
        end
        endtask

    task testcase003;

        begin
            $display("Running Testcase 003: Store Word (SW)");
            Op_i = 6'b101011;

            #1;


            check_outputs(2'b00, 1'b1, 1'b0, 1'b0, 1'b0, 1'b1, 1'b0, 1'b0, 1'b0);
        end
        endtask

    task testcase004;

        begin
            $display("Running Testcase 004: Branch Equal (BEQ)");
            Op_i = 6'b000100;

            #1;


            check_outputs(2'b01, 1'b0, 1'b1, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0);
        end
        endtask

    task testcase005;

        begin
            $display("Running Testcase 005: Jump (J)");
            Op_i = 6'b000010;

            #1;


            check_outputs(2'b00, 1'b0, 1'b0, 1'b1, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0);
        end
        endtask

    task testcase006;

        begin
            $display("Running Testcase 006: Add Immediate (ADDI)");
            Op_i = 6'b001000;

            #1;


            check_outputs(2'b00, 1'b1, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b1);
        end
        endtask

    task testcase007;

        begin
            $display("Running Testcase 007: Undefined Opcode");
            Op_i = 6'b111111;

            #1;


            check_outputs(2'b00, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0);
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
        input [1:0] expected_ALUOp_o;
        input expected_ALUSrc_o;
        input expected_Branch_o;
        input expected_Jump_o;
        input expected_MemRead_o;
        input expected_MemWrite_o;
        input expected_MemtoReg_o;
        input expected_RegDst_o;
        input expected_RegWrite_o;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_ALUOp_o === (expected_ALUOp_o ^ ALUOp_o ^ expected_ALUOp_o) &&
                expected_ALUSrc_o === (expected_ALUSrc_o ^ ALUSrc_o ^ expected_ALUSrc_o) &&
                expected_Branch_o === (expected_Branch_o ^ Branch_o ^ expected_Branch_o) &&
                expected_Jump_o === (expected_Jump_o ^ Jump_o ^ expected_Jump_o) &&
                expected_MemRead_o === (expected_MemRead_o ^ MemRead_o ^ expected_MemRead_o) &&
                expected_MemWrite_o === (expected_MemWrite_o ^ MemWrite_o ^ expected_MemWrite_o) &&
                expected_MemtoReg_o === (expected_MemtoReg_o ^ MemtoReg_o ^ expected_MemtoReg_o) &&
                expected_RegDst_o === (expected_RegDst_o ^ RegDst_o ^ expected_RegDst_o) &&
                expected_RegWrite_o === (expected_RegWrite_o ^ RegWrite_o ^ expected_RegWrite_o)) begin
                $display("PASS");
                $display("  Outputs: ALUOp_o=%h, ALUSrc_o=%b, Branch_o=%b, Jump_o=%b, MemRead_o=%b, MemWrite_o=%b, MemtoReg_o=%b, RegDst_o=%b, RegWrite_o=%b",
                         ALUOp_o, ALUSrc_o, Branch_o, Jump_o, MemRead_o, MemWrite_o, MemtoReg_o, RegDst_o, RegWrite_o);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ALUOp_o=%h, ALUSrc_o=%b, Branch_o=%b, Jump_o=%b, MemRead_o=%b, MemWrite_o=%b, MemtoReg_o=%b, RegDst_o=%b, RegWrite_o=%b",
                         expected_ALUOp_o, expected_ALUSrc_o, expected_Branch_o, expected_Jump_o, expected_MemRead_o, expected_MemWrite_o, expected_MemtoReg_o, expected_RegDst_o, expected_RegWrite_o);
                $display("  Got:      ALUOp_o=%h, ALUSrc_o=%b, Branch_o=%b, Jump_o=%b, MemRead_o=%b, MemWrite_o=%b, MemtoReg_o=%b, RegDst_o=%b, RegWrite_o=%b",
                         ALUOp_o, ALUSrc_o, Branch_o, Jump_o, MemRead_o, MemWrite_o, MemtoReg_o, RegDst_o, RegWrite_o);
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
