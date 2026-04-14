module top_module (
	input [3:0] in,
	output [2:0] out_and,
	output [3:1] out_or,
	output [3:0] out_xnor);assign out_and = in & in[3:1];
	assign out_or = in | in[3:1];
	assign out_xnor = ~(in^{in[0], in[3:1]});
	
endmodule