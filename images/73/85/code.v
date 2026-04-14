module top_module(
	input clk,
	input lorD,
	input [31:0] in0,
	input [31:0] in1,
	output wire[31:0] out
);assign out=(lorD)?in1:in0;endmodule