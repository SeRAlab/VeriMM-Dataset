module top_module (
	input g, 
	input h, 
	input i, 
	input j,
	output reg o);assign o = g | ~h^i | ~g&~j;

endmodule