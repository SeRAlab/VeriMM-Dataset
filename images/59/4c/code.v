module top_module (
	input k, 
	input l, 
	input m, 
	input n,
	output reg o);assign o = (k & l & m & n) | (k & ~l & m & ~n) | (~k & l & m & ~n) | (~k & ~l & m & n);

endmodule