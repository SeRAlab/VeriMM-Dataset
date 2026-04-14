module top_module(
	input [31:0] srcA, srcB,
	output eq
);assign eq = (srcA == srcB) ? 1 : 0;endmodule