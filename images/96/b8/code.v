module top_module (
	input [7:0] a,
	input [7:0] b,
	output [7:0] s,
	output borrow);wire [8:0] diff = {1'b0, a} - {1'b0, b};
	assign s = diff[7:0];
	assign borrow = diff[8];
	
endmodule