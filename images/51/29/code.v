module top_module (
	input [11:0] in,
	output out_even_bits,
	output out_odd_bits,
	output out_most_zeros);assign out_even_bits = in[0] & in[2] & in[4] & in[6] & in[8] & in[10];
	assign out_odd_bits = ~in[1] & ~in[3] & ~in[5] & ~in[7] & ~in[9] & ~in[11];
	assign out_most_zeros = (in[0] + in[1] + in[2] + in[3] + in[4] + in[5] + in[6] + in[7] + in[8] + in[9] + in[10] + in[11]) <= 6;
	
endmodule