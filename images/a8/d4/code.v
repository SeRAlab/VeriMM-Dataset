module top_module (
	input [39:0] in,
	output [38:0] out_both,
	output [39:1] out_any,
	output [39:0] out_different);assign out_both = in & in[39:1];
	assign out_any = in | in[39:1];
	assign out_different = in^{in[0], in[39:1]};
	
endmodule