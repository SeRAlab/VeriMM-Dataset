module top_module(Op_i,RegDst_o,Jump_o,Branch_o,MemRead_o,MemtoReg_o,ALUOp_o,MemWrite_o,ALUSrc_o,RegWrite_o);parameter Op_lw=6'b100011,Op_sw=6'b101011,Op_beq=6'b000100,Op_ALU=6'b000000,Op_j=6'b000010,Op_addi=6'b001000;
input	[5:0]	Op_i;
output			RegDst_o,Jump_o,Branch_o,MemRead_o,MemtoReg_o,MemWrite_o,ALUSrc_o,RegWrite_o;
output	[1:0]	ALUOp_o;

assign RegDst_o=(Op_i==0 || (Op_i&6'b111110)==6'b000010 || 
	(Op_i&6'b111100)==6'b010000)?1:0;
assign Jump_o=(Op_i==Op_j)?1:0;
assign Branch_o=(Op_i==Op_beq)?1:0;
assign MemRead_o=(Op_i==Op_lw)?1:0;
assign MemtoReg_o=(Op_i==Op_lw)?1:0;
assign ALUOp_o=(Op_i==Op_beq)?2'b01:(Op_i==Op_lw || Op_i==Op_sw || Op_i==Op_addi)?2'b00:2'b10;
assign MemWrite_o=(Op_i==Op_sw)?1:0;
assign ALUSrc_o=(Op_i==Op_beq || Op_i==0 || (Op_i&6'b111110)==6'b000010 || 
	(Op_i&6'b111100)==6'b010000)?0:1;
assign RegWrite_o=(Op_i==Op_lw || Op_i==Op_ALU || Op_i==6'b001000)?1:0;

endmodule