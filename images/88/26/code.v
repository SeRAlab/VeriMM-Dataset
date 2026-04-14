module new_module_5 (
	input clock,
	input f, 
	output reg g,
	output reg h);always @(negedge clock)
		g <= f;
		
	always @(posedge clock)
		h <= f;
endmodule