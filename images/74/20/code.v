module top_module(
	input clk,
	input reset,
	output [7:0] q);logic [7:0] q_value;

	always @(posedge clk)
		if (reset) q_value <= 8'b0;

	assign q = q_value;

endmodule