module top_module (
	input [11:0] in,
	output [10:0] out_and,
	output [10:0] out_or,
	output [11:0] out_xor);

assign out_and = in[10:0] & in[11:1];
assign out_or = in[10:0] | in[9:0];
assign out_xor = in ^ {in[10:0], in[11]};

endmodule