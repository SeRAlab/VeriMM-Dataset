module new_module_3 (
	input clock,
	input m, 
	output reg n,
	output reg z);always @(negedge clock)
		n <= m;
		
	always @(posedge clock)
		z <= m;
endmodule