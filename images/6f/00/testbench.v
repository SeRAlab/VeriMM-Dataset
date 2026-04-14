`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg Compare;
    reg [5:0] Fn;
    reg [5:0] Inst;
    wire [1:0] ALUOp;
    wire ALUSrc;
    wire Branch;
    wire FlushIF;
    wire Jr;
    wire Jump;
    wire MemRead;
    wire MemWrite;
    wire [1:0] MemtoReg;
    wire [1:0] RegDst;
    wire RegWrite;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .Compare(Compare),
        .Fn(Fn),
        .Inst(Inst),
        .ALUOp(ALUOp),
        .ALUSrc(ALUSrc),
        .Branch(Branch),
        .FlushIF(FlushIF),
        .Jr(Jr),
        .Jump(Jump),
        .MemRead(MemRead),
        .MemWrite(MemWrite),
        .MemtoReg(MemtoReg),
        .RegDst(RegDst),
        .RegWrite(RegWrite)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("\nTest %0d: R-type Instruction (ADD)", test_num);
            Inst = 6'h00;
            Fn = 6'h20;
            Compare = 0;

            #1;


            check_outputs(2'b10, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 2'b00, 2'b01, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTest %0d: Load Word (lw)", test_num);
            Inst = 6'h23;
            Fn = 6'h00;
            Compare = 0;

            #1;


            check_outputs(2'b00, 1'b1, 1'b0, 1'b0, 1'b0, 1'b0, 1'b1, 1'b0, 2'b01, 2'b00, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTest %0d: Store Word (sw)", test_num);
            Inst = 6'h2b;
            Fn = 6'h00;
            Compare = 0;

            #1;


            check_outputs(2'b00, 1'b1, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b1, 2'b00, 2'b00, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTest %0d: Branch Equal (beq) - Taken", test_num);
            Inst = 6'h04;
            Fn = 6'h00;
            Compare = 1;

            #1;


            check_outputs(2'b01, 1'b0, 1'b1, 1'b1, 1'b0, 1'b0, 1'b0, 1'b0, 2'b00, 2'b00, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nTest %0d: Branch Equal (beq) - Not Taken", test_num);
            Inst = 6'h04;
            Fn = 6'h00;
            Compare = 0;

            #1;


            check_outputs(2'b01, 1'b0, 1'b1, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 2'b00, 2'b00, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("\nTest %0d: Jump (j)", test_num);
            Inst = 6'h02;
            Fn = 6'h00;
            Compare = 0;


            #1;



            check_outputs(2'b00, 1'b0, 1'b0, 1'b1, 1'b0, 1'b1, 1'b0, 1'b0, 2'b00, 2'b00, 1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("\nTest %0d: Add Immediate (addi)", test_num);
            Inst = 6'h08;
            Fn = 6'h00;
            Compare = 0;

            #1;


            check_outputs(2'b00, 1'b1, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 2'b00, 2'b00, 1'b1);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("\nTest %0d: Jump Register (jr)", test_num);
            Inst = 6'h00;
            Fn = 6'h08;
            Compare = 0;

            #1;


            check_outputs(2'b10, 1'b0, 1'b0, 1'b1, 1'b1, 1'b0, 1'b0, 1'b0, 2'b00, 2'b00, 1'b0);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            $display("\nTest %0d: Subtract Immediate (subi)", test_num);
            Inst = 6'h0a;
            Fn = 6'h00;
            Compare = 0;

            #1;


            check_outputs(2'b00, 1'b1, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 2'b00, 2'b00, 1'b1);
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
        input expected_ALUSrc;
        input expected_Branch;
        input expected_FlushIF;
        input expected_Jr;
        input expected_Jump;
        input expected_MemRead;
        input expected_MemWrite;
        input [1:0] expected_MemtoReg;
        input [1:0] expected_RegDst;
        input expected_RegWrite;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_ALUOp === (expected_ALUOp ^ ALUOp ^ expected_ALUOp) &&
                expected_ALUSrc === (expected_ALUSrc ^ ALUSrc ^ expected_ALUSrc) &&
                expected_Branch === (expected_Branch ^ Branch ^ expected_Branch) &&
                expected_FlushIF === (expected_FlushIF ^ FlushIF ^ expected_FlushIF) &&
                expected_Jr === (expected_Jr ^ Jr ^ expected_Jr) &&
                expected_Jump === (expected_Jump ^ Jump ^ expected_Jump) &&
                expected_MemRead === (expected_MemRead ^ MemRead ^ expected_MemRead) &&
                expected_MemWrite === (expected_MemWrite ^ MemWrite ^ expected_MemWrite) &&
                expected_MemtoReg === (expected_MemtoReg ^ MemtoReg ^ expected_MemtoReg) &&
                expected_RegDst === (expected_RegDst ^ RegDst ^ expected_RegDst) &&
                expected_RegWrite === (expected_RegWrite ^ RegWrite ^ expected_RegWrite)) begin
                $display("PASS");
                $display("  Outputs: ALUOp=%h, ALUSrc=%b, Branch=%b, FlushIF=%b, Jr=%b, Jump=%b, MemRead=%b, MemWrite=%b, MemtoReg=%h, RegDst=%h, RegWrite=%b",
                         ALUOp, ALUSrc, Branch, FlushIF, Jr, Jump, MemRead, MemWrite, MemtoReg, RegDst, RegWrite);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ALUOp=%h, ALUSrc=%b, Branch=%b, FlushIF=%b, Jr=%b, Jump=%b, MemRead=%b, MemWrite=%b, MemtoReg=%h, RegDst=%h, RegWrite=%b",
                         expected_ALUOp, expected_ALUSrc, expected_Branch, expected_FlushIF, expected_Jr, expected_Jump, expected_MemRead, expected_MemWrite, expected_MemtoReg, expected_RegDst, expected_RegWrite);
                $display("  Got:      ALUOp=%h, ALUSrc=%b, Branch=%b, FlushIF=%b, Jr=%b, Jump=%b, MemRead=%b, MemWrite=%b, MemtoReg=%h, RegDst=%h, RegWrite=%b",
                         ALUOp, ALUSrc, Branch, FlushIF, Jr, Jump, MemRead, MemWrite, MemtoReg, RegDst, RegWrite);
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
