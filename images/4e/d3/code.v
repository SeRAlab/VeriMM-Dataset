module top_module(
	input p,
	input q,
	output reg r);assign r = p & ~q | ~p & q;

endmodule