`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [5:0] op;
    wire [1:0] aluop;
    wire alusrc;
    wire branch;
    wire jump;
    wire memtoreg;
    wire memwrite;
    wire regdst;
    wire regwrite;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .op(op),
        .aluop(aluop),
        .alusrc(alusrc),
        .branch(branch),
        .jump(jump),
        .memtoreg(memtoreg),
        .memwrite(memwrite),
        .regdst(regdst),
        .regwrite(regwrite)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Test %0d: R-type Instruction", test_num);
        op = 6'b000000;

        #1;


        check_outputs(2'b10, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b1, 1'b1);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test %0d: LW (Load Word) Instruction", test_num);
        op = 6'b100011;
        #1;

        check_outputs(2'b00, 1'b1, 1'b0, 1'b0, 1'b1, 1'b0, 1'b0, 1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test %0d: SW (Store Word) Instruction", test_num);
        op = 6'b101011;
        #1;

        check_outputs(2'b00, 1'b1, 1'b0, 1'b0, 1'b0, 1'b1, 1'b0, 1'b0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test %0d: BEQ (Branch Equal) Instruction", test_num);
        op = 6'b000100;
        #1;

        check_outputs(2'b01, 1'b0, 1'b1, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test %0d: Jump Instruction", test_num);
        op = 6'b000010;
        #1;

        check_outputs(2'b00, 1'b0, 1'b0, 1'b1, 1'b0, 1'b0, 1'b0, 1'b0);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test %0d: ADDI (Add Immediate) Instruction", test_num);
        op = 6'b001000;
        #1;

        check_outputs(2'b00, 1'b1, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b1);
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
        input [1:0] expected_aluop;
        input expected_alusrc;
        input expected_branch;
        input expected_jump;
        input expected_memtoreg;
        input expected_memwrite;
        input expected_regdst;
        input expected_regwrite;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_aluop === (expected_aluop ^ aluop ^ expected_aluop) &&
                expected_alusrc === (expected_alusrc ^ alusrc ^ expected_alusrc) &&
                expected_branch === (expected_branch ^ branch ^ expected_branch) &&
                expected_jump === (expected_jump ^ jump ^ expected_jump) &&
                expected_memtoreg === (expected_memtoreg ^ memtoreg ^ expected_memtoreg) &&
                expected_memwrite === (expected_memwrite ^ memwrite ^ expected_memwrite) &&
                expected_regdst === (expected_regdst ^ regdst ^ expected_regdst) &&
                expected_regwrite === (expected_regwrite ^ regwrite ^ expected_regwrite)) begin
                $display("PASS");
                $display("  Outputs: aluop=%h, alusrc=%b, branch=%b, jump=%b, memtoreg=%b, memwrite=%b, regdst=%b, regwrite=%b",
                         aluop, alusrc, branch, jump, memtoreg, memwrite, regdst, regwrite);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: aluop=%h, alusrc=%b, branch=%b, jump=%b, memtoreg=%b, memwrite=%b, regdst=%b, regwrite=%b",
                         expected_aluop, expected_alusrc, expected_branch, expected_jump, expected_memtoreg, expected_memwrite, expected_regdst, expected_regwrite);
                $display("  Got:      aluop=%h, alusrc=%b, branch=%b, jump=%b, memtoreg=%b, memwrite=%b, regdst=%b, regwrite=%b",
                         aluop, alusrc, branch, jump, memtoreg, memwrite, regdst, regwrite);
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
