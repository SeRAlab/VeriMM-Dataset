module new_module_13 (
	input clock,
	input g, 
	output reg h,
	output reg j);always @(negedge clock)
		h <= g;
		
	always @(posedge clock)
		j <= g;
endmodule