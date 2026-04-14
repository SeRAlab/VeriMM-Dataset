module decoder3to8 (
	input a,
	input b,
	input c,
	output [7:0] y);assign y = 1 << {a, b, c};
endmodule