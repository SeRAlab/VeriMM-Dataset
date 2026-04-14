module top_module (
	input [3:0] a,
	input [3:0] b,
	output out);

	assign out = (a > b) ? 1'b1 : 1'b0;
endmodule