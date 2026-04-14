module top_module (
	input m, 
	input n, 
	input p, 
	output reg r);assign r = (m & ~n & p) | (m & n & ~p) | (~m & n & p);
	
endmodule