`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg clk;
    reg [5:0] instru;
    wire [1:0] ALUOp;
    wire EscrMem;
    wire EscrReg;
    wire FuenteALU;
    wire LeerMem;
    wire MemaReg;
    wire RegDest;
    wire SaltoCond;
    wire Saltoincond;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .instru(instru),
        .ALUOp(ALUOp),
        .EscrMem(EscrMem),
        .EscrReg(EscrReg),
        .FuenteALU(FuenteALU),
        .LeerMem(LeerMem),
        .MemaReg(MemaReg),
        .RegDest(RegDest),
        .SaltoCond(SaltoCond),
        .Saltoincond(Saltoincond)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: R-type Instruction (opcode 000000)", test_num);
            instru = 6'b000000;
            @(posedge clk);
            #1;

            #1;


            check_outputs(2'b10, 1'b0, 1'b1, 1'b0, 1'b0, 1'b0, 1'b1, 1'b0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: LW Instruction (opcode 100011)", test_num);
            instru = 6'b100011;
            @(posedge clk);
            #1;
            #1;

            check_outputs(2'b00, 1'b0, 1'b1, 1'b1, 1'b1, 1'b1, 1'b0, 1'b0, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: SW Instruction (opcode 101011)", test_num);
            instru = 6'b101011;
            @(posedge clk);
            #1;
            #1;

            check_outputs(2'b00, 1'b1, 1'b0, 1'b1, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: BEQ Instruction (opcode 000100)", test_num);
            instru = 6'b000100;
            @(posedge clk);
            #1;
            #1;

            check_outputs(2'b01, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b1, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Jump Instruction (opcode 000010)", test_num);
            instru = 6'b000010;
            @(posedge clk);
            #1;
            #1;

            check_outputs(2'b00, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: ADDI Instruction (opcode 001000)", test_num);
            instru = 6'b001000;
            @(posedge clk);
            #1;
            #1;

            check_outputs(2'b00, 1'b0, 1'b1, 1'b1, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Unrecognized Instruction (opcode 111111)", test_num);
            instru = 6'b111111;
            @(posedge clk);
            #1;
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
        input [1:0] expected_ALUOp;
        input expected_EscrMem;
        input expected_EscrReg;
        input expected_FuenteALU;
        input expected_LeerMem;
        input expected_MemaReg;
        input expected_RegDest;
        input expected_SaltoCond;
        input expected_Saltoincond;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_ALUOp === (expected_ALUOp ^ ALUOp ^ expected_ALUOp) &&
                expected_EscrMem === (expected_EscrMem ^ EscrMem ^ expected_EscrMem) &&
                expected_EscrReg === (expected_EscrReg ^ EscrReg ^ expected_EscrReg) &&
                expected_FuenteALU === (expected_FuenteALU ^ FuenteALU ^ expected_FuenteALU) &&
                expected_LeerMem === (expected_LeerMem ^ LeerMem ^ expected_LeerMem) &&
                expected_MemaReg === (expected_MemaReg ^ MemaReg ^ expected_MemaReg) &&
                expected_RegDest === (expected_RegDest ^ RegDest ^ expected_RegDest) &&
                expected_SaltoCond === (expected_SaltoCond ^ SaltoCond ^ expected_SaltoCond) &&
                expected_Saltoincond === (expected_Saltoincond ^ Saltoincond ^ expected_Saltoincond)) begin
                $display("PASS");
                $display("  Outputs: ALUOp=%h, EscrMem=%b, EscrReg=%b, FuenteALU=%b, LeerMem=%b, MemaReg=%b, RegDest=%b, SaltoCond=%b, Saltoincond=%b",
                         ALUOp, EscrMem, EscrReg, FuenteALU, LeerMem, MemaReg, RegDest, SaltoCond, Saltoincond);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ALUOp=%h, EscrMem=%b, EscrReg=%b, FuenteALU=%b, LeerMem=%b, MemaReg=%b, RegDest=%b, SaltoCond=%b, Saltoincond=%b",
                         expected_ALUOp, expected_EscrMem, expected_EscrReg, expected_FuenteALU, expected_LeerMem, expected_MemaReg, expected_RegDest, expected_SaltoCond, expected_Saltoincond);
                $display("  Got:      ALUOp=%h, EscrMem=%b, EscrReg=%b, FuenteALU=%b, LeerMem=%b, MemaReg=%b, RegDest=%b, SaltoCond=%b, Saltoincond=%b",
                         ALUOp, EscrMem, EscrReg, FuenteALU, LeerMem, MemaReg, RegDest, SaltoCond, Saltoincond);
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
