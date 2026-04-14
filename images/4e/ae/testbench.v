`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg control_sel;
    reg [6:0] opcode;
    wire ALUSrc;
    wire [1:0] ALUop;
    wire Branch;
    wire MemRead;
    wire MemWrite;
    wire MemtoReg;
    wire RegWrite;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .control_sel(control_sel),
        .opcode(opcode),
        .ALUSrc(ALUSrc),
        .ALUop(ALUop),
        .Branch(Branch),
        .MemRead(MemRead),
        .MemWrite(MemWrite),
        .MemtoReg(MemtoReg),
        .RegWrite(RegWrite)
    );
    task testcase001;

    begin
        $display("Running testcase001: Override check (control_sel=1)");
        test_num = 1;
        control_sel = 1;
        opcode = 7'b0110011;
        #10;

        #1;


        check_outputs(1'b0, 2'b00, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0);
    end
        endtask

    task testcase002;

    begin
        $display("Running testcase002: R-type opcode (0110011)");
        test_num = 2;
        control_sel = 0;
        opcode = 7'b0110011;
        #10;

        #1;


        check_outputs(1'b0, 2'b10, 1'b0, 1'b0, 1'b0, 1'b0, 1'b1);
    end
        endtask

    task testcase003;

    begin
        $display("Running testcase003: Load opcode (0000011)");
        test_num = 3;
        control_sel = 0;
        opcode = 7'b0000011;
        #10;

        #1;


        check_outputs(1'b1, 2'b00, 1'b0, 1'b1, 1'b0, 1'b1, 1'b1);
    end
        endtask

    task testcase004;

    begin
        $display("Running testcase004: Store opcode (0100011)");
        test_num = 4;
        control_sel = 0;
        opcode = 7'b0100011;
        #10;

        #1;


        check_outputs(1'b1, 2'b00, 1'b0, 1'b0, 1'b1, 1'b0, 1'b0);
    end
        endtask

    task testcase005;

    begin
        $display("Running testcase005: Branch opcode (1100011)");
        test_num = 5;
        control_sel = 0;
        opcode = 7'b1100011;
        #10;

        #1;


        check_outputs(1'b0, 2'b01, 1'b1, 1'b0, 1'b0, 1'b0, 1'b0);
    end
        endtask

    task testcase006;

    begin
        $display("Running testcase006: Override check with Load opcode (control_sel=1)");
        test_num = 6;
        control_sel = 1;
        opcode = 7'b0000011;
        #10;

        #1;


        check_outputs(1'b0, 2'b00, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0);
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
        input expected_ALUSrc;
        input [1:0] expected_ALUop;
        input expected_Branch;
        input expected_MemRead;
        input expected_MemWrite;
        input expected_MemtoReg;
        input expected_RegWrite;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_ALUSrc === (expected_ALUSrc ^ ALUSrc ^ expected_ALUSrc) &&
                expected_ALUop === (expected_ALUop ^ ALUop ^ expected_ALUop) &&
                expected_Branch === (expected_Branch ^ Branch ^ expected_Branch) &&
                expected_MemRead === (expected_MemRead ^ MemRead ^ expected_MemRead) &&
                expected_MemWrite === (expected_MemWrite ^ MemWrite ^ expected_MemWrite) &&
                expected_MemtoReg === (expected_MemtoReg ^ MemtoReg ^ expected_MemtoReg) &&
                expected_RegWrite === (expected_RegWrite ^ RegWrite ^ expected_RegWrite)) begin
                $display("PASS");
                $display("  Outputs: ALUSrc=%b, ALUop=%h, Branch=%b, MemRead=%b, MemWrite=%b, MemtoReg=%b, RegWrite=%b",
                         ALUSrc, ALUop, Branch, MemRead, MemWrite, MemtoReg, RegWrite);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ALUSrc=%b, ALUop=%h, Branch=%b, MemRead=%b, MemWrite=%b, MemtoReg=%b, RegWrite=%b",
                         expected_ALUSrc, expected_ALUop, expected_Branch, expected_MemRead, expected_MemWrite, expected_MemtoReg, expected_RegWrite);
                $display("  Got:      ALUSrc=%b, ALUop=%h, Branch=%b, MemRead=%b, MemWrite=%b, MemtoReg=%b, RegWrite=%b",
                         ALUSrc, ALUop, Branch, MemRead, MemWrite, MemtoReg, RegWrite);
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
