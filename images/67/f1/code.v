module top_module (
	input [6:0] in,
	output out_majority,
	output out_zero_pairs,
	output out_shifted);assign out_majority = (in[0] + in[1] + in[2] + in[3] + in[4] + in[5] + in[6]) > 3;
	assign out_zero_pairs = (in[6] & in[5]) | (in[5] & in[4]) | (in[4] & in[3]) | (in[3] & in[2]) | (in[2] & in[1]) | (in[1] & in[0]);
	assign out_shifted = (in[6] == 1'b0) & (in[5] == in[4]) & (in[4] == in[3]) & (in[3] == in[2]) & (in[2] == in[1]) & (in[1] == in[0]);
	
endmodule