module one_more_module (
	input clock,
	input a,
	output reg b,
	output reg c);always @(negedge clock)
	b <= a;

always @(posedge clock)
	c <= a;
endmodule