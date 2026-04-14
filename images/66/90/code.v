module top_module (
	input clk,
	input c,
	input d,
	output reg out);

	initial
		out = 0;

	always@(posedge clk) begin
		out <= ~(c | d);
	end

endmodule