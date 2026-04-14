module top_module(
    input [4:0] opcode,
    output Branch,
    output MemRead,
    output MemToReg,
    output [1:0] ALUOp,
    output MemWrite,
    output ALUSrc,
    output RegWrite,
    output JAL,
    output JALR);assign Branch = (opcode==5'b00110)?1:0;
    assign MemRead = (opcode==5'b00000)?1:0;
    assign MemToReg = (opcode==0)?1:0;
    assign ALUOp[1] = (opcode==3)?1:0;
    assign ALUOp[0] = (opcode==6)?1:0;
    assign MemWrite = (opcode==2)?1:0;
    assign ALUSrc = ((opcode==0)||(opcode==2))?1:0;
    assign RegWrite = ((opcode==0)||(opcode==3))?1:0;
    assign JAL = (opcode==5'b11_011)?1:0;
    assign JALR = (opcode==5'b11_001)?1:0;
endmodule