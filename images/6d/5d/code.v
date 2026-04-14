module binary_to_gray(
	input [3:0] binary,
	output [3:0] gray);assign gray = {binary[3], binary[3] ^ binary[2], binary[2] ^ binary[1], binary[1] ^ binary[0]};

endmodule