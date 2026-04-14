module top_module(
	input clk,
	input reset,
	input load,
	input [7:0] data_in,
	output reg [7:0] q);always @(posedge clk) begin
		if (reset)
			q <= 8'b0;
		else if (load)
			q <= data_in;
	end

endmodule