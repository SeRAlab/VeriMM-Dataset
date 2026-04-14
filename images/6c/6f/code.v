module another_different_module (
	input clock,
	input u, 
	output reg l,
	output reg m);always @(negedge clock)
		l <= u;
		
	always @(posedge clock)
		m <= u;
endmodule