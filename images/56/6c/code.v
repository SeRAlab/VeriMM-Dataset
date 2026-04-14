module top_module(
	input clk,
	input reset,
	input enable,
	input [13:0] data_in,
	output reg [13:0] q);always @(posedge clk) begin
		if (reset)
			q <= 14'b00000000000000;
		else if (enable)
			q <= data_in;
	end

endmodule