module top_module (
	input [15:0] x,
	input [15:0] y,
	output out_greater,
	output out_equal);assign out_greater = (x > y) ? 1 : 0;
assign out_equal = (x == y) ? 1 : 0;

endmodule