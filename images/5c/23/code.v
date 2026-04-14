module top_module(
	input [15:0] src,
	output [31:0] out
);assign out = { {16{src[15]}}, src };endmodule