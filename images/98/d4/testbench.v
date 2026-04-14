`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [1:0] ALUOp;
    reg ALUSrc;
    reg Branch;
    reg [31:0] ID_instruction;
    reg [31:0] ID_pc_plus_four;
    reg MemRead;
    reg MemToReg;
    reg MemWrite;
    reg RegDst;
    reg [31:0] RegReadDataA;
    reg [31:0] RegReadDataB;
    reg RegWrite;
    reg clock;
    reg [31:0] extended;
    reg [4:0] rd;
    reg [4:0] rs;
    reg [4:0] rt;
    wire [1:0] EX_ALUOp;
    wire EX_ALUSrc;
    wire EX_Branch;
    wire EX_MemRead;
    wire EX_MemToReg;
    wire EX_MemWrite;
    wire EX_RegDst;
    wire [31:0] EX_RegReadDataA;
    wire [31:0] EX_RegReadDataB;
    wire EX_RegWrite;
    wire [31:0] EX_extended;
    wire [31:0] EX_instruction;
    wire [31:0] EX_pc_plus_four;
    wire [4:0] EX_rd;
    wire [4:0] EX_rs;
    wire [4:0] EX_rt;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ALUOp(ALUOp),
        .ALUSrc(ALUSrc),
        .Branch(Branch),
        .ID_instruction(ID_instruction),
        .ID_pc_plus_four(ID_pc_plus_four),
        .MemRead(MemRead),
        .MemToReg(MemToReg),
        .MemWrite(MemWrite),
        .RegDst(RegDst),
        .RegReadDataA(RegReadDataA),
        .RegReadDataB(RegReadDataB),
        .RegWrite(RegWrite),
        .clock(clock),
        .extended(extended),
        .rd(rd),
        .rs(rs),
        .rt(rt),
        .EX_ALUOp(EX_ALUOp),
        .EX_ALUSrc(EX_ALUSrc),
        .EX_Branch(EX_Branch),
        .EX_MemRead(EX_MemRead),
        .EX_MemToReg(EX_MemToReg),
        .EX_MemWrite(EX_MemWrite),
        .EX_RegDst(EX_RegDst),
        .EX_RegReadDataA(EX_RegReadDataA),
        .EX_RegReadDataB(EX_RegReadDataB),
        .EX_RegWrite(EX_RegWrite),
        .EX_extended(EX_extended),
        .EX_instruction(EX_instruction),
        .EX_pc_plus_four(EX_pc_plus_four),
        .EX_rd(EX_rd),
        .EX_rs(EX_rs),
        .EX_rt(EX_rt)
    );

    // Clock generation (10ns period)
    initial begin
        clock = 0;
        forever #5 clock = ~clock;
    end

        task reset_dut;

        begin
            ALUOp = 2'b0;
            ALUSrc = 0;
            Branch = 0;
            ID_instruction = 32'b0;
            ID_pc_plus_four = 32'b0;
            MemRead = 0;
            MemToReg = 0;
            MemWrite = 0;
            RegDst = 0;
            RegReadDataA = 32'b0;
            RegReadDataB = 32'b0;
            RegWrite = 0;
            extended = 32'b0;
            rd = 5'b0;
            rs = 5'b0;
            rt = 5'b0;
            @(posedge clock);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();

            ID_instruction  = 32'h02324820;
            ID_pc_plus_four = 32'h00400004;
            RegReadDataA    = 32'h12345678;
            RegReadDataB    = 32'h87654321;
            extended        = 32'h00000000;
            RegWrite        = 1'b1;
            RegDst          = 1'b1;
            MemRead         = 1'b0;
            MemWrite        = 1'b0;
            MemToReg        = 1'b0;
            Branch          = 1'b0;
            ALUSrc          = 1'b0;
            ALUOp           = 2'b10;
            rs              = 5'd17;
            rt              = 5'd18;
            rd              = 5'd9;

            @(posedge clock);
            #1;

            #1;


            check_outputs(2'b10, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b1, 32'h12345678, 32'h87654321, 1'b1, 32'h00000000, 32'h02324820, 32'h00400004, 5'd9, 5'd17, 5'd18);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();

            ID_instruction  = 32'h8E680008;
            ID_pc_plus_four = 32'h00400008;
            RegReadDataA    = 32'h20000000;
            RegReadDataB    = 32'h00000000;
            extended        = 32'h00000008;
            RegWrite        = 1'b1;
            RegDst          = 1'b0;
            MemRead         = 1'b1;
            MemWrite        = 1'b0;
            MemToReg        = 1'b1;
            Branch          = 1'b0;
            ALUSrc          = 1'b1;
            ALUOp           = 2'b00;
            rs              = 5'd19;
            rt              = 5'd8;
            rd              = 5'd0;

            @(posedge clock);
            #1;

            #1;


            check_outputs(2'b00, 1'b1, 1'b0, 1'b1, 1'b1, 1'b0, 1'b0, 32'h20000000, 32'h00000000, 1'b1, 32'h00000008, 32'h8E680008, 32'h00400008, 5'd0, 5'd19, 5'd8);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();

            ID_instruction  = 32'h12320005;
            ID_pc_plus_four = 32'h0040000C;
            RegReadDataA    = 32'h00000005;
            RegReadDataB    = 32'h00000005;
            extended        = 32'h00000014;
            RegWrite        = 1'b0;
            RegDst          = 1'b0;
            MemRead         = 1'b0;
            MemWrite        = 1'b0;
            MemToReg        = 1'b0;
            Branch          = 1'b1;
            ALUSrc          = 1'b0;
            ALUOp           = 2'b01;
            rs              = 5'd17;
            rt              = 5'd18;
            rd              = 5'd0;

            @(posedge clock);
            #1;

            #1;


            check_outputs(2'b01, 1'b0, 1'b1, 1'b0, 1'b0, 1'b0, 1'b0, 32'h00000005, 32'h00000005, 1'b0, 32'h00000014, 32'h12320005, 32'h0040000C, 5'd0, 5'd17, 5'd18);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();

            ID_instruction  = 32'hFFFFFFFF;
            ID_pc_plus_four = 32'hFFFFFFFF;
            RegReadDataA    = 32'hFFFFFFFF;
            RegReadDataB    = 32'hFFFFFFFF;
            extended        = 32'hFFFFFFFF;
            RegWrite        = 1'b1;
            RegDst          = 1'b1;
            MemRead         = 1'b1;
            MemWrite        = 1'b1;
            MemToReg        = 1'b1;
            Branch          = 1'b1;
            ALUSrc          = 1'b1;
            ALUOp           = 2'b11;
            rs              = 5'h1F;
            rt              = 5'h1F;
            rd              = 5'h1F;

            @(posedge clock);
            #1;

            #1;


            check_outputs(2'b11, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 32'hFFFFFFFF, 32'hFFFFFFFF, 1'b1, 32'hFFFFFFFF, 32'hFFFFFFFF, 32'hFFFFFFFF, 5'h1F, 5'h1F, 5'h1F);
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
        input [1:0] expected_EX_ALUOp;
        input expected_EX_ALUSrc;
        input expected_EX_Branch;
        input expected_EX_MemRead;
        input expected_EX_MemToReg;
        input expected_EX_MemWrite;
        input expected_EX_RegDst;
        input [31:0] expected_EX_RegReadDataA;
        input [31:0] expected_EX_RegReadDataB;
        input expected_EX_RegWrite;
        input [31:0] expected_EX_extended;
        input [31:0] expected_EX_instruction;
        input [31:0] expected_EX_pc_plus_four;
        input [4:0] expected_EX_rd;
        input [4:0] expected_EX_rs;
        input [4:0] expected_EX_rt;
        begin
            if (expected_EX_ALUOp === (expected_EX_ALUOp ^ EX_ALUOp ^ expected_EX_ALUOp) &&
                expected_EX_ALUSrc === (expected_EX_ALUSrc ^ EX_ALUSrc ^ expected_EX_ALUSrc) &&
                expected_EX_Branch === (expected_EX_Branch ^ EX_Branch ^ expected_EX_Branch) &&
                expected_EX_MemRead === (expected_EX_MemRead ^ EX_MemRead ^ expected_EX_MemRead) &&
                expected_EX_MemToReg === (expected_EX_MemToReg ^ EX_MemToReg ^ expected_EX_MemToReg) &&
                expected_EX_MemWrite === (expected_EX_MemWrite ^ EX_MemWrite ^ expected_EX_MemWrite) &&
                expected_EX_RegDst === (expected_EX_RegDst ^ EX_RegDst ^ expected_EX_RegDst) &&
                expected_EX_RegReadDataA === (expected_EX_RegReadDataA ^ EX_RegReadDataA ^ expected_EX_RegReadDataA) &&
                expected_EX_RegReadDataB === (expected_EX_RegReadDataB ^ EX_RegReadDataB ^ expected_EX_RegReadDataB) &&
                expected_EX_RegWrite === (expected_EX_RegWrite ^ EX_RegWrite ^ expected_EX_RegWrite) &&
                expected_EX_extended === (expected_EX_extended ^ EX_extended ^ expected_EX_extended) &&
                expected_EX_instruction === (expected_EX_instruction ^ EX_instruction ^ expected_EX_instruction) &&
                expected_EX_pc_plus_four === (expected_EX_pc_plus_four ^ EX_pc_plus_four ^ expected_EX_pc_plus_four) &&
                expected_EX_rd === (expected_EX_rd ^ EX_rd ^ expected_EX_rd) &&
                expected_EX_rs === (expected_EX_rs ^ EX_rs ^ expected_EX_rs) &&
                expected_EX_rt === (expected_EX_rt ^ EX_rt ^ expected_EX_rt)) begin
                $display("PASS");
                $display("  Outputs: EX_ALUOp=%h, EX_ALUSrc=%b, EX_Branch=%b, EX_MemRead=%b, EX_MemToReg=%b, EX_MemWrite=%b, EX_RegDst=%b, EX_RegReadDataA=%h, EX_RegReadDataB=%h, EX_RegWrite=%b, EX_extended=%h, EX_instruction=%h, EX_pc_plus_four=%h, EX_rd=%h, EX_rs=%h, EX_rt=%h",
                         EX_ALUOp, EX_ALUSrc, EX_Branch, EX_MemRead, EX_MemToReg, EX_MemWrite, EX_RegDst, EX_RegReadDataA, EX_RegReadDataB, EX_RegWrite, EX_extended, EX_instruction, EX_pc_plus_four, EX_rd, EX_rs, EX_rt);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: EX_ALUOp=%h, EX_ALUSrc=%b, EX_Branch=%b, EX_MemRead=%b, EX_MemToReg=%b, EX_MemWrite=%b, EX_RegDst=%b, EX_RegReadDataA=%h, EX_RegReadDataB=%h, EX_RegWrite=%b, EX_extended=%h, EX_instruction=%h, EX_pc_plus_four=%h, EX_rd=%h, EX_rs=%h, EX_rt=%h",
                         expected_EX_ALUOp, expected_EX_ALUSrc, expected_EX_Branch, expected_EX_MemRead, expected_EX_MemToReg, expected_EX_MemWrite, expected_EX_RegDst, expected_EX_RegReadDataA, expected_EX_RegReadDataB, expected_EX_RegWrite, expected_EX_extended, expected_EX_instruction, expected_EX_pc_plus_four, expected_EX_rd, expected_EX_rs, expected_EX_rt);
                $display("  Got:      EX_ALUOp=%h, EX_ALUSrc=%b, EX_Branch=%b, EX_MemRead=%b, EX_MemToReg=%b, EX_MemWrite=%b, EX_RegDst=%b, EX_RegReadDataA=%h, EX_RegReadDataB=%h, EX_RegWrite=%b, EX_extended=%h, EX_instruction=%h, EX_pc_plus_four=%h, EX_rd=%h, EX_rs=%h, EX_rt=%h",
                         EX_ALUOp, EX_ALUSrc, EX_Branch, EX_MemRead, EX_MemToReg, EX_MemWrite, EX_RegDst, EX_RegReadDataA, EX_RegReadDataB, EX_RegWrite, EX_extended, EX_instruction, EX_pc_plus_four, EX_rd, EX_rs, EX_rt);
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

    // Optional: Waveform dump for debugging
    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0,ALUOp, ALUSrc, Branch, ID_instruction, ID_pc_plus_four, MemRead, MemToReg, MemWrite, RegDst, RegReadDataA, RegReadDataB, RegWrite, clock, extended, rd, rs, rt, EX_ALUOp, EX_ALUSrc, EX_Branch, EX_MemRead, EX_MemToReg, EX_MemWrite, EX_RegDst, EX_RegReadDataA, EX_RegReadDataB, EX_RegWrite, EX_extended, EX_instruction, EX_pc_plus_four, EX_rd, EX_rs, EX_rt);
    end

endmodule
