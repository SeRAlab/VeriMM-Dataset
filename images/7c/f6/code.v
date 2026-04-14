module top_module(
input 					clk,
input 					reset,
input			[15:0]	nonceF,
output reg	[15:0]	out);always @(negedge clk)
	if(~reset)
		out = nonceF;endmodule