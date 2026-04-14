module top_module (
	input [1:0] a,
	input [1:0] b,
	output [3:0] y);assign y = {a, b};

endmodule