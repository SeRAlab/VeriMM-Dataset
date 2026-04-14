module top_module (
	input clk,
	input r,
	input s,
	input t,
	output reg out);

	initial
		out = 0;

	always@(posedge clk) begin
		out <= r ~^ s ~^ t;
	end

endmodule