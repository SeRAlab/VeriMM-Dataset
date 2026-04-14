module top_module (
	input [9:0] in,
	output [8:0] out_and,
	output [9:1] out_or,
	output [9:0] out_xnor);assign out_and = in & in[9:1];
	assign out_or = in | in[9:1];
	assign out_xnor = ~(in^{in[0], in[9:1]});
	
endmodule