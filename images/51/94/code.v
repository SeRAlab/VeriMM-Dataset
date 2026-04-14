module top_module(
	input clk,
	input reset,
	input load,
	input [7:0] data_in,
	output reg [7:0] q);always @(posedge clk) begin
		if (reset)
			q <= 8'b11111111;
		else if (load)
			q <= data_in;
		else
			q <= {1'b0, q[7:1]};
	end
endmodule