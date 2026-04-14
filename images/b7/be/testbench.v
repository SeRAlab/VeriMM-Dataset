`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] instruction;
    reg [1:0] nsel;
    wire [1:0] ALUop;
    wire [1:0] op;
    wire [2:0] opcode;
    wire [2:0] readnum;
    wire [1:0] shift;
    wire [15:0] sximm5;
    wire [15:0] sximm8;
    wire [2:0] writenum;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .instruction(instruction),
        .nsel(nsel),
        .ALUop(ALUop),
        .op(op),
        .opcode(opcode),
        .readnum(readnum),
        .shift(shift),
        .sximm5(sximm5),
        .sximm8(sximm8),
        .writenum(writenum)
    );
    task testcase001;

    begin
        test_num = 1;

        instruction = 16'b101_11_000_000_00_000;
        nsel = 2'b00;
        #1;

        check_outputs(2'b11, 2'b11, 3'b101, 3'b000, 2'b00, 16'h0000, 16'h0000, 3'b000);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        instruction = 16'b000_00_110_000_00_000;
        nsel = 2'b00;
        #1;

        check_outputs(2'b00, 2'b00, 3'b000, 3'b110, 2'b00, 16'h0000, 16'h0000, 3'b110);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        instruction = 16'b000_00_000_101_00_000;
        nsel = 2'b01;
        #1;

        check_outputs(2'b00, 2'b00, 3'b000, 3'b101, 2'b00, 16'h0000, 16'h0000, 3'b101);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        instruction = 16'b000_00_000_000_00_011;
        nsel = 2'b10;
        #1;

        check_outputs(2'b00, 2'b00, 3'b000, 3'b011, 2'b00, 16'h0000, 16'h0000, 3'b011);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        instruction = 16'b000_00_000_000_11_000;
        nsel = 2'b00;
        #1;

        check_outputs(2'b00, 2'b00, 3'b000, 3'b000, 2'b11, 16'h0000, 16'h0000, 3'b000);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        instruction = 16'b000_00_000_000_00_01101;
        nsel = 2'b00;
        #1;

        check_outputs(2'b00, 2'b00, 3'b000, 3'b000, 2'b00, 16'h000D, 16'h000D, 3'b000);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        instruction = 16'b000_00_000_000_00_10011;
        nsel = 2'b00;
        #1;

        check_outputs(2'b00, 2'b00, 3'b000, 3'b000, 2'b00, 16'hFFF3, 16'h0013, 3'b000);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        instruction = 16'b000_00_000_01010101;
        nsel = 2'b00;
        #1;

        check_outputs(2'b00, 2'b00, 3'b000, 3'b000, 2'b00, 16'h0015, 16'h0055, 3'b000);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        instruction = 16'b000_00_000_10101010;
        nsel = 2'b00;
        #1;

        check_outputs(2'b00, 2'b00, 3'b000, 3'b000, 2'b00, 16'hFFF2, 16'hFFAA, 3'b000);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;

        instruction = 16'b110_10_001_010_01_100;
        nsel = 2'b01;
        #1;

        check_outputs(2'b10, 2'b10, 3'b110, 3'b010, 2'b01, 16'h000C, 16'h004C, 3'b010);
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
        input [1:0] expected_ALUop;
        input [1:0] expected_op;
        input [2:0] expected_opcode;
        input [2:0] expected_readnum;
        input [1:0] expected_shift;
        input [15:0] expected_sximm5;
        input [15:0] expected_sximm8;
        input [2:0] expected_writenum;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_ALUop === (expected_ALUop ^ ALUop ^ expected_ALUop) &&
                expected_op === (expected_op ^ op ^ expected_op) &&
                expected_opcode === (expected_opcode ^ opcode ^ expected_opcode) &&
                expected_readnum === (expected_readnum ^ readnum ^ expected_readnum) &&
                expected_shift === (expected_shift ^ shift ^ expected_shift) &&
                expected_sximm5 === (expected_sximm5 ^ sximm5 ^ expected_sximm5) &&
                expected_sximm8 === (expected_sximm8 ^ sximm8 ^ expected_sximm8) &&
                expected_writenum === (expected_writenum ^ writenum ^ expected_writenum)) begin
                $display("PASS");
                $display("  Outputs: ALUop=%h, op=%h, opcode=%h, readnum=%h, shift=%h, sximm5=%h, sximm8=%h, writenum=%h",
                         ALUop, op, opcode, readnum, shift, sximm5, sximm8, writenum);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ALUop=%h, op=%h, opcode=%h, readnum=%h, shift=%h, sximm5=%h, sximm8=%h, writenum=%h",
                         expected_ALUop, expected_op, expected_opcode, expected_readnum, expected_shift, expected_sximm5, expected_sximm8, expected_writenum);
                $display("  Got:      ALUop=%h, op=%h, opcode=%h, readnum=%h, shift=%h, sximm5=%h, sximm8=%h, writenum=%h",
                         ALUop, op, opcode, readnum, shift, sximm5, sximm8, writenum);
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
