`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] instr_in;
    wire [2:0] funct3;
    wire [6:0] funct7;
    wire [11:0] imm;
    wire [19:0] imm_u;
    wire [31:0] jmp;
    wire [6:0] operation;
    wire [4:0] rd;
    wire [4:0] rs1;
    wire [4:0] rs2;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .instr_in(instr_in),
        .funct3(funct3),
        .funct7(funct7),
        .imm(imm),
        .imm_u(imm_u),
        .jmp(jmp),
        .operation(operation),
        .rd(rd),
        .rs1(rs1),
        .rs2(rs2)
    );
    task testcase001;

        begin
            test_num = 1;
            instr_in = 32'h00A08293;


            #1;



            check_outputs(3'h0, 7'h00, 12'h00A, 20'h0000A, 32'h0, 7'h13, 5'h05, 5'h01, 5'h0A);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            instr_in = 32'h0020A423;


            #1;



            check_outputs(3'h2, 7'h00, 12'h008, 20'h00002, 32'h0, 7'h23, 5'h08, 5'h01, 5'h02);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            instr_in = 32'h00208263;

            #1;


            check_outputs(3'h0, 7'h00, 12'h004, 20'h00002, 32'h0, 7'h63, 5'h04, 5'h01, 5'h02);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            instr_in = 32'h12345537;

            #1;


            check_outputs(3'h5, 7'h09, 12'h345, 20'h12345, 32'h0, 7'h37, 5'h0A, 5'h04, 5'h03);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            instr_in = 32'h001000EF;

            #1;


            check_outputs(3'h0, 7'h00, 12'h000, 20'h00100, 32'h00000800, 7'h6F, 5'h01, 5'h00, 5'h01);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            instr_in = 32'h002081B3;

            #1;


            check_outputs(3'h0, 7'h00, 12'h002, 20'h00208, 32'h0, 7'h33, 5'h03, 5'h01, 5'h02);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            instr_in = 32'hFFF08093;

            #1;


            check_outputs(3'h0, 7'h7F, 12'hFFF, 20'hFFF08, 32'h0, 7'h13, 5'h01, 5'h01, 5'h1F);
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
        input [2:0] expected_funct3;
        input [6:0] expected_funct7;
        input [11:0] expected_imm;
        input [19:0] expected_imm_u;
        input [31:0] expected_jmp;
        input [6:0] expected_operation;
        input [4:0] expected_rd;
        input [4:0] expected_rs1;
        input [4:0] expected_rs2;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_funct3 === (expected_funct3 ^ funct3 ^ expected_funct3) &&
                expected_funct7 === (expected_funct7 ^ funct7 ^ expected_funct7) &&
                expected_imm === (expected_imm ^ imm ^ expected_imm) &&
                expected_imm_u === (expected_imm_u ^ imm_u ^ expected_imm_u) &&
                expected_jmp === (expected_jmp ^ jmp ^ expected_jmp) &&
                expected_operation === (expected_operation ^ operation ^ expected_operation) &&
                expected_rd === (expected_rd ^ rd ^ expected_rd) &&
                expected_rs1 === (expected_rs1 ^ rs1 ^ expected_rs1) &&
                expected_rs2 === (expected_rs2 ^ rs2 ^ expected_rs2)) begin
                $display("PASS");
                $display("  Outputs: funct3=%h, funct7=%h, imm=%h, imm_u=%h, jmp=%h, operation=%h, rd=%h, rs1=%h, rs2=%h",
                         funct3, funct7, imm, imm_u, jmp, operation, rd, rs1, rs2);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: funct3=%h, funct7=%h, imm=%h, imm_u=%h, jmp=%h, operation=%h, rd=%h, rs1=%h, rs2=%h",
                         expected_funct3, expected_funct7, expected_imm, expected_imm_u, expected_jmp, expected_operation, expected_rd, expected_rs1, expected_rs2);
                $display("  Got:      funct3=%h, funct7=%h, imm=%h, imm_u=%h, jmp=%h, operation=%h, rd=%h, rs1=%h, rs2=%h",
                         funct3, funct7, imm, imm_u, jmp, operation, rd, rs1, rs2);
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
