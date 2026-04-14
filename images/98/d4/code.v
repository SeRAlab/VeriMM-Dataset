module top_module(
    input wire clock,

    input wire [31:0] ID_instruction,
    output reg [31:0] EX_instruction,

    input wire [31:0] ID_pc_plus_four,
    output reg [31:0] EX_pc_plus_four,
    input wire [31:0] RegReadDataA,
    output reg [31:0] EX_RegReadDataA,
    input wire [31:0] RegReadDataB,
    output reg [31:0] EX_RegReadDataB,
    input wire [31:0] extended,
    output reg [31:0] EX_extended,

    input wire RegWrite,
    output reg EX_RegWrite,
    input wire RegDst,
    output reg EX_RegDst,
    input wire MemRead,
    output reg EX_MemRead,
    input wire MemWrite,
    output reg EX_MemWrite,
    input wire MemToReg,
    output reg EX_MemToReg,
    input wire Branch,
    output reg EX_Branch,
    input wire ALUSrc,
    output reg EX_ALUSrc,
    input wire [1:0] ALUOp,
    output reg [1:0] EX_ALUOp,

    input wire [4:0] rs,
    output reg [4:0] EX_rs,
    input wire [4:0] rt,
    output reg [4:0] EX_rt,
    input wire [4:0] rd,
    output reg [4:0] EX_rd
    );always @(posedge clock) begin
        EX_instruction <= ID_instruction;
        EX_pc_plus_four <= ID_pc_plus_four;
        EX_RegReadDataA <= RegReadDataA;
        EX_RegReadDataB <= RegReadDataB;
        EX_extended <= extended;
        EX_RegWrite <= RegWrite;
        EX_RegDst <= RegDst;
        EX_MemRead <= MemRead;
        EX_MemWrite <= MemWrite;
        EX_MemToReg <= MemToReg;
        EX_Branch <= Branch;
        EX_ALUSrc <= ALUSrc;
        EX_ALUOp <= ALUOp;
        EX_rs <= rs;
        EX_rt <= rt;
        EX_rd <= rd;
    end  // always
endmodule