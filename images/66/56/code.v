module top_module (
	input [21:0] in,
	output [20:0] out_and,
	output [21:1] out_or,
	output [21:0] out_xnor);assign out_and = in & in[21:1];
	assign out_or = in | in[21:1];
	assign out_xnor = ~(in^{in[0], in[21:1]});
	
endmodule