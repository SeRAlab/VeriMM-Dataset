module top_module (
	input clk,
	input rst,
	input x,
	input y,
	output reg out);

	initial
		out = 0;

	always@(posedge clk) begin
		if (rst)
			out <= 0;
		else
			out <= ~(x | y);
	end

endmodule