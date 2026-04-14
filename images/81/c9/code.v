module top_module (
	input clk,
	input rst_n,
	input a,
	input b,
	input c,
	output reg out);

	initial
		out = 1;

	always@(posedge clk or negedge rst_n) begin
		if (!rst_n)
			out <= 1;
		else
			out <= a ^ b ^ c;
	end

endmodule