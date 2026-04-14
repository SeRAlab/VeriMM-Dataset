module top_module (
	input [19:0] in,
	output [18:0] out_and,
	output [19:1] out_or,
	output [19:0] out_xnor);assign out_and = in & in[19:1];
	assign out_or = in | in[19:1];
	assign out_xnor = ~(in^{in[0], in[19:1]});
	
endmodule