module top_module (
	input p,
	input q,
	output reg g);assign g = ~(p & q);
endmodule