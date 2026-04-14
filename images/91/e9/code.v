module top_module(
	input a_i,
	input b_i,
	output s_i,
	output c_i
	);assign s_i=a_i^b_i;
assign c_i=a_i & b_i;endmodule