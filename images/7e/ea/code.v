module top_module (
	input [3:0] w,
	input [3:0] x,
	output [3:0] y);assign y = ~(w ^ x);

endmodule