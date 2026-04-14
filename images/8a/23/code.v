module different_module (
	input clock,
	input q, 
	output reg w,
	output reg z);always @(negedge clock)
		w <= q;
		
	always @(posedge clock)
		z <= q;
endmodule