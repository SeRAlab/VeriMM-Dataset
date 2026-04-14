module top_module (
	input clock,
	input y, 
	output reg p,
	output reg q);always @(negedge clock)
		p <= y;
		
	always @(posedge clock)
		q <= y;
endmodule