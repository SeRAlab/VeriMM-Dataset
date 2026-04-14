module top_module (
	input clock,
	input t, 
	output reg o,
	output reg p);always @(negedge clock)
		o <= t;
		
	always @(posedge clock)
		p <= t;
endmodule