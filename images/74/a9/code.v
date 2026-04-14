module new_module (
	input clock,
	input m, 
	output reg x,
	output reg y);always @(negedge clock)
		x <= m;
		
	always @(posedge clock)
		y <= m;
endmodule