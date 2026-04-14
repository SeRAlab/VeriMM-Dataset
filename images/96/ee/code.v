module ripple_carry_adder (
	input [3:0] a,
	input [3:0] b,
	output [3:0] sum,
	output carry_out);assign {carry_out, sum} = a + b;

endmodule