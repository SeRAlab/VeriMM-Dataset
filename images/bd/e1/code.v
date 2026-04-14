module top_module (
	input clk,
	input p,
	input q,
	input r,
	input s,
	output reg out);

	initial
		out = 0;

	always@(posedge clk) begin
		out <= ~(p | q | r | s);
	end

endmodule