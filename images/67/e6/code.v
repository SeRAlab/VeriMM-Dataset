module xor_4bit(
	input wire [3:0] m,
	input wire [3:0] n,
	output wire [3:0] z
);assign z = m ^ n;
endmodule