module top_module (
	input clk,
	input w,
	input x,
	input y,
	output reg out);

	initial
		out = 0;

	always@(posedge clk) begin
		out <= w | x | y;
	end

endmodule