module top_module (
	input clock,
	input r, 
	output reg w,
	output reg z);always @(negedge clock)
		w <= r;
		
	always @(posedge clock)
		z <= r;
endmodule