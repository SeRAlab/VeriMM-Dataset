module yet_another_module (
	input clock,
	input t, 
	output reg g,
	output reg h);always @(negedge clock)
		g <= t;
		
	always @(posedge clock)
		h <= t;
endmodule