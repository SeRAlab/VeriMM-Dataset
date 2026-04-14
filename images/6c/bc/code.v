module top_module (
	input [5:0] in,
	output [2:0] out_ones_count,
	output out_even_ones,
	output out_palindrome);assign out_ones_count = in[0] + in[1] + in[2] + in[3] + in[4] + in[5];
	assign out_even_ones = ~^in;
	assign out_palindrome = (in[5] == in[0]) & (in[4] == in[1]) & (in[3] == in[2]);
	
endmodule