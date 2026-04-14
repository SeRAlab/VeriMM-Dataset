module arith_right_shift(
	input [15:0] in,
	input [3:0] shift_amount,
	output [15:0] out);
assign out = in >>> shift_amount;

endmodule