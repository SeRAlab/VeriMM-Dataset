module top_module (
	input [3:0] in,
	output out_all_ones,
	output out_any_three,
	output out_all_different);assign out_all_ones = &in;
	assign out_any_three = (in[0] & in[1] & in[2]) | (in[1] & in[2] & in[3]);
	assign out_all_different = (in[0] ^ in[1]) & (in[1] ^ in[2]) & (in[2] ^ in[3]);
	
endmodule