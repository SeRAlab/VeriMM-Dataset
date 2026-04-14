module top_module (
	input clock,
	input b, 
	output reg x,
	output reg y);always @(posedge clock)
		x <= b;
		
	always @(negedge clock)
		y <= b;
endmodule