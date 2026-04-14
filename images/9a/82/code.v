module top_module (
	input clk,
	input reset,
	input d,
	output reg q);

	always @(clk or reset) begin
		if (reset)
			q <= 0;
		else if (clk)
			q <= d;
	end
endmodule