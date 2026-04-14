module top_module (
	input clock,
	input g, 
	output reg x,
	output reg y);always @(negedge clock)
		x <= g;
		
	always @(posedge clock)
		y <= g;
endmodule