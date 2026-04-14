module new_module_9 (
	input clock,
	input y, 
	output reg z,
	output reg w);always @(negedge clock)
		z <= y;
		
	always @(posedge clock)
		w <= y;
endmodule