module top_module (
	input [15:0] p,
	output [15:0] q);

assign q = p & 16'hF0F0;

endmodule