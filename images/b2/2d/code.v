module top_module (
	input m, 
	input n, 
	input o, 
	input p,
	output reg w);assign w = (m & n & ~o & p) | (~m & ~n & p) | (m & ~n & o) | (~m & n & ~o & ~p);

endmodule