module new_different_module (
	input clock,
	input r, 
	output reg c,
	output reg d);always @(negedge clock)
		c <= r;
		
	always @(posedge clock)
		d <= r;
endmodule