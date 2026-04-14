module another_new_module (
	input clock,
	input a, 
	output reg b,
	output reg y);always @(negedge clock)
		b <= a;
		
	always @(posedge clock)
		y <= a;
endmodule