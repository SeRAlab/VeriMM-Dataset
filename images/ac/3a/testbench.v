`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [5:0] instr_op_i;
    wire ALUSrc_o;
    wire [2:0] ALU_op_o;
    wire Branch_o;
    wire RegDst_o;
    wire RegWrite_o;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .instr_op_i(instr_op_i),
        .ALUSrc_o(ALUSrc_o),
        .ALU_op_o(ALU_op_o),
        .Branch_o(Branch_o),
        .RegDst_o(RegDst_o),
        .RegWrite_o(RegWrite_o)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: R-type Instruction", test_num);
            instr_op_i = 6'b000000;

            #1;


            check_outputs(1'b0, 3'b010, 1'b0, 1'b1, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: beq Instruction", test_num);
            instr_op_i = 6'b000100;
            #1;

            check_outputs(1'b0, 3'b001, 1'b1, 1'b0, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: addi Instruction", test_num);
            instr_op_i = 6'b001000;
            #1;

            check_outputs(1'b1, 3'b000, 1'b0, 1'b0, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: slti Instruction", test_num);
            instr_op_i = 6'b001010;
            #1;

            check_outputs(1'b1, 3'b011, 1'b0, 1'b0, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Undefined Opcode", test_num);
            instr_op_i = 6'b111111;
            #1;

            check_outputs(1'b0, 3'b000, 1'b0, 1'b0, 1'b0);
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
        input expected_ALUSrc_o;
        input [2:0] expected_ALU_op_o;
        input expected_Branch_o;
        input expected_RegDst_o;
        input expected_RegWrite_o;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_ALUSrc_o === (expected_ALUSrc_o ^ ALUSrc_o ^ expected_ALUSrc_o) &&
                expected_ALU_op_o === (expected_ALU_op_o ^ ALU_op_o ^ expected_ALU_op_o) &&
                expected_Branch_o === (expected_Branch_o ^ Branch_o ^ expected_Branch_o) &&
                expected_RegDst_o === (expected_RegDst_o ^ RegDst_o ^ expected_RegDst_o) &&
                expected_RegWrite_o === (expected_RegWrite_o ^ RegWrite_o ^ expected_RegWrite_o)) begin
                $display("PASS");
                $display("  Outputs: ALUSrc_o=%b, ALU_op_o=%h, Branch_o=%b, RegDst_o=%b, RegWrite_o=%b",
                         ALUSrc_o, ALU_op_o, Branch_o, RegDst_o, RegWrite_o);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ALUSrc_o=%b, ALU_op_o=%h, Branch_o=%b, RegDst_o=%b, RegWrite_o=%b",
                         expected_ALUSrc_o, expected_ALU_op_o, expected_Branch_o, expected_RegDst_o, expected_RegWrite_o);
                $display("  Got:      ALUSrc_o=%b, ALU_op_o=%h, Branch_o=%b, RegDst_o=%b, RegWrite_o=%b",
                         ALUSrc_o, ALU_op_o, Branch_o, RegDst_o, RegWrite_o);
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
