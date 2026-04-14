module binary_to_gray(
	input wire [3:0] binary,
	output wire [3:0] gray
);assign gray = (binary >> 1) ^ binary;
endmodule