module new_module_19 (
	input clock,
	input b, 
	output reg c,
	output reg d);always @(negedge clock)
		c <= b;
		
	always @(posedge clock)
		d <= b;
endmodule