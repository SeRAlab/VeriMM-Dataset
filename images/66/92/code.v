module adder (
	input [7:0] a,
	input [7:0] b,
	input carry_in,
	output [7:0] sum,
	output carry_out);assign {carry_out, sum} = a + b + carry_in;

endmodule