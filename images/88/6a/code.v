module top_module(
	input [15:0] src,
	output [31:0] out
);assign out= { src, 16'b0000_0000_0000_0000 };endmodule