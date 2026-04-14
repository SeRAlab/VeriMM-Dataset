module top_module (
	input clock,
	input u, 
	output reg h,
	output reg i);always @(negedge clock)
		h <= u;
		
	always @(posedge clock)
		i <= u;
endmodule