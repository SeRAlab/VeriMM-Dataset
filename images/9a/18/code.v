module some_module (
	input clock,
	input t,
	output reg s,
	output reg r);always @(negedge clock)
	s <= t;

always @(posedge clock)
	r <= ~t;
endmodule