module top_module (
	input clk,
	input o,
	input p,
	input q,
	output reg out);

	initial
		out = 0;

	always@(posedge clk) begin
		out <= ~(o | p | q);
	end

endmodule