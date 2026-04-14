module new_module (
	input clock,
	input d,
	output reg e,
	output reg f);always @(negedge clock)
	e <= d;

always @(posedge clock)
	f <= d;
endmodule