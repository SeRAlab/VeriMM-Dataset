module top_module(
	input clk,
	input load,
	input [7:0] d,
	output [7:0] q);logic [7:0] q_reg;

	always @(posedge clk)
		if (load) q_reg = d;
		else q_reg = q_reg << 1;

	assign q = q_reg;

endmodule