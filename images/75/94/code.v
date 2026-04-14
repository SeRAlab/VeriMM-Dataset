module top_module (
	input clk,
	input l,
	input m,
	input n,
	output reg out);

	initial
		out = 0;

	always@(posedge clk) begin
		out <= l ^ m ^ n;
	end

endmodule