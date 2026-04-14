module top_module(
	input clk,
	input reset,
	input enable,
	input [9:0] data_in,
	output reg [9:0] q);always @(posedge clk or posedge reset) begin
		if (reset)
			q <= 10'b0;
		else if (enable)
			q <= data_in;
	end

endmodule