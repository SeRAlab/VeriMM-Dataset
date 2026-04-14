module top_module (
	input [3:0] a,
	input [3:0] b,
	output gt);

	assign gt = (a > b);
endmodule