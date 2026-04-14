module new_module_10 (
	input clock,
	input a, 
	output reg b,
	output reg c);always @(negedge clock)
		b <= a;
		
	always @(posedge clock)
		c <= a;
endmodule