module new_module_17 (
	input clock,
	input v, 
	output reg w,
	output reg x);always @(negedge clock)
		w <= v;
		
	always @(posedge clock)
		x <= v;
endmodule