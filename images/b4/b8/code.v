module top_module (
	input [15:0] g,
	output [14:0] out_and,
	output [14:0] out_nor);assign out_and = g[14:0] & g[15:1];
	assign out_nor = ~(g[14:0] | g[15:1]);
	
endmodule