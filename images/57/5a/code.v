module top_module(
	input clk,
	input reset_n,
	input d,
	output reg q);always @(posedge clk or negedge reset_n) begin
		if (!reset_n)
			q <= 0;
		else
			q <= d;
	end

endmodule