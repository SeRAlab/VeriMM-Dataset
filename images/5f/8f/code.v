module top_module (
	input [10:0] in,
	output out_all_zeros_excluding,
	output out_any_five,
	output out_palindromic);assign out_all_zeros_excluding = ~(in[10] | in[9] | in[8] | in[7] | in[6] | in[4] | in[3] | in[2] | in[1] | in[0]) & in[5];
	assign out_any_five = (in[10:6] == 5'b11111) | (in[9:5] == 5'b11111) | (in[8:4] == 5'b11111) | (in[7:3] == 5'b11111) | (in[6:2] == 5'b11111) | (in[5:1] == 5'b11111) | (in[4:0] == 5'b11111);
	assign out_palindromic = (in[10] == in[0]) & (in[9] == in[1]) & (in[8] == in[2]) & (in[7] == in[3]) & (in[6] == in[4]);
	
endmodule