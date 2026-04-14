module top_module (
	input [7:0] in,
	output out_most_ones,
	output out_continuous_zero,
	output out_equal_halves);assign out_most_ones = (in[7] + in[6] + in[5] + in[4]) > (in[3] + in[2] + in[1] + in[0]);
	assign out_continuous_zero = (in[7:5] == 3'b000) | (in[6:4] == 3'b000) | (in[5:3] == 3'b000) | (in[4:2] == 3'b000) | (in[3:1] == 3'b000) | (in[2:0] == 3'b000);
	assign out_equal_halves = (in[7:4] == in[3:0]);
	
endmodule