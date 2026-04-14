module top_module (
	input [6:0] in,
	output [5:0] out_sum,
	output [5:0] out_or,
	output [6:0] out_xor);

assign out_sum = in[6:1] + in[5:0];
assign out_or = in[5:0] | in[6:1];
assign out_xor = in ^ {in[5:0], in[6]};

endmodule