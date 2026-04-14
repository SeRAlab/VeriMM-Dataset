module top_module (
	input [14:0] in,
	output [13:0] out_and,
	output [13:0] out_or,
	output [14:0] out_xor);

assign out_and = in[13:0] & in[14:1];
assign out_or = in[13:0] | in[14:1];
assign out_xor = in ^ {in[13:0], in[14]};

endmodule