module top_module(
input 					clk,
input 					reset,
input			[15:0]	nonce,
input 		[15:0]	digit,
output reg	[15:0]	out);always @(negedge clk)
	if(~reset)
		out = nonce;
	else
		out = digit;endmodule