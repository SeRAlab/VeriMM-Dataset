module top_module(
	input [3:0] a,
	input [3:0] b,
	output [3:0] difference,
	output borrow_out);assign {borrow_out, difference} = a - b;
endmodule