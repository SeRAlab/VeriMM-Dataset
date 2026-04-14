module top_module(
	input clk,
	input reset_n,
	input enable,
	output reg [3:0] q);always @(posedge clk or negedge reset_n) begin
		if (!reset_n)
			q <= 4'b0000;
		else if (enable) begin
			if (q == 4'b1111)
				q <= 4'b0000;
			else
				q <= q + 1;
		end
	end

endmodule