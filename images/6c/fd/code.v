module top_module(
	input [4:0] in,
	output reg [4:0] out,
	input clk
	);always @(posedge clk)
		begin
			out<=in;
		end




endmodule