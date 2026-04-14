`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] ins;
    wire [3:0] aluCtr;
    wire aluSrc;
    wire branch;
    wire extOp;
    wire jump;
    wire memWr;
    wire memtoReg;
    wire regDst;
    wire regWr;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ins(ins),
        .aluCtr(aluCtr),
        .aluSrc(aluSrc),
        .branch(branch),
        .extOp(extOp),
        .jump(jump),
        .memWr(memWr),
        .memtoReg(memtoReg),
        .regDst(regDst),
        .regWr(regWr)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: ADD Instruction", test_num);

        ins = 32'h00430820;

        #1;


        check_outputs(4'b0010, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b1, 1'b1);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: SUB Instruction", test_num);

        ins = 32'h00430822;

        #1;


        check_outputs(4'b0110, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b1, 1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: AND Instruction", test_num);

        ins = 32'h00430824;

        #1;


        check_outputs(4'b0000, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b1, 1'b1);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: SLT Instruction", test_num);

        ins = 32'h0043082a;

        #1;


        check_outputs(4'b0111, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b1, 1'b1);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: LW Instruction", test_num);

        ins = 32'h8C410004;

        #1;


        check_outputs(4'b0010, 1'b1, 1'b0, 1'b1, 1'b0, 1'b0, 1'b1, 1'b0, 1'b1);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: SW Instruction", test_num);

        ins = 32'hAC410004;

        #1;


        check_outputs(4'b0010, 1'b1, 1'b0, 1'b1, 1'b0, 1'b1, 1'b0, 1'b0, 1'b0);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: BEQ Instruction", test_num);

        ins = 32'h10220004;

        #1;


        check_outputs(4'b0110, 1'b0, 1'b1, 1'b1, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: ADDI Instruction", test_num);

        ins = 32'h20410064;

        #1;


        check_outputs(4'b0010, 1'b1, 1'b0, 1'b1, 1'b0, 1'b0, 1'b0, 1'b0, 1'b1);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: ORI Instruction", test_num);

        ins = 32'h34410064;

        #1;


        check_outputs(4'b0001, 1'b1, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b1);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Jump Instruction", test_num);

        ins = 32'h08000001;

        #1;


        check_outputs(4'b0000, 1'b0, 1'b0, 1'b0, 1'b1, 1'b0, 1'b0, 1'b0, 1'b0);
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
        testcase010();
        
        
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
        input [3:0] expected_aluCtr;
        input expected_aluSrc;
        input expected_branch;
        input expected_extOp;
        input expected_jump;
        input expected_memWr;
        input expected_memtoReg;
        input expected_regDst;
        input expected_regWr;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_aluCtr === (expected_aluCtr ^ aluCtr ^ expected_aluCtr) &&
                expected_aluSrc === (expected_aluSrc ^ aluSrc ^ expected_aluSrc) &&
                expected_branch === (expected_branch ^ branch ^ expected_branch) &&
                expected_extOp === (expected_extOp ^ extOp ^ expected_extOp) &&
                expected_jump === (expected_jump ^ jump ^ expected_jump) &&
                expected_memWr === (expected_memWr ^ memWr ^ expected_memWr) &&
                expected_memtoReg === (expected_memtoReg ^ memtoReg ^ expected_memtoReg) &&
                expected_regDst === (expected_regDst ^ regDst ^ expected_regDst) &&
                expected_regWr === (expected_regWr ^ regWr ^ expected_regWr)) begin
                $display("PASS");
                $display("  Outputs: aluCtr=%h, aluSrc=%b, branch=%b, extOp=%b, jump=%b, memWr=%b, memtoReg=%b, regDst=%b, regWr=%b",
                         aluCtr, aluSrc, branch, extOp, jump, memWr, memtoReg, regDst, regWr);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: aluCtr=%h, aluSrc=%b, branch=%b, extOp=%b, jump=%b, memWr=%b, memtoReg=%b, regDst=%b, regWr=%b",
                         expected_aluCtr, expected_aluSrc, expected_branch, expected_extOp, expected_jump, expected_memWr, expected_memtoReg, expected_regDst, expected_regWr);
                $display("  Got:      aluCtr=%h, aluSrc=%b, branch=%b, extOp=%b, jump=%b, memWr=%b, memtoReg=%b, regDst=%b, regWr=%b",
                         aluCtr, aluSrc, branch, extOp, jump, memWr, memtoReg, regDst, regWr);
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
