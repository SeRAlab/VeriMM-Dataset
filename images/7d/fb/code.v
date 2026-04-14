module top_module (
	input m, 
	input n, 
	input o, 
	output reg v);assign v = (m & ~n & o) | (~m & n & o) | (m & n & ~o);
	
endmodule