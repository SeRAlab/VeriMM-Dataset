module new_module_11 (
	input clock,
	input m, 
	output reg n,
	output reg p);always @(negedge clock)
		n <= m;
		
	always @(posedge clock)
		p <= m;
endmodule