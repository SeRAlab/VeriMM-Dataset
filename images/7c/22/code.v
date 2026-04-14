module top_module(
	input [31:0] RT,
	input [31:0] EXT_E,
	input ALUsrc_rt,
	output [31:0] ALUsrc2
);assign ALUsrc2 = (ALUsrc_rt == 0)?RT:EXT_E;endmodule