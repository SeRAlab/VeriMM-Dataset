module top_module (
	input [23:0] in,
	output [22:0] out_both,
	output [23:1] out_any,
	output [23:0] out_different);assign out_both = in[22:0] & in[23:1];
assign out_any = in[22:0] | in[23:1];
assign out_different = in^{in[0], in[23:1]};

endmodule