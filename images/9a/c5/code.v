module top_module(
	input clk,
	input [1:0]ALUSrcB,
	input [31:0]in0,
	input [31:0]in2,
	input [31:0]in3, 
	output wire[31:0]out
);assign out = ALUSrcB[1] ? (ALUSrcB[0] ? in3 : in2) : (ALUSrcB[0] ? 32'd4 : in0);endmodule