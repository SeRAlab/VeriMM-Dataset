module top_module (
	input d, 
	input e, 
	input f, 
	input g,
	output reg j);assign j = d&~e | f&~g | ~d&g;

endmodule