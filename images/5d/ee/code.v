module top_module(
	input clk,
	input reset_n,
	input [19:0] data_in,
	output reg [19:0] q);always @(posedge clk) begin
		if (!reset_n)
			q <= 20'b0;
		else
			q <= data_in;
	end

endmodule