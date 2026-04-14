module top_module(
	input clk,
	input RegDst,
	input [4:0] in0,
	input [4:0] in1,
	output wire[4:0] out
);assign out = RegDst ? in1 : in0;endmodule