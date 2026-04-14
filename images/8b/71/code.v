module top_module (
	input l,
	input m,
	output reg n);assign n = l & m | ~l & ~m;

endmodule