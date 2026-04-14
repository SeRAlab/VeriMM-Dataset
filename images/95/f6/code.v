module top_module(
	input	[5:0]	Op,
	input	[5:0]	Funct,
	output			Jump,
	output			MemtoReg,
	output			MemWrite,
	output			Branch,
	output	[5:0]	ALUControl,
	output			ALUSrc,
	output			RegDst,
	output			RegWrite
);localparam [5:0] OP_RTYPE	= 6'b000000;	
localparam [5:0] OP_LW		= 6'b100011;	
localparam [5:0] OP_SW		= 6'b101011;	
localparam [5:0] OP_BEQ		= 6'b000100;	
localparam [5:0] OP_ADDI	= 6'b001000;	
localparam [5:0] OP_J		= 6'b000010;	







assign RegWrite = (Op == OP_RTYPE) | (Op == OP_LW) | ( Op == OP_ADDI); 	 

assign ALUSrc   = (Op == OP_LW) | (Op == OP_SW) | (Op == OP_ADDI);


assign RegDst	= (Op == OP_RTYPE);	
assign Branch	= (Op == OP_BEQ);	
assign MemWrite	= (Op == OP_SW);	
assign MemtoReg	= (Op == OP_LW);	
assign Jump		= (Op == OP_J);		







assign ALUControl =	ALUSrc ? 6'b100000 :	
					Branch ? 6'b100010 :	
					Funct;					
	 
endmodule