module my_module (
	input clock,
	input b,
	output reg a,
	output reg c);always @(negedge clock)
	a <= ~b;

always @(posedge clock)
	c <= b;
endmodule