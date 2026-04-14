module top_module(
	input [5:-7] in,
	output signed [7:-7] out );assign out = {2'b0, in} ;
endmodule