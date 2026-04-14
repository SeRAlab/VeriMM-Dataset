module another_module (
	input clock,
	input q,
	output reg x,
	output reg y);always @(negedge clock)
	x <= q;

always @(posedge clock)
	y <= q;
endmodule