module top_module (
	input clock,
	input f, 
	output reg p,
	output reg q);always @(negedge clock)
		p <= f;
		
	always @(posedge clock)
		q <= f;
endmodule