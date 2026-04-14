module top_module (
	input i1,
	input i2,
	input i3,
	output reg o);
assign o = (i1 & ~i2 & ~i3) | (~i1 & i2 & ~i3) | (~i1 & ~i2 & i3);
endmodule