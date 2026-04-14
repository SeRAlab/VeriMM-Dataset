module top_module(input clk, reset, enable,
									   input [3:0] d,
									   output reg [3:0] q);always@(posedge clk, posedge reset)
	if (reset) q <= 3'b0;
	else if (enable) q <= d;endmodule