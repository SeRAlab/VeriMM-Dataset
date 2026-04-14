module top_module (
	input b1,
	input b2,
	input b3,
	output reg b_out);assign b_out = (b1 & b2) | b3;
endmodule