module top_module (
	input f, 
	input g, 
	input h, 
	input j,
	output reg u);assign u = (f & ~g & h & ~j) | (~f & g & ~h & j) | (f & g & h & j) | (~f & ~g & h) | (f & ~h & ~j);

endmodule