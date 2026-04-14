module top_module(
	input [31:0] WD_M,
	input [31:0] DMout,
	input [1:0] WD_M_sel,
	output [31:0] WD_W
);assign WD_W = (WD_M_sel == 0)?WD_M:DMout;endmodule