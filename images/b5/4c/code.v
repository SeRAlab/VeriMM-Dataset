module yet_another_module (
	input clock,
	input x, 
	output reg p,
	output reg q);always @(negedge clock)
		p <= x;
		
	always @(posedge clock)
		q <= x;
endmodule