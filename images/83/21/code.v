module top_module (
	input [5:0] in,
	output [4:0] out_and,
	output [4:0] out_or,
	output [5:0] out_xor);

assign out_and = in[4:0] & in[5:1];
assign out_or = in[4:0] | in[3:0];
assign out_xor = in ^ {in[0], in[5:1]};

endmodule