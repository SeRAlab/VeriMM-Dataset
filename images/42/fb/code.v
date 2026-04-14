module top_module (
	input [8:0] in,
	output out_alt_pattern,
	output out_majority_zero,
	output out_symmetric);assign out_alt_pattern = (in[8] ^ in[7]) & (in[7] ^ in[6]) & (in[6] ^ in[5]) & (in[5] ^ in[4]) & (in[4] ^ in[3]) & (in[3] ^ in[2]) & (in[2] ^ in[1]) & (in[1] ^ in[0]);
	assign out_majority_zero = (in[0] + in[1] + in[2] + in[3] + in[4] + in[5] + in[6] + in[7] + in[8]) <= 4;
	assign out_symmetric = (in[8] == in[0]) & (in[7] == in[1]) & (in[6] == in[2]) & (in[5] == in[3]);
	
endmodule