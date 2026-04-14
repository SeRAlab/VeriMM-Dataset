module top_module (
	input clock,
	input n, 
	output reg l,
	output reg k);always @(negedge clock)
		l <= n;
		
	always @(posedge clock)
		k <= n;
endmodule