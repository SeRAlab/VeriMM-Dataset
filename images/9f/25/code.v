module top_module(
input	[7:0]	a, b,
input		cyin,
output	[7:0]	c,
output		cyout
);wire [8:0] t = a + b + cyin;
assign c = t[7:0];
assign cyout = t[8];endmodule