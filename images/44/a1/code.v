module yet_another_new_module (
	input clock,
	input q,
	output reg p,
	output reg r);always @(negedge clock)
	p <= ~q;

always @(posedge clock)
	r <= q;
endmodule