module top_module (
	input clock,
	input j, 
	output reg f,
	output reg g);always @(negedge clock)
		f <= j;
		
	always @(posedge clock)
		g <= j;
endmodule