module top_module(imm,extop,result);input [15:0] imm;
	input extop;
	output [31:0] result;
	parameter zero = 16'h0000;
	parameter one = 16'hffff;
	assign result = (extop == 0) ? {zero,imm} : ((imm[15] == 0) ? {zero,imm} : {one,imm});
endmodule