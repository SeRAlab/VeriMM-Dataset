module adder_subtractor (
	input [3:0] a,
	input [3:0] b,
	input mode,
	output [4:0] result);

	wire [3:0] b_complement;

	assign b_complement = mode ? ~b + 1 : b;
	assign result = a + b_complement;
endmodule