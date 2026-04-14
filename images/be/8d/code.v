module decoder_3to8(
	input wire [2:0] x,
	output wire [7:0] y
);assign y = 1 << x;
endmodule