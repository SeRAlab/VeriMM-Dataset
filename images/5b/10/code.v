module top_module (
	input [10:0] in,
	output [9:0] out_both,
	output [9:0] out_any,
	output [10:0] out_different);

assign out_both = in[9:0] & in[10:1];
assign out_any = in[9:0] | in[8:0];
assign out_different = in ^ {in[0], in[10:1]};

endmodule