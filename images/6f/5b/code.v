module top_module (
	input [2:0] in,
	output out_all_zero,
	output out_any_two,
	output out_alternating);assign out_all_zero = ~(in[0] | in[1] | in[2]);
	assign out_any_two = (in[0] & in[1]) | (in[1] & in[2]);
	assign out_alternating = (in[2] ^ in[1]) & (in[1] ^ in[0]);
	
endmodule