module top_module (
	input [7:0] in,
	output [7:0] out_shift_left,
	output [7:0] out_shift_right);assign out_shift_left = in << 1;
assign out_shift_right = in >> 1;

endmodule