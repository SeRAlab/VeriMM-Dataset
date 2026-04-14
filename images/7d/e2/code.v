module top_module (
	input [23:0] in,
	output [22:0] out_and,
	output [23:1] out_or,
	output [23:0] out_xnor);assign out_and = in & in[23:1];
	assign out_or = in | in[23:1];
	assign out_xnor = ~(in^{in[0], in[23:1]});
	
endmodule