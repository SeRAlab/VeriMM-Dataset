module top_module(
	input clk,
	input reset,
	input [9:0] data_in,
	output reg [9:0] q);always @(posedge clk) begin
		if (reset)
			q <= 10'b0;
		else
			q <= data_in;
	end

endmodule