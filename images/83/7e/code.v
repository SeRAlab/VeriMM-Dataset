module top_module (
	input m, 
	input n, 
	input o, 
	input p,
	output reg r);assign r = (m & n & o & p) | (m & ~n & o & ~p) | (~m & n & o & p) | (m & ~n & ~o & p);

endmodule