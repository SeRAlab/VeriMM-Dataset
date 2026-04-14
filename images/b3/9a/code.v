module and_8bit(
	input wire [7:0] p,
	input wire [7:0] q,
	output wire [7:0] r
);assign r = p & q;
endmodule