module top_module (
	input clk,
	input rst_n,
	input a,
	input b,
	input c,
	input d,
	output reg out);

	initial
		out = 0;

	always@(posedge clk or negedge rst_n) begin
		if (!rst_n)
			out <= 0;
		else
			out <= ~(a | b | c | d);
	end

endmodule