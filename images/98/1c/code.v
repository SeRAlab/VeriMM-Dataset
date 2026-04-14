module top_module(
	input clk,
	input ALUSrcA,
	input [31:0]in0,
	input [31:0]in1,
	output wire[31:0]out
);assign out = ALUSrcA? in1 : in0;endmodule