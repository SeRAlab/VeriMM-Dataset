module top_module (
	input i, 
	input j, 
	input k, 
	input l,
	output reg m);assign m = i&~j | k^~l | ~i&~l;

endmodule