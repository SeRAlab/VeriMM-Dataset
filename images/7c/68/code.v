module decoder_3to8 (
	input a, b, c,
	output [7:0] y);assign y = 1 << {a, b, c};

endmodule