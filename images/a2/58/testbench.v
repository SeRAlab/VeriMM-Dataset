`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [5:0] op;
    wire [1:0] aluop;
    wire aluscr;
    wire branch;
    wire jump;
    wire memread;
    wire [1:0] memtoreg;
    wire memwrite;
    wire [1:0] regdst;
    wire regwrite;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .op(op),
        .aluop(aluop),
        .aluscr(aluscr),
        .branch(branch),
        .jump(jump),
        .memread(memread),
        .memtoreg(memtoreg),
        .memwrite(memwrite),
        .regdst(regdst),
        .regwrite(regwrite)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test %0d: R-Type Instruction (op=000000)", test_num);
            op = 6'b000000;

            #1;


            check_outputs(2'b10, 1'b0, 1'b0, 1'b0, 1'b0, 2'b00, 1'b0, 2'b01, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test %0d: Load Word Instruction (op=100011)", test_num);
            op = 6'b100011;
            #1;

            check_outputs(2'b00, 1'b1, 1'b0, 1'b0, 1'b1, 2'b01, 1'b0, 2'b00, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test %0d: Store Word Instruction (op=101011)", test_num);
            op = 6'b101011;

            #1;


            check_outputs(2'b00, 1'b1, 1'b0, 1'b0, 1'b0, 2'b00, 1'b1, 2'b00, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test %0d: Branch Equal Instruction (op=000100)", test_num);
            op = 6'b000100;
            #1;

            check_outputs(2'b01, 1'b0, 1'b1, 1'b0, 1'b0, 2'b00, 1'b0, 2'b00, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test %0d: Jump Instruction (op=000010)", test_num);
            op = 6'b000010;
            #1;

            check_outputs(2'b00, 1'b0, 1'b0, 1'b1, 1'b0, 2'b00, 1'b0, 2'b00, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test %0d: Add Immediate Instruction (op=001000)", test_num);
            op = 6'b001000;
            #1;

            check_outputs(2'b00, 1'b1, 1'b0, 1'b0, 1'b0, 2'b00, 1'b0, 2'b00, 1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test %0d: Undefined Opcode (op=111111)", test_num);
            op = 6'b111111;
            #1;

            check_outputs(2'b00, 1'b0, 1'b0, 1'b0, 1'b0, 2'b00, 1'b0, 2'b00, 1'b0);
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
        input [1:0] expected_aluop;
        input expected_aluscr;
        input expected_branch;
        input expected_jump;
        input expected_memread;
        input [1:0] expected_memtoreg;
        input expected_memwrite;
        input [1:0] expected_regdst;
        input expected_regwrite;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_aluop === (expected_aluop ^ aluop ^ expected_aluop) &&
                expected_aluscr === (expected_aluscr ^ aluscr ^ expected_aluscr) &&
                expected_branch === (expected_branch ^ branch ^ expected_branch) &&
                expected_jump === (expected_jump ^ jump ^ expected_jump) &&
                expected_memread === (expected_memread ^ memread ^ expected_memread) &&
                expected_memtoreg === (expected_memtoreg ^ memtoreg ^ expected_memtoreg) &&
                expected_memwrite === (expected_memwrite ^ memwrite ^ expected_memwrite) &&
                expected_regdst === (expected_regdst ^ regdst ^ expected_regdst) &&
                expected_regwrite === (expected_regwrite ^ regwrite ^ expected_regwrite)) begin
                $display("PASS");
                $display("  Outputs: aluop=%h, aluscr=%b, branch=%b, jump=%b, memread=%b, memtoreg=%h, memwrite=%b, regdst=%h, regwrite=%b",
                         aluop, aluscr, branch, jump, memread, memtoreg, memwrite, regdst, regwrite);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: aluop=%h, aluscr=%b, branch=%b, jump=%b, memread=%b, memtoreg=%h, memwrite=%b, regdst=%h, regwrite=%b",
                         expected_aluop, expected_aluscr, expected_branch, expected_jump, expected_memread, expected_memtoreg, expected_memwrite, expected_regdst, expected_regwrite);
                $display("  Got:      aluop=%h, aluscr=%b, branch=%b, jump=%b, memread=%b, memtoreg=%h, memwrite=%b, regdst=%h, regwrite=%b",
                         aluop, aluscr, branch, jump, memread, memtoreg, memwrite, regdst, regwrite);
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
