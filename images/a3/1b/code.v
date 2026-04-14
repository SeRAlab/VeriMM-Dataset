module top_module(
	input clk,
	input reset,
	input [31:0] data_in,
	output reg [31:0] q);always @(posedge clk) begin
		if (reset)
			q <= 32'b0;
		else
			q <= data_in;
	end

endmodule