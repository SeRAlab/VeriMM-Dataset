module top_module (
	input i1,
	input i2,
	output reg o);assign o = ~i1 & i2;
endmodule