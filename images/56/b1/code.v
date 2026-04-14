module top_module (
	input [13:0] in,
	output [12:0] out_and,
	output [13:1] out_or,
	output [13:0] out_xnor);assign out_and = in & in[13:1];
	assign out_or = in | in[13:1];
	assign out_xnor = ~(in^{in[0], in[13:1]});
	
endmodule