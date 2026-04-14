module new_module_10 (
	input clock,
	input g, 
	output reg h,
	output reg i);always @(negedge clock)
		h <= g;
		
	always @(posedge clock)
		i <= g;
endmodule