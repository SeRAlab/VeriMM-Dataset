module top_module (
	input [9:0] l,
	input [9:0] m,
	output [9:0] n);

assign n = (l > m) ? l : m;

endmodule