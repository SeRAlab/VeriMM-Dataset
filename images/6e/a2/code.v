module top_module(
	input clk,
	input reset,
	input shift_in,
	output reg [15:0] q);always @(posedge clk) begin
		if (reset)
			q <= 16'h1234;
		else
			q <= {shift_in, q[15:1]};
	end
endmodule