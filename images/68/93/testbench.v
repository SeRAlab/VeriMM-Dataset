`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] instr;
    wire addz;
    wire [2:0] aluOp;
    wire aluSrc0;
    wire aluSrc1;
    wire branch;
    wire [2:0] branchOp;
    wire [11:0] imm;
    wire jal;
    wire jr;
    wire memRe;
    wire memWe;
    wire neEn;
    wire ovEn;
    wire [3:0] p0Addr;
    wire [3:0] p1Addr;
    wire [3:0] regAddr;
    wire regRe0;
    wire regRe1;
    wire regWe;
    wire [3:0] shamt;
    wire zrEn;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .instr(instr),
        .addz(addz),
        .aluOp(aluOp),
        .aluSrc0(aluSrc0),
        .aluSrc1(aluSrc1),
        .branch(branch),
        .branchOp(branchOp),
        .imm(imm),
        .jal(jal),
        .jr(jr),
        .memRe(memRe),
        .memWe(memWe),
        .neEn(neEn),
        .ovEn(ovEn),
        .p0Addr(p0Addr),
        .p1Addr(p1Addr),
        .regAddr(regAddr),
        .regRe0(regRe0),
        .regRe1(regRe1),
        .regWe(regWe),
        .shamt(shamt),
        .zrEn(zrEn)
    );
    task testcase001;

    begin
        test_num = 1;

        instr = 16'h0123;
        #10;


        #1;



        check_outputs(1'b0, 3'b000, 1'b0, 1'b0, 1'b0, 3'b000, 12'h123, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b1, 4'h1, 4'h2, 4'h3, 1'b1, 1'b1, 1'b1, 4'h3, 1'b1);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;

        instr = 16'h8456;
        #10;

        #1;


        check_outputs(1'b0, 3'b000, 1'b0, 1'b1, 1'b0, 3'b000, 12'h456, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b1, 4'h4, 4'h5, 4'h5, 1'b1, 1'b0, 1'b1, 4'h6, 1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;

        instr = 16'h4A1F;
        #10;

        #1;


        check_outputs(1'b0, 3'b000, 1'b0, 1'b1, 1'b0, 3'b000, 12'hA1F, 1'b0, 1'b0, 1'b1, 1'b0, 1'b0, 1'b0, 4'hA, 4'h1, 4'h1, 1'b1, 1'b0, 1'b1, 4'hF, 1'b0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;

        instr = 16'h5B2E;
        #10;

        #1;


        check_outputs(1'b0, 3'b000, 1'b0, 1'b1, 1'b0, 3'b000, 12'hB2E, 1'b0, 1'b0, 1'b0, 1'b1, 1'b0, 1'b0, 4'hB, 4'h2, 4'h2, 1'b1, 1'b1, 1'b0, 4'hE, 1'b0);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;

        instr = 16'hC123;
        #10;

        #1;


        check_outputs(1'b0, 3'b000, 1'b0, 1'b0, 1'b1, 3'b001, 12'h123, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 4'h1, 4'h2, 4'h2, 1'b1, 1'b1, 1'b0, 4'h3, 1'b1);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;

        instr = 16'hFABC;
        #10;

        #1;


        check_outputs(1'b0, 3'b000, 1'b0, 1'b0, 1'b0, 3'b000, 12'hABC, 1'b1, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 4'hA, 4'hB, 4'hF, 1'b0, 1'b0, 1'b1, 4'hC, 1'b0);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;

        instr = 16'h1E00;
        #10;

        #1;


        check_outputs(1'b0, 3'b000, 1'b0, 1'b0, 1'b0, 3'b000, 12'hE00, 1'b0, 1'b1, 1'b0, 1'b0, 1'b0, 1'b0, 4'hE, 4'h0, 4'h0, 1'b1, 1'b0, 1'b0, 4'h0, 1'b0);
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
        input expected_addz;
        input [2:0] expected_aluOp;
        input expected_aluSrc0;
        input expected_aluSrc1;
        input expected_branch;
        input [2:0] expected_branchOp;
        input [11:0] expected_imm;
        input expected_jal;
        input expected_jr;
        input expected_memRe;
        input expected_memWe;
        input expected_neEn;
        input expected_ovEn;
        input [3:0] expected_p0Addr;
        input [3:0] expected_p1Addr;
        input [3:0] expected_regAddr;
        input expected_regRe0;
        input expected_regRe1;
        input expected_regWe;
        input [3:0] expected_shamt;
        input expected_zrEn;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_addz === (expected_addz ^ addz ^ expected_addz) &&
                expected_aluOp === (expected_aluOp ^ aluOp ^ expected_aluOp) &&
                expected_aluSrc0 === (expected_aluSrc0 ^ aluSrc0 ^ expected_aluSrc0) &&
                expected_aluSrc1 === (expected_aluSrc1 ^ aluSrc1 ^ expected_aluSrc1) &&
                expected_branch === (expected_branch ^ branch ^ expected_branch) &&
                expected_branchOp === (expected_branchOp ^ branchOp ^ expected_branchOp) &&
                expected_imm === (expected_imm ^ imm ^ expected_imm) &&
                expected_jal === (expected_jal ^ jal ^ expected_jal) &&
                expected_jr === (expected_jr ^ jr ^ expected_jr) &&
                expected_memRe === (expected_memRe ^ memRe ^ expected_memRe) &&
                expected_memWe === (expected_memWe ^ memWe ^ expected_memWe) &&
                expected_neEn === (expected_neEn ^ neEn ^ expected_neEn) &&
                expected_ovEn === (expected_ovEn ^ ovEn ^ expected_ovEn) &&
                expected_p0Addr === (expected_p0Addr ^ p0Addr ^ expected_p0Addr) &&
                expected_p1Addr === (expected_p1Addr ^ p1Addr ^ expected_p1Addr) &&
                expected_regAddr === (expected_regAddr ^ regAddr ^ expected_regAddr) &&
                expected_regRe0 === (expected_regRe0 ^ regRe0 ^ expected_regRe0) &&
                expected_regRe1 === (expected_regRe1 ^ regRe1 ^ expected_regRe1) &&
                expected_regWe === (expected_regWe ^ regWe ^ expected_regWe) &&
                expected_shamt === (expected_shamt ^ shamt ^ expected_shamt) &&
                expected_zrEn === (expected_zrEn ^ zrEn ^ expected_zrEn)) begin
                $display("PASS");
                $display("  Outputs: addz=%b, aluOp=%h, aluSrc0=%b, aluSrc1=%b, branch=%b, branchOp=%h, imm=%h, jal=%b, jr=%b, memRe=%b, memWe=%b, neEn=%b, ovEn=%b, p0Addr=%h, p1Addr=%h, regAddr=%h, regRe0=%b, regRe1=%b, regWe=%b, shamt=%h, zrEn=%b",
                         addz, aluOp, aluSrc0, aluSrc1, branch, branchOp, imm, jal, jr, memRe, memWe, neEn, ovEn, p0Addr, p1Addr, regAddr, regRe0, regRe1, regWe, shamt, zrEn);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: addz=%b, aluOp=%h, aluSrc0=%b, aluSrc1=%b, branch=%b, branchOp=%h, imm=%h, jal=%b, jr=%b, memRe=%b, memWe=%b, neEn=%b, ovEn=%b, p0Addr=%h, p1Addr=%h, regAddr=%h, regRe0=%b, regRe1=%b, regWe=%b, shamt=%h, zrEn=%b",
                         expected_addz, expected_aluOp, expected_aluSrc0, expected_aluSrc1, expected_branch, expected_branchOp, expected_imm, expected_jal, expected_jr, expected_memRe, expected_memWe, expected_neEn, expected_ovEn, expected_p0Addr, expected_p1Addr, expected_regAddr, expected_regRe0, expected_regRe1, expected_regWe, expected_shamt, expected_zrEn);
                $display("  Got:      addz=%b, aluOp=%h, aluSrc0=%b, aluSrc1=%b, branch=%b, branchOp=%h, imm=%h, jal=%b, jr=%b, memRe=%b, memWe=%b, neEn=%b, ovEn=%b, p0Addr=%h, p1Addr=%h, regAddr=%h, regRe0=%b, regRe1=%b, regWe=%b, shamt=%h, zrEn=%b",
                         addz, aluOp, aluSrc0, aluSrc1, branch, branchOp, imm, jal, jr, memRe, memWe, neEn, ovEn, p0Addr, p1Addr, regAddr, regRe0, regRe1, regWe, shamt, zrEn);
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
