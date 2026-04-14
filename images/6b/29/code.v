module top_module (
	input [8:0] in,
	output [7:0] out_sum,
	output [7:0] out_or,
	output [8:0] out_xor);

assign out_sum = in[8:1] + in[7:0];
assign out_or = in[7:0] | in[8:1];
assign out_xor = in ^ {in[7:0], in[8]};

endmodule