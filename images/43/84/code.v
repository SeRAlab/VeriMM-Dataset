module top_module (
	input clk,
	input a,
	input b,
	input c,
	input d,
	output reg out);

	initial
		out = 0;

	always@(posedge clk) begin
		out <= a ^ b ^ c ^ d;
	end

endmodule