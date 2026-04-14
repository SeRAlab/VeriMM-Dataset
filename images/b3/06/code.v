module top_module (
	input h, 
	input i, 
	input j, 
	output reg k);assign k = (h & ~i & j) | (~h & i & j) | (h & i & ~j);
	
endmodule