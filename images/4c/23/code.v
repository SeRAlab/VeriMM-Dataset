module top_module (
	input clock,
	input k, 
	output reg u,
	output reg v);always @(negedge clock)
		u <= k;
		
	always @(posedge clock)
		v <= k;
endmodule