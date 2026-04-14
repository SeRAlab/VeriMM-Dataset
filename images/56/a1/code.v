module top_module (
	input clk,
	input rst,
	input i,
	input j,
	output reg out);

	initial
		out = 0;

	always@(posedge clk) begin
		if (rst)
			out <= 1;
		else
			out <= i & j;
	end

endmodule