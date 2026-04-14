module top_module (
	input clk,
	input rst,
	input p,
	input q,
	output reg out);

	initial
		out = 0;

	always@(posedge clk) begin
		if (rst)
			out <= 1;
		else
			out <= p ^ q;
	end

endmodule