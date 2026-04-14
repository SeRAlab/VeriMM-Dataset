`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] inst;
    wire [2:0] funct3;
    wire [6:0] funct7;
    wire [6:0] opcode;
    wire [4:0] rd;
    wire [4:0] rs1;
    wire [4:0] rs2;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .inst(inst),
        .funct3(funct3),
        .funct7(funct7),
        .opcode(opcode),
        .rd(rd),
        .rs1(rs1),
        .rs2(rs2)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case 001: R-type ADD instruction (add x1, x2, x3)");
            inst = 32'h003100b3;

            #1;


            check_outputs(3'h0, 7'h00, 7'h33, 5'h01, 5'h02, 5'h03);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case 002: R-type SUB instruction (sub x10, x11, x12)");
            inst = 32'h40c58533;

            #1;


            check_outputs(3'h0, 7'h20, 7'h33, 5'h0a, 5'h0b, 5'h0c);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case 003: All Zeros pattern");
            inst = 32'h00000000;
            #1;

            check_outputs(3'h0, 7'h00, 7'h00, 5'h00, 5'h00, 5'h00);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case 004: All Ones pattern");
            inst = 32'hFFFFFFFF;
            #1;

            check_outputs(3'h7, 7'h7f, 7'h7f, 5'h1f, 5'h1f, 5'h1f);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case 005: S-type SW instruction (sw x14, 8(x2))");
            inst = 32'h00e12423;

            #1;


            check_outputs(3'h2, 7'h00, 7'h23, 5'h08, 5'h02, 5'h0e);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case 006: Random Bit Pattern (0xABCDE789)");
            inst = 32'hABCDE789;






            #1;







            check_outputs(3'h6, 7'h55, 7'h09, 5'h0f, 5'h1b, 5'h1c);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case 007: I-type ADDI instruction (addi x1, x1, 1)");
            inst = 32'h00108093;

            #1;


            check_outputs(3'h0, 7'h00, 7'h13, 5'h01, 5'h01, 5'h00);
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
        input [6:0] expected_opcode;
        input [4:0] expected_rd;
        input [4:0] expected_rs1;
        input [4:0] expected_rs2;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_funct3 === (expected_funct3 ^ funct3 ^ expected_funct3) &&
                expected_funct7 === (expected_funct7 ^ funct7 ^ expected_funct7) &&
                expected_opcode === (expected_opcode ^ opcode ^ expected_opcode) &&
                expected_rd === (expected_rd ^ rd ^ expected_rd) &&
                expected_rs1 === (expected_rs1 ^ rs1 ^ expected_rs1) &&
                expected_rs2 === (expected_rs2 ^ rs2 ^ expected_rs2)) begin
                $display("PASS");
                $display("  Outputs: funct3=%h, funct7=%h, opcode=%h, rd=%h, rs1=%h, rs2=%h",
                         funct3, funct7, opcode, rd, rs1, rs2);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: funct3=%h, funct7=%h, opcode=%h, rd=%h, rs1=%h, rs2=%h",
                         expected_funct3, expected_funct7, expected_opcode, expected_rd, expected_rs1, expected_rs2);
                $display("  Got:      funct3=%h, funct7=%h, opcode=%h, rd=%h, rs1=%h, rs2=%h",
                         funct3, funct7, opcode, rd, rs1, rs2);
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
