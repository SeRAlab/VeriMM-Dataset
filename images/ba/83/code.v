module top_module (
	input clk,
	input j,
	input k,
	input l,
	input m,
	output reg out);

	initial
		out = 0;

	always@(posedge clk) begin
		out <= j & k & l & m;
	end

endmodule