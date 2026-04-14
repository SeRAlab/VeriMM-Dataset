module and_gate(
	input wire [3:0] x,
	input wire [3:0] z,
	output wire [3:0] w
);assign w = x & z;
endmodule