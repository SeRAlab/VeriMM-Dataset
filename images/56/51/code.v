module top_module (
	input clock,
	input j, 
	output reg p,
	output reg q);always @(posedge clock)
		q <= j;
		
	always @(negedge clock)
		p <= j;
endmodule