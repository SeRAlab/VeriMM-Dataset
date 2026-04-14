module top_module(
	input clk,
	input enable,
	input [7:0] data,
	output reg [7:0] q);always @(posedge clk) begin
		if (enable)
			q <= data;
	end
endmodule