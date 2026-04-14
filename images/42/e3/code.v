module top_module(
	input [1:0]in,
	input [0:0]config_in,
	input config_rst,
	output out
);assign out = config_in[0]? in[1] : in[0];endmodule