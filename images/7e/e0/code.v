module top_module (
	input clk,
	input m,
	input n,
	input o,
	output reg out);

	initial
		out = 0;

	always@(posedge clk) begin
		out <= m & n & o;
	end

endmodule