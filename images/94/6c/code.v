module yet_another_module (
	input clock,
	input p,
	output reg r,
	output reg s);always @(negedge clock)
	r <= p;

always @(posedge clock)
	s <= p;
endmodule