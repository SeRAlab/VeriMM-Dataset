module top_module (
	input clk,
	input i,
	input j,
	input k,
	output reg out);

	initial
		out = 0;

	always@(posedge clk) begin
		out <= i | j | k;
	end

endmodule