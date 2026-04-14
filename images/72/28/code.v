module top_module (
	input [149:0] in,
	output [148:0] out_both,
	output [149:1] out_any,
	output [149:0] out_different);assign out_both = in & in[149:1];
	assign out_any = in | in[149:1];
	assign out_different = in^{in[0], in[149:1]};
	
endmodule