module bin_to_gray(
	input [2:0] bin,
	output [2:0] gray
);

	assign gray = bin ^ (bin >> 1);

endmodule