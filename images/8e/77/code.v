module top_module (
	input [9:0] in,
	output out_contiguous_ones,
	output out_less_than_five,
	output out_reverse_equal);assign out_contiguous_ones = (in[9:6] == 4'b1111) | (in[8:5] == 4'b1111) | (in[7:4] == 4'b1111) | (in[6:3] == 4'b1111) | (in[5:2] == 4'b1111) | (in[4:1] == 4'b1111) | (in[3:0] == 4'b1111);
	assign out_less_than_five = (in[0] + in[1] + in[2] + in[3] + in[4] + in[5] + in[6] + in[7] + in[8] + in[9]) < 5;
	assign out_reverse_equal = (in[9:0] == {in[0], in[1], in[2], in[3], in[4], in[5], in[6], in[7], in[8], in[9]});
	
endmodule