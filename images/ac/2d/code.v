module top_module (
	input clk,
	input x,
	input y,
	output reg out);

	initial
		out = 0;

	always@(posedge clk) begin
		out <= x ^ y;
	end

endmodule