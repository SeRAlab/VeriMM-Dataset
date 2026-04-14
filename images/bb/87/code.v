module top_module(
	input clk,
	input reset,
	output reg [15:0] q);always @(posedge clk) begin
		if (reset)
			q <= 16'b0;
		else begin
			q[0] <= ~q[15];
			q[15:1] <= q[14:0];
		end
	end
endmodule