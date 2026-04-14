module top_module(
	input clk,
	input reset,
	input load,
	input [10:0] data_in,
	output reg [10:0] q);always @(posedge clk) begin
		if (reset)
			q <= 11'b0;
		else if (load)
			q <= data_in;
		else
			q <= {q[9:0], 1'b0};
	end
endmodule