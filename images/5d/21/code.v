module top_module (
	input [5:0] b,
	output [5:0] c);

assign c = ~b;

endmodule