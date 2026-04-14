module top_module (
	input [9:0] in,
	output [8:0] out_and,
	output [8:0] out_or,
	output [9:0] out_xor);

assign out_and = in[8:0] & in[9:1];
assign out_or = in[8:0] | in[9:1];
assign out_xor = in ^ {in[8:0], in[9]};

endmodule