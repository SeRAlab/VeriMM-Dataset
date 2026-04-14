module top_module (
	input [8:0] in,
	output [7:0] out_both,
	output [8:1] out_any,
	output [8:0] out_different);assign out_both = in[7:0] & in[8:1];
assign out_any = in[7:0] | in[8:1];
assign out_different = in^{in[0], in[8:1]};

endmodule