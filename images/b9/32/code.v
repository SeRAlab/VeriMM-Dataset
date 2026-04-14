module top_module (
	input clk,
	input rst_n,
	input x,
	input y,
	input z,
	output reg out);

	initial
		out = 0;

	always@(posedge clk or negedge rst_n) begin
		if (!rst_n)
			out <= 0;
		else
			out <= x & y & z;
	end

endmodule