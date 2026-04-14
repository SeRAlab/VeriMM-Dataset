module top_module(
	input clk,
	input en,
	input [6:0] data_in,
	output reg [6:0] q);always @(posedge clk) begin
		if (en)
			q <= data_in;
	end
endmodule