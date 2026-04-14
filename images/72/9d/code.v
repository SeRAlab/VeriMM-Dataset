module top_module (
	input [3:0] p,
	input [3:0] q,
	output [3:0] out_shift_left,
	output [3:0] out_shift_right);assign out_shift_left = p << 1;
assign out_shift_right = q >> 1;

endmodule