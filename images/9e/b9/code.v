module top_module(input [5:0]opcode,output wire RegDst,ALUsrcB,MemToReg,WriteReg,MemWrite,Branch,ALUop1,ALUop0,JMP );wire j,r,lw,sw,beq; 
 and JP(JMP,~opcode[5],~opcode[4],~opcode[3],~opcode[2],opcode[1],~opcode[0]), 
 R(r,~opcode[5],~opcode[4],~opcode[3],~opcode[2],~opcode[1],~opcode[0]), 
 LW(lw,opcode[5],~opcode[4],~opcode[3],~opcode[2],opcode[1],opcode[0]), 
 SW(sw,opcode[5],~opcode[4],opcode[3],~opcode[2],opcode[1],opcode[0]), 
 BEQ(beq,~opcode[5],~opcode[4],~opcode[3],opcode[2],~opcode[1],~opcode[0]); 
 or ALUsrc(ALUsrcB,lw,sw), 
 writeReg(WriteReg,r,lw); 
 assign RegDst=r; 
 assign MemToReg=lw; 
 assign MemWrite=sw; 
 assign Branch=beq; 
 assign ALUop1=r; 
 assign ALUop0=beq; 
 endmodule