module top_module (
	input f, 
	input g, 
	input h, 
	input i,
	output reg j);assign j = (f & g & h & i) | (f & ~g & h & ~i) | (~f & g & h & ~i) | (~f & ~g & h & i);

endmodule