module top_module(
	input clk,
	input reset,
	input enable,
	input [7:0] data_in,
	output reg [7:0] q);always @(posedge clk) begin
		if (reset)
			q <= 8'b00000000;
		else if (enable)
			q <= data_in;
	end

endmodule