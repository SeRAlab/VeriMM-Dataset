module top_module (
	input [3:0] x,
	output [3:0] z);

assign z = x << 2;

endmodule