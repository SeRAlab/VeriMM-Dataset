module new_module_14 (
	input clock,
	input k, 
	output reg l,
	output reg m);always @(negedge clock)
		l <= k;
		
	always @(posedge clock)
		m <= k;
endmodule