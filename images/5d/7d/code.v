module top_module(
	input clk,
	input reset_n,
	input enable,
	input [7:0] data_in,
	output reg [7:0] q);always @(posedge clk) begin
		if (!reset_n)
			q <= 8'b0;
		else if (enable)
			q <= data_in;
	end

endmodule