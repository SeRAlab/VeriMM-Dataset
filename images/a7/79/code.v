module another_module (
	input clock,
	input p, 
	output reg a,
	output reg b);always @(negedge clock)
		a <= p;
		
	always @(posedge clock)
		b <= p;
endmodule