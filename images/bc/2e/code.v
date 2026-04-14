module top_module(instr, RegWr, RegDst, ExtOp, ALUSrc, ALUOp, Branch,
     MemWr, MemToReg);input [31:0] instr;
  output RegWr, RegDst, ExtOp, ALUSrc, Branch, MemWr, MemToReg;
  output [4:0] ALUOp;
  wire [31:0] instr;
  wire RegWr, RegDst, ExtOp, ALUSrc, Branch, MemWr, MemToReg;
  wire [4:0] ALUOp;
  assign MemToReg = 1'b0;
  assign MemWr = 1'b0;
  assign Branch = 1'b0;
  assign ALUOp[0] = 1'b0;
  assign ALUOp[1] = 1'b0;
  assign ALUOp[2] = 1'b0;
  assign ALUOp[3] = 1'b0;
  assign ALUOp[4] = 1'b0;
  assign ALUSrc = 1'b0;
  assign ExtOp = 1'b0;
  assign RegDst = instr[6];
  assign RegWr = 1'b0;
endmodule