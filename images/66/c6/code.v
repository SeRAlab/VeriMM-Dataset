module top_module (
	input clk,
	input rst,
	input w,
	input x,
	input y,
	input z,
	output reg out);

	initial
		out = 0;

	always@(posedge clk) begin
		if (rst)
			out <= 1;
		else
			out <= w & x & y & z;
	end

endmodule