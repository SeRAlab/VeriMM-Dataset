`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [5:0] Funct;
    reg [5:0] Op;
    wire [5:0] ALUControl;
    wire ALUSrc;
    wire Branch;
    wire Jump;
    wire MemWrite;
    wire MemtoReg;
    wire RegDst;
    wire RegWrite;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .Funct(Funct),
        .Op(Op),
        .ALUControl(ALUControl),
        .ALUSrc(ALUSrc),
        .Branch(Branch),
        .Jump(Jump),
        .MemWrite(MemWrite),
        .MemtoReg(MemtoReg),
        .RegDst(RegDst),
        .RegWrite(RegWrite)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case %0d: R-type ADD", test_num);
            Op = 6'b000000;
            Funct = 6'h20;

            #1;


            check_outputs(6'h20, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b1, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case %0d: R-type SUB", test_num);
            Op = 6'b000000;
            Funct = 6'h22;

            #1;


            check_outputs(6'h22, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b1, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case %0d: Load Word (LW)", test_num);
            Op = 6'b100011;
            Funct = 6'bXXXXXX;

            #1;


            check_outputs(6'h20, 1'b1, 1'b0, 1'b0, 1'b0, 1'b1, 1'b0, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case %0d: Store Word (SW)", test_num);
            Op = 6'b101011;
            Funct = 6'bXXXXXX;

            #1;


            check_outputs(6'h20, 1'b1, 1'b0, 1'b0, 1'b1, 1'b0, 1'b0, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case %0d: Branch Equal (BEQ)", test_num);
            Op = 6'b000100;
            Funct = 6'bXXXXXX;

            #1;


            check_outputs(6'h22, 1'b0, 1'b1, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test Case %0d: Jump (J)", test_num);
            Op = 6'b000010;
            Funct = 6'bXXXXXX;

            #1;


            check_outputs(6'h00, 1'b0, 1'b0, 1'b1, 1'b0, 1'b0, 1'b0, 1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test Case %0d: R-type OR", test_num);
            Op = 6'b000000;
            Funct = 6'h25;

            #1;


            check_outputs(6'h25, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b1, 1'b1);
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
        input [5:0] expected_ALUControl;
        input expected_ALUSrc;
        input expected_Branch;
        input expected_Jump;
        input expected_MemWrite;
        input expected_MemtoReg;
        input expected_RegDst;
        input expected_RegWrite;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_ALUControl === (expected_ALUControl ^ ALUControl ^ expected_ALUControl) &&
                expected_ALUSrc === (expected_ALUSrc ^ ALUSrc ^ expected_ALUSrc) &&
                expected_Branch === (expected_Branch ^ Branch ^ expected_Branch) &&
                expected_Jump === (expected_Jump ^ Jump ^ expected_Jump) &&
                expected_MemWrite === (expected_MemWrite ^ MemWrite ^ expected_MemWrite) &&
                expected_MemtoReg === (expected_MemtoReg ^ MemtoReg ^ expected_MemtoReg) &&
                expected_RegDst === (expected_RegDst ^ RegDst ^ expected_RegDst) &&
                expected_RegWrite === (expected_RegWrite ^ RegWrite ^ expected_RegWrite)) begin
                $display("PASS");
                $display("  Outputs: ALUControl=%h, ALUSrc=%b, Branch=%b, Jump=%b, MemWrite=%b, MemtoReg=%b, RegDst=%b, RegWrite=%b",
                         ALUControl, ALUSrc, Branch, Jump, MemWrite, MemtoReg, RegDst, RegWrite);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ALUControl=%h, ALUSrc=%b, Branch=%b, Jump=%b, MemWrite=%b, MemtoReg=%b, RegDst=%b, RegWrite=%b",
                         expected_ALUControl, expected_ALUSrc, expected_Branch, expected_Jump, expected_MemWrite, expected_MemtoReg, expected_RegDst, expected_RegWrite);
                $display("  Got:      ALUControl=%h, ALUSrc=%b, Branch=%b, Jump=%b, MemWrite=%b, MemtoReg=%b, RegDst=%b, RegWrite=%b",
                         ALUControl, ALUSrc, Branch, Jump, MemWrite, MemtoReg, RegDst, RegWrite);
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
