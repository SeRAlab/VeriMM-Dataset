module top_module (
	input [19:0] in,
	output [18:0] out_both,
	output [19:1] out_any,
	output [19:0] out_different);assign out_both = in & in[19:1];
	assign out_any = in | in[19:1];
	assign out_different = in^{in[0], in[19:1]};
	
endmodule