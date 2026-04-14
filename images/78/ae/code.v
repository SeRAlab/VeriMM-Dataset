module top_module(
	input clk,
	input reset,
	input [15:0] data_in,
	output reg [15:0] q);always @(posedge clk) begin
		if (reset)
			q <= 16'b0000000000000000;
		else
			q <= data_in;
	end

endmodule