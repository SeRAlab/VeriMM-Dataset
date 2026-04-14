module top_module(
	input [3:0] a,
	input [3:0] b,
	input carry_in,
	output [3:0] sum,
	output carry_out);assign {carry_out, sum} = a + b + carry_in;
endmodule