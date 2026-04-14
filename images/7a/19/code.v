module top_module(
	input  [5:0] funct,
	input  [1:0] aluop,
	output [2:0] alucontrol
    );assign alucontrol = (aluop == 2'b00)	  ? 3'b010 :
						(aluop == 2'b01) 	  ? 3'b110 :
						(aluop == 2'b11) 	  ? 3'b101 :
						(funct == 6'b10_0000) ? 3'b010 :
						(funct == 6'b10_0010) ? 3'b110 :
						(funct == 6'b10_0100) ? 3'b000 :
						(funct == 6'b10_0101) ? 3'b001 :
						(funct == 6'b10_1010) ? 3'b111 : 3'b101;

endmodule