module top_module (
	input [3:0] binary_in,
	output [3:0] gray_out);assign gray_out = binary_in ^ (binary_in >> 1);

endmodule