module top_module(
	input clk,
	input reset,
	input j,
	input k,
	output reg q);always @(posedge clk) begin
		if (reset)
			q <= 1'b0;
		else if (j && k)
			q <= ~q;
		else if (j)
			q <= 1'b1;
		else if (k)
			q <= 1'b0;
	end

endmodule