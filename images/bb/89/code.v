module top_module(
	input clk,
	input reset,
	input ena,
	output reg [3:0] q);always @(posedge clk) begin
		if (reset)
			q <= 4'b0;
		else if (ena)
			q <= q + 1;
	end
endmodule