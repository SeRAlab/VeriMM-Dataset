module subtractor_4bit(
	input wire [3:0] a,
	input wire [3:0] b,
	output wire [3:0] diff
);assign diff = a - b;
endmodule