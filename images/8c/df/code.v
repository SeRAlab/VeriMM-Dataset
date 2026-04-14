module top_module(
	input clk,
	input reset,
	input load,
	input [11:0] data_in,
	output reg [11:0] q);always @(posedge clk) begin
		if (reset)
			q <= 12'b111111111111;
		else if (load)
			q <= data_in;
		else
			q <= {q[10:0], 1'b0};
	end
endmodule