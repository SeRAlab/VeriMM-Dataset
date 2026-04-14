module top_module(
	funct_i,
	ALUOp_i,
	ALUCtrl_o
);input	[1:0]		ALUOp_i;
input	[5:0]		funct_i;
output	[2:0]		ALUCtrl_o;

assign	ALUCtrl_o	=	(ALUOp_i == 2'b01) ? 3'b010 :
						((ALUOp_i == 2'b11) && (funct_i[3:0] == 4'b0000)) ? 3'b010 :
						((ALUOp_i == 2'b11) && (funct_i[3:0] == 4'b1000)) ? 3'b100 :
						((ALUOp_i == 2'b11) && (funct_i[3:0] == 4'b0010)) ? 3'b110 :
						((ALUOp_i == 2'b11) && (funct_i[3:0] == 4'b0100)) ? 3'b000 :
						((ALUOp_i == 2'b11) && (funct_i[3:0] == 4'b0101)) ? 3'b001 :
						3'bx;


endmodule