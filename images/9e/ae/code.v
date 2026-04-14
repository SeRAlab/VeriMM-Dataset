module top_module(
	input [3:0] a,
	input [3:0] b,
	output [3:0] diff,
	output borrow_out);assign {borrow_out, diff} = {1'b0, a} - b;
	
endmodule