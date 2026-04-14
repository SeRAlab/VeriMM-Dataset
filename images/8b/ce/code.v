module interleave (
	input [1:0] e,
	input [1:0] f,
	output [3:0] d);assign d = {e[1], f[1], e[0], f[0]};

endmodule